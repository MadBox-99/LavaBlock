"""Bio garden - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python bio_garden.py -- \
          --pass entity|shadow|tint|icon --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A sealed glass dome over a rack of six culture tubes, with a stirrer in the
middle and a vent turbine at the apex. Water and one other solution go in, and
a mass of grown algae comes out on a belt.

Three things had to be true of the animation. It has to show growth, because
growing is what the machine does and a turntable of seedlings only showed
rotation. It has to loop, so each tube drains over the tail of the sheet
rather than snapping back to empty. And the six tubes are on staggered phases,
so there is always one nearly full and one nearly empty and the rack reads as
a process rather than as one tube copied six times.

The algae itself is rendered into its own sheet and drawn as a working
visualisation, which Factorio multiplies by the recipe colour - so the same
model shows green, blue or red contents depending on what is piped in. That
sheet is rendered with everything else as a Cycles holdout, so the dome ribs
cut themselves out of it and it composites over the entity sheet exactly.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at,         # noqa: E402
                             box, MATS, mat, Spin, Grow)

TUBES = 6                       # culture tubes around the rim
# Fat and close in, not slim and spread out. At 64 px a tile the contents are
# the only thing on this machine worth looking at, and a slim tube renders
# them as a bead. Pulling the ring in is what buys the width, because the
# dome roof comes down fast towards the rim.
TUBE_R = 0.58                   # how far out they stand
TUBE_GLASS_R = 0.185
TUBE_COLLAR_R = 0.20
TUBE_BASE = 0.52                # sits on the planter rim
TUBE_TOP = 1.20

DOME_R = 1.18                   # glass dome, centred on the planter rim
DOME_Z = 0.50
DOME_SQUASH = 0.85              # a dome, not a ball, and 18 cm shorter for it

PLANTER_R = 1.24                # wide, so little bare deck is left showing


def dome_z(r):
    """Inside height of the dome at plan radius r."""
    return DOME_Z + DOME_SQUASH * math.sqrt(max(DOME_R ** 2 - r ** 2, 0.0))


assert TUBE_TOP + 0.02 < dome_z(TUBE_R + TUBE_COLLAR_R), \
    "culture tubes foul the dome"

STIR_SPIN = 120                 # three paddles, so a third of a turn closes it
STIR_ARM = 0.16                 # arm length from the shaft
STIR_PADDLE = 0.15
assert STIR_ARM + STIR_PADDLE < TUBE_R - TUBE_GLASS_R, \
    "stirrer paddles foul the culture tubes"

VENT_Z = 1.50                   # collar at the apex, where the vapour leaves
VENT_H = 0.12
VENT_TOP = VENT_Z + VENT_H / 2

TURBINE_BLADES = 4
TURBINE_SPIN = 360 / TURBINE_BLADES
TURB_Z = 1.70
TURB_LEN, TURB_CHORD, TURB_THK = 0.30, 0.12, 0.022
TURB_PITCH = math.radians(20)
TURB_BOTTOM = (TURB_Z - (TURB_LEN / 2) * math.sin(TURB_PITCH)
               - (TURB_THK / 2) * math.cos(TURB_PITCH) - 0.012)
assert TURB_BOTTOM > VENT_TOP, "vent turbine fouls its own collar"


def glass(name, alpha):
    """Alpha, not transmission: the sprite has to carry an alpha channel the
    game can composite, and a low alpha is what lets the contents read through
    the glass instead of disappearing behind a pale film."""
    m = mat(name, (0.105, 0.170, 0.150), 0.05, 0.0)
    m.node_tree.nodes['Principled BSDF'].inputs['Alpha'].default_value = alpha
    return m


def ring(into, loc, major, minor, material, rot=(0, 0, 0), segments=40):
    bpy.ops.mesh.primitive_torus_add(location=loc, rotation=rot,
                                     major_radius=major, minor_radius=minor,
                                     major_segments=segments, minor_segments=8)
    o = bpy.context.object
    o.data.materials.append(material)
    into.append(o)
    return o


def bar(p1, p2, thickness, material):
    """A square bar spanning two points, for building a curved rib out of
    straight segments. A box rotated by (0, pitch, yaw) sends its local +X to
    (cos p cos y, cos p sin y, -sin p), so the pitch is negated."""
    d = (p2[0] - p1[0], p2[1] - p1[1], p2[2] - p1[2])
    length = math.sqrt(sum(c * c for c in d))
    mid = tuple((a + b) / 2 for a, b in zip(p1, p2))
    yaw = math.atan2(d[1], d[0])
    pitch = -math.asin(d[2] / length)
    return box(length, thickness, thickness, mid, rot=(0, pitch, yaw),
               m=material)


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['glass'] = glass("glass", 0.08)
    # The tubes are read through twice as much glass as the dome and hold the
    # thing the player is meant to be looking at, so they are clearer still.
    m['tube'] = glass("tube", 0.05)
    # Same painted green as the arboretum's frame, for the same reason: thin
    # bars at high metalness blow out into pale specular at this size.
    m['frame'] = mat("frame", (0.030, 0.052, 0.034), 0.55, 0.25, wear=0.50)
    m['panel'] = mat("panel", (0.020, 0.080, 0.060), 0.30, 0.2,
                     emit=(0.25, 1.00, 0.55), emit_str=1.6)
    # Lit deck plate needs a genuinely dark albedo: the shared 'dark' is
    # tuned for surfaces that sit in a machine's own shadow, and this one
    # is out in the sun with nothing standing on it.
    m['deck'] = mat("deck", (0.042, 0.042, 0.039), 0.80, 0.20, wear=0.55)
    m['basin'] = mat("basin", (0.035, 0.055, 0.050), 0.75, 0.10, wear=0.45)
    # The algae. In its own sheet it has to be near-neutral, because Factorio
    # multiplies that sheet by the recipe colour and any hue left in it would
    # fight the tint - a green culture would go black under the red recipe.
    # The icon is not tinted, so there it gets to be actual algae green.
    m['algae'] = mat("algae",
                     (0.720, 0.720, 0.705) if fr.PASS == 'tint'
                     else (0.095, 0.380, 0.130),
                     0.33, 0.0)

    static, spin = [], []

    # --- skid base --------------------------------------------------------
    static.append(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    static.append(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            static.append(cyl_at(sx * 1.24, sy * 1.24, 0.23, 0.075, 0.08,
                                 m['steel'], verts=6))

    # --- planter wall the dome sits on ------------------------------------
    static.append(cyl_at(0, 0, 0.34, PLANTER_R, 0.36, m['iron'], verts=40))
    ring(static, (0, 0, 0.52), PLANTER_R + 0.01, 0.05, m['frame'])
    for i in range(8):                                   # buttresses
        a = 2 * math.pi * i / 8
        static.append(box(0.16, 0.11, 0.34,
                          ((PLANTER_R - 0.03) * math.cos(a),
                           (PLANTER_R - 0.03) * math.sin(a), 0.33),
                          rot=(0, 0, a), m=m['frame']))

    # --- corner plant: what makes it read as equipment, not an ornament ---
    static.append(box(0.46, 0.36, 0.56, (1.00, -1.00, 0.47), m=m['iron']))
    static.append(box(0.26, 0.05, 0.14, (1.00, -1.19, 0.60), m=m['panel']))
    static.append(cyl_at(-1.00, 1.00, 0.44, 0.26, 0.46, m['steel'], verts=24))
    static.append(cyl_at(-1.00, 1.00, 0.69, 0.27, 0.05, m['dark'], verts=24))
    for sx, sy in ((-1, -1), (1, 1)):
        static.append(cyl_at(sx * 1.02, sy * 1.02, 0.30, 0.10, 0.28,
                             m['steel'], verts=12))

    # --- nutrient basin the tubes stand in --------------------------------
    static.append(cyl_at(0, 0, 0.53, 0.98, 0.06, m['basin'], verts=40))

    # --- glass dome -------------------------------------------------------
    # A whole sphere: its lower half sits inside the planter wall and is never
    # seen, which is cheaper and tidier than cutting a hemisphere.
    bpy.ops.mesh.primitive_uv_sphere_add(radius=DOME_R, segments=40,
                                         ring_count=20, location=(0, 0, DOME_Z))
    dome = bpy.context.object
    dome.scale = (1.0, 1.0, DOME_SQUASH)
    dome.data.materials.append(m['glass'])
    static.append(dome)
    fr.CLEAR.append(dome)

    # Latitude rings alone read as loose hoops floating over the contents.
    # Meridians tie them together, and only then does the thing read as a
    # dome rather than as a stack of rings.
    def dome_pt(theta, phi):
        return (DOME_R * math.sin(theta) * math.cos(phi),
                DOME_R * math.sin(theta) * math.sin(phi),
                DOME_Z + DOME_SQUASH * DOME_R * math.cos(theta))

    thetas = [math.radians(t) for t in (0, 38, 64, 90)]
    for t in thetas[1:-1]:
        ring(static, (0, 0, dome_pt(t, 0)[2]), DOME_R * math.sin(t),
             0.026, m['frame'])
    # The ribs are offset half a step from the tubes, so a rib never stands
    # directly in front of the one thing the animation is about.
    for i in range(6):
        phi = 2 * math.pi * (i + 0.5) / 6
        for t0, t1 in zip(thetas, thetas[1:]):
            static.append(bar(dome_pt(t0, phi), dome_pt(t1, phi),
                              0.034, m['frame']))

    # --- culture tubes, and the algae filling them (animated) -------------
    # Each tube fills over the sheet and drains at the end, and the six are
    # evenly staggered, so the rack never empties all at once.
    col_h = TUBE_TOP - 0.10 - (TUBE_BASE + 0.05)
    for i in range(TUBES):
        a = 2 * math.pi * i / TUBES
        tx, ty = TUBE_R * math.cos(a), TUBE_R * math.sin(a)

        shell = cyl_at(tx, ty, (TUBE_BASE + TUBE_TOP) / 2, TUBE_GLASS_R,
                       TUBE_TOP - TUBE_BASE, m['tube'], verts=20)
        static.append(shell)
        fr.CLEAR.append(shell)
        static.append(cyl_at(tx, ty, TUBE_BASE + 0.03, TUBE_COLLAR_R, 0.07,
                             m['frame'], verts=20))
        # Dark, and no wider than the glass: a steel disc up here caught the
        # sun and turned six tubes into six white ellipses.
        static.append(cyl_at(tx, ty, TUBE_TOP - 0.03, TUBE_GLASS_R + 0.008,
                             0.06, m['dark'], verts=20))

        col = cyl_at(tx, ty, TUBE_BASE + 0.05 + col_h / 2, TUBE_GLASS_R - 0.03,
                     col_h, m['algae'], verts=20)
        fr.TINT.append(col)
        spin.append(Grow([col], pivot=(tx, ty, TUBE_BASE + 0.05),
                         phase=i / TUBES))

    # --- stirrer (animated) -----------------------------------------------
    stir = [cyl_at(0, 0, 0.76, 0.05, 0.48, m['steel'], verts=12)]
    stir.append(cyl_at(0, 0, 1.03, 0.11, 0.09, m['dark'], verts=12))
    for i in range(3):
        a = 2 * math.pi * i / 3
        stir.append(box(STIR_ARM * 2, 0.045, 0.045,
                        (0, 0, 0.60), rot=(0, 0, a), m=m['steel']))
        stir.append(box(0.05, STIR_PADDLE, 0.16,
                        ((STIR_ARM + 0.02) * math.cos(a),
                         (STIR_ARM + 0.02) * math.sin(a), 0.62),
                        rot=(0, 0, a), m=m['frame']))
    spin.append(Spin(stir, degrees=STIR_SPIN))

    # --- apex vent and its turbine (animated, the other way) --------------
    static.append(cyl_at(0, 0, VENT_Z, 0.16, VENT_H, m['frame'], verts=20))
    turb = [cyl_at(0, 0, TURB_Z, 0.06, 0.10, m['dark'], verts=12)]
    for i in range(TURBINE_BLADES):
        a = 2 * math.pi * i / TURBINE_BLADES
        b = box(TURB_LEN, TURB_CHORD, TURB_THK,
                (0.15 * math.cos(a), 0.15 * math.sin(a), TURB_Z),
                rot=(0, 0, a), m=m['steel'])
        b.rotation_euler[1] = TURB_PITCH
        turb.append(b)
    spin.append(Spin(turb, degrees=-TURBINE_SPIN))

    # --- fluid connections: water north, the strain's own solution south ---
    # Slim on purpose; the prototype leaves pipe_picture and pipe_covers off,
    # because a one-tile cover sprite cannot meet a stub that reaches past
    # that tile. See docs/blender-renders.md.
    for dx, dy in ((0, 1), (0, -1)):
        ang = math.atan2(dy, dx)
        axis = (math.pi / 2, 0, ang + math.pi / 2)
        static.append(box(0.34, 0.44, 0.40, (dx * 1.05, dy * 1.05, 0.36),
                          rot=(0, 0, ang), m=m['iron']))
        static.append(cyl_at(dx * 1.30, dy * 1.30, 0.36, 0.165, 0.70,
                             m['steel'], verts=24, rot=axis))
        static.append(cyl_at(dx * 1.46, dy * 1.46, 0.36, 0.215, 0.10,
                             m['dark'], verts=24, rot=axis))

    return static, spin


# Both spinning groups turn by a symmetry of their own part, and each Grow
# closes by draining, so every group is back where it started on the last
# frame.
fr.run(build)
