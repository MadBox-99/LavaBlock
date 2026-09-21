"""Bio garden - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python bio_garden.py -- \
          --pass entity|shadow|tint|icon --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A ribbed glass dome over a thickener pan with a slowly turning rake and a
discharge hopper at the front, a vent turbine at the apex, and a guided press
standing on the deck beside the dome.

The garden used to grow the algae as well; that job moved to the algae tank,
where the culture can be shown properly, and this building kept the other
half - pressing the harvest for what it metabolised, and scrubbing the air
while it works. The dome stays, because the dome is the scrubber and because
it is what makes this and the arboretum read as one family of building.

The pulp in the pan and the hopper window are rendered into their own sheet
and drawn as a working visualisation, which Factorio multiplies by the recipe
colour, so the dome shows what is being pressed from any facing.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             bar, torus_at, cone_at, MATS, mat, Spin, Slide)

DOME_R = 1.18                   # glass dome, centred on the planter rim
DOME_Z = 0.50
DOME_SQUASH = 0.85              # a dome, not a ball, and 18 cm shorter for it

PLANTER_R = 1.24                # wide, so little bare deck is left showing


def dome_z(r):
    """Inside height of the dome at plan radius r."""
    return DOME_Z + DOME_SQUASH * math.sqrt(max(DOME_R ** 2 - r ** 2, 0.0))


PAN_R = 0.82                    # thickener pan the rake sweeps
PAN_Z = 0.52
# Two arms, not three. Three radial arms turning over a round pan inside a
# ring of glazing bars read as a fan in a guard cage, which is the one thing
# this building must not look like - the mod already has three fans. Two
# arms are a bridge across the tank, which is what a thickener actually has.
RAKE_ARMS = 2
RAKE_SPIN = 360 / RAKE_ARMS     # a bridge, so half a turn closes it
RAKE_Z = 0.74
RAKE_REACH = PAN_R * 0.95       # the bridge stops just short of the pan rim
assert RAKE_Z + 0.10 < dome_z(RAKE_REACH), "rake bridge hits the dome"

# The hopper and the press both sit outside the glass, on the near corners.
# There is no room for either inside: the bridge sweeps the whole pan, and
# under a dome 1.5 m tall nothing can stand taller than the bridge anyway.
HOPPER_X, HOPPER_Y, HOPPER_R = -1.06, -1.06, 0.26
assert math.hypot(HOPPER_X, HOPPER_Y) - HOPPER_R > DOME_R, "hopper hits the dome"

# The press stands on the deck, outside the dome. It began inside, over the
# pan, and that was wrong twice over: the rake arms swept straight through
# it, and its ram had nowhere to rise to under a dome 1.5 m tall. A press is
# plant equipment anyway, so it belongs on the skid beside the glass, where
# it can be as tall as it needs to be and gives the silhouette something
# besides the dome.
PRESS_X, PRESS_Y = 1.06, -1.02
PRESS_R = 0.22
PRESS_BODY_TOP = 0.76
GUIDE_X, GUIDE_R = 0.17, 0.05
PRESS_CROWN_Z = 1.14
PLATEN_Z, RAM_STROKE = 0.84, 0.08
assert math.hypot(PRESS_X, PRESS_Y) - PRESS_R > DOME_R, "press body hits the dome"
assert math.hypot(PRESS_X - GUIDE_X, PRESS_Y) - GUIDE_R > DOME_R, \
    "press guide hits the dome"
assert PLATEN_Z + 0.13 + RAM_STROKE < PRESS_CROWN_Z - 0.045, "platen hits the crown"

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
    game can composite, and a low alpha is what lets the works read through
    the dome instead of disappearing behind a pale film."""
    m = mat(name, (0.105, 0.170, 0.150), 0.05, 0.0)
    m.node_tree.nodes['Principled BSDF'].inputs['Alpha'].default_value = alpha
    return m


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['glass'] = glass("glass", 0.08)
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
    # Settled pulp: what the pan holds when the machine is idle. Matte and
    # olive, so the tinted pool sitting a centimetre above it reads as the
    # same material lit up rather than as a separate object.
    m['sludge'] = mat("sludge", (0.088, 0.105, 0.058), 0.72, 0.0, wear=0.35)
    # The pressed product. Near-neutral in its own sheet, because Factorio
    # multiplies that sheet by the recipe colour and leftover hue would fight
    # the tint. The icon is not tinted, so there it gets a colour.
    m['product'] = mat("product",
                       (0.760, 0.760, 0.745) if fr.PASS == 'tint'
                       else (0.130, 0.330, 0.150),
                       0.32, 0.0)

    static, spin = [], []
    add = static.append

    PROUD = 0.022

    def window(x, y, z, w, h):
        """A pane standing just proud of the shell, with a dark recess behind
        it. Never sunk into the shell: in the tint pass every non-tinted
        object is a holdout, so a recessed pane has all but its rim cut away
        and renders as a thin ring."""
        add(box(w + 0.045, 0.10, h + 0.045, (x, y + 0.05, z), m=m['dark']))
        lq = box(w, 0.03, h, (x, y - PROUD, z), m=m['product'])
        add(lq)
        fr.TINT.append(lq)

    # --- skid base --------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(cyl_at(sx * 1.24, sy * 1.24, 0.23, 0.075, 0.08,
                       m['steel'], verts=6))

    # --- planter wall the dome sits on ------------------------------------
    add(cyl_at(0, 0, 0.34, PLANTER_R, 0.36, m['iron'], verts=40))
    add(torus_at((0, 0, 0.52), PLANTER_R + 0.01, 0.034, m['frame']))
    for i in range(8):                                   # buttresses
        a = 2 * math.pi * i / 8
        add(box(0.16, 0.11, 0.34,
                ((PLANTER_R - 0.03) * math.cos(a),
                 (PLANTER_R - 0.03) * math.sin(a), 0.33),
                rot=(0, 0, a), m=m['frame']))

    # --- corner plant: what makes it read as equipment, not an ornament ---
    add(cyl_at(-1.00, 1.00, 0.44, 0.26, 0.46, m['steel'], verts=24))
    add(cyl_at(-1.00, 1.00, 0.69, 0.27, 0.05, m['dark'], verts=24))
    add(cyl_at(1.02, 1.02, 0.30, 0.10, 0.28, m['steel'], verts=12))

    # --- thickener pan ----------------------------------------------------
    add(cyl_at(0, 0, PAN_Z + 0.03, PAN_R, 0.07, m['basin'], verts=40))
    add(torus_at((0, 0, PAN_Z + 0.07), PAN_R, 0.026, m['frame']))
    # The pan full of pulp, tinted by the recipe. The hopper window alone
    # showed the colour from one side only - turn the machine and the works
    # hid it. A pool read straight down through the glass survives every
    # facing, and the rake cuts across it, which is the point of the rake.
    add(cyl_at(0, 0, PAN_Z + 0.075, PAN_R - 0.05, 0.05, m['sludge'],
               verts=40))
    pool = cyl_at(0, 0, PAN_Z + 0.105, PAN_R - 0.06, 0.05, m['product'],
                  verts=40)
    add(pool)
    fr.TINT.append(pool)
    add(cyl_at(0, 0, PAN_Z + 0.10, 0.16, 0.14, m['dark'], verts=16))

    # --- glass dome -------------------------------------------------------
    # A whole sphere: its lower half sits inside the planter wall and is never
    # seen, which is cheaper and tidier than cutting a hemisphere.
    bpy.ops.mesh.primitive_uv_sphere_add(radius=DOME_R, segments=40,
                                         ring_count=20, location=(0, 0, DOME_Z))
    dome = bpy.context.object
    dome.scale = (1.0, 1.0, DOME_SQUASH)
    dome.data.materials.append(m['glass'])
    add(dome)
    fr.CLEAR.append(dome)

    # Latitude rings alone read as loose hoops floating over the works.
    # Meridians tie them together, and only then does the thing read as a
    # dome rather than as a stack of rings.
    def dome_pt(theta, phi):
        return (DOME_R * math.sin(theta) * math.cos(phi),
                DOME_R * math.sin(theta) * math.sin(phi),
                DOME_Z + DOME_SQUASH * DOME_R * math.cos(theta))

    thetas = [math.radians(t) for t in (0, 38, 64, 90)]
    for t in thetas[1:-1]:
        add(torus_at((0, 0, dome_pt(t, 0)[2]), DOME_R * math.sin(t), 0.021,
                     m['frame']))
    # The ribs are offset half a step from the press and the hopper, so a rib
    # never stands directly in front of the parts that move.
    for i in range(6):
        phi = 2 * math.pi * (i + 0.5) / 6
        for t0, t1 in zip(thetas, thetas[1:]):
            add(bar(dome_pt(t0, phi), dome_pt(t1, phi), 0.026, m['frame']))

    # --- the rake (animated) ----------------------------------------------
    # Slow and three-armed: a thickener rake is the one piece of equipment
    # that turns visibly without being a fan, which keeps this machine from
    # reading as another fan box.
    rake = [cyl_at(0, 0, 0.90, 0.07, 0.34, m['steel'], verts=12)]
    for i in range(RAKE_ARMS):
        a = 2 * math.pi * i / RAKE_ARMS
        rake.append(box(RAKE_REACH * 2, 0.048, 0.048, (0, 0, RAKE_Z),
                        rot=(0, 0, a), m=m['steel']))
        for f in (0.34, 0.58, 0.82):
            rake.append(box(0.05, 0.10, 0.10,
                            (RAKE_REACH * f * math.cos(a),
                             RAKE_REACH * f * math.sin(a),
                             RAKE_Z - 0.07), rot=(0, 0, a), m=m['frame']))
    spin.append(Spin(rake, degrees=RAKE_SPIN))

    # --- press on the deck, and its platen (animated) ---------------------
    # Two guide columns under a crown with the platen riding between them: a
    # ram on a bare cylinder reads as a piston, and every other machine in
    # the mod already has one of those. A platen between guides reads as a
    # press, which is the one thing this building has to say.
    add(cyl_at(PRESS_X, PRESS_Y, (0.18 + PRESS_BODY_TOP) / 2, PRESS_R,
               PRESS_BODY_TOP - 0.18, m['steel'], verts=24))
    add(torus_at((PRESS_X, PRESS_Y, 0.56), PRESS_R + 0.012, 0.026, m['frame']))
    add(cyl_at(PRESS_X, PRESS_Y, PRESS_BODY_TOP + 0.04, PRESS_R + 0.04, 0.08,
               m['dark'], verts=24))
    add(box(0.26, 0.05, 0.14, (PRESS_X, PRESS_Y - PRESS_R - 0.02, 0.52),
            m=m['panel']))
    for sx in (-1, 1):
        add(cyl_at(PRESS_X + sx * GUIDE_X, PRESS_Y,
                   (PRESS_BODY_TOP + PRESS_CROWN_Z) / 2, GUIDE_R,
                   PRESS_CROWN_Z - PRESS_BODY_TOP, m['steel'], verts=10))
    add(box(2 * GUIDE_X + 0.16, 0.34, 0.09, (PRESS_X, PRESS_Y, PRESS_CROWN_Z),
            m=m['steel']))
    platen = [box(2 * GUIDE_X + 0.04, 0.28, 0.10,
                  (PRESS_X, PRESS_Y, PLATEN_Z), m=m['frame'])]
    platen.append(cyl_at(PRESS_X, PRESS_Y, PLATEN_Z + 0.08, 0.05, 0.10,
                         m['steel'], verts=12))
    spin.append(Slide(platen, axis='Z', amplitude=RAM_STROKE))

    # --- discharge hopper on the near corner, with the product window -----
    add(cone_at(HOPPER_X, HOPPER_Y, 0.54, HOPPER_R, HOPPER_R * 0.55, 0.40,
                m['steel']))
    add(cyl_at(HOPPER_X, HOPPER_Y, 0.78, HOPPER_R * 0.58, 0.06, m['dark'],
               verts=20))
    window(HOPPER_X, HOPPER_Y - 0.19, 0.58, 0.22, 0.16)
    # The launder out of the pan, ducking over the planter wall to the
    # hopper. It leaves on the diagonal, where the bridge cannot reach it.
    add(bar((-PAN_R * 0.70, -PAN_R * 0.70, 0.60),
            (HOPPER_X + 0.18, HOPPER_Y + 0.18, 0.66), 0.055, m['steel']))

    # --- apex vent and its turbine (animated, the other way) --------------
    add(cyl_at(0, 0, VENT_Z, 0.16, VENT_H, m['frame'], verts=20))
    turb = [cyl_at(0, 0, TURB_Z, 0.06, 0.10, m['dark'], verts=12)]
    for i in range(TURBINE_BLADES):
        a = 2 * math.pi * i / TURBINE_BLADES
        b = box(TURB_LEN, TURB_CHORD, TURB_THK,
                (0.15 * math.cos(a), 0.15 * math.sin(a), TURB_Z),
                rot=(0, 0, a), m=m['steel'])
        b.rotation_euler[1] = TURB_PITCH
        turb.append(b)
    spin.append(Spin(turb, degrees=-TURBINE_SPIN))

    # --- fluid connections: water in north, liquid nitrogen out south -----
    # Slim on purpose; the prototype leaves pipe_picture and pipe_covers off,
    # because a one-tile cover sprite cannot meet a stub that reaches past
    # that tile. See docs/blender-renders.md.
    for dx, dy in ((0, 1), (0, -1)):
        add(box(0.34, 0.44, 0.40, (dx * 1.05, dy * 1.05, 0.36), m=m['iron']))
        add(cyl_at(dx * 1.30, dy * 1.30, 0.36, 0.165, 0.70, m['steel'],
                   verts=24, rot=(math.pi / 2, 0, 0)))
        add(cyl_at(dx * 1.46, dy * 1.46, 0.36, 0.215, 0.10, m['dark'],
                   verts=24, rot=(math.pi / 2, 0, 0)))

    return static, spin


# The rake and the turbine each turn by a symmetry of their own part and the
# ram closes on its own sine, so every group lands on frame 0 again.
fr.run(build)
