"""Arc Furnace - Factorio 5x5 entity, rendered at 64 px/tile.

  render_all.sh arc_furnace.py arc-furnace <scratch> 32

The camera, materials, primitives and render loop live in factorio_render.

An electric arc furnace: a round, water-cooled shell on a refractory
hearth, a pale refractory roof, and three graphite electrodes standing up
through it, each held by its own arm from its own mast. The arcs burn
under the roof, where the player cannot see them; what shows is the
blue-white light round the foot of each electrode, which is the colour of
an electric arc and of nothing else on the island - every other hot thing
here glows orange.

Facing north it reads from the back of the sprite to the front:

  - the three masts in a row behind the shell, yellow, with the bus tube
    that feeds them running along behind them;
  - the transformer in the back left corner, low, with its cooling fan
    lying flat on top and its bushings on the side facing the masts;
  - the shell itself, a little south of centre, with the roof, the
    electrodes and the fume offtake leaving the roof towards the north east;
  - the slag door in the south west of the shell and the tap spout in the
    south east, both glowing orange while the furnace runs; the spout runs
    down a launder into a tundish on the deck.

The arms reach from the masts at the back out to the electrodes and stop
at the clamps. They have to cross the back of the roof - an arc furnace
whose electrodes hang from nothing is not one - but nothing crosses the
front, and the light round the electrode feet is never under an arm: the
arms run at the clamp height, a metre above it, and end there.

The three electrodes are set out across X, at 0.43 tiles apart against a
0.30 diameter, so they read as three in the north and south sheets
(docs/blender-renders.md, "Depth separates badly"). In east and west they
close up into fewer, which no arrangement of three can avoid.

Two kinds of motion. Each electrode rides up and down on its mast with its
arm and clamp, a third of a stroke out of step with the next, which is the
regulator holding each arc at its length. And the transformer's fan turns
lying flat, so it shows in every facing. Six blades, closing on 60 degrees.

The ports, Blender +Y being north and Factorio counting Y southwards:

  - inputs on the west and the east flank, at the front: {-2, 1} and {2, 1};
  - the molten metal out of the tundish at the front, {1, 2};
  - the gas off the melt out of the fume offtake, which comes down from the
    roof to the east flank at the back, {2, -1}.

The working light is the electrode-foot glow, the slag door and the metal
in the launder and tundish, modelled twice: dark in the entity sheet, lit
just proud of it in fr.TINT.

FOUR facings: the transformer, the offtake and the ports sit on named
sides.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, cone_at,  # noqa: E402
                             box, bar, torus_at, MATS, mat, Spin, Slide)

DECK_TOP = 0.21

# --- the shell -----------------------------------------------------------
VX, VY = 0.0, -0.30              # a little south, so the masts have room
HEARTH_TOP = 0.62
SHELL_R = 1.45
SHELL_TOP = 1.28
ROOF_BASE = 1.38
ROOF_R = 1.40
DELTA_R = 0.80                   # the flat refractory centre the ports are in
DELTA_TOP = ROOF_BASE + 0.30 + 0.06

# --- the electrodes ------------------------------------------------------
PITCH_R = 0.50                   # the ports' circle on the roof
EL_R = 0.15
EL_TOP = 3.10
# Angles on the pitch circle: one at the back, two at the front. Measured
# from +X, so 90 is north.
EL_ANGLES = (90.0, 210.0, 330.0)

# --- masts and arms ------------------------------------------------------
MAST_Y = 1.78
MAST_R = 0.12
MAST_TOP = 3.25
ARM_Z = 2.85
STROKE = 0.06                    # how far an electrode rides, each way

# --- the transformer -----------------------------------------------------
TX, TY = -1.82, 1.02
TW, TD, TH = 0.80, 1.06, 0.92
FAN_R = 0.28
FAN_Z = DECK_TOP + TH + 0.10


def electrode_xy(a_deg):
    a = math.radians(a_deg)
    return VX + PITCH_R * math.cos(a), VY + PITCH_R * math.sin(a)


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.050, 0.048, 0.046), 0.80, 0.20, wear=0.55)
    # Water-cooled panels: blue-grey steel, darker than the compressor's
    # casing, so the pale roof is the lightest thing on the machine.
    m['shell'] = mat("shell", (0.120, 0.138, 0.165), 0.50, 0.85, wear=0.75)
    m['brick'] = mat("brick", (0.196, 0.134, 0.106), 0.88, 0.0, wear=0.66)
    # Refractory roof. Light, so no wear (it would turn it into a spotted
    # dark grey), and darker in the swatch than it is meant to read: the
    # icon sun takes a pale colour to white.
    m['roof'] = mat("roof", (0.260, 0.240, 0.215), 0.86, 0.0)
    m['graphite'] = mat("graphite", (0.050, 0.050, 0.056), 0.42, 0.35)
    m['joint'] = mat("joint", (0.120, 0.118, 0.122), 0.38, 0.6)
    m['copper'] = mat("copper", (0.620, 0.300, 0.110), 0.30, 1.0, wear=0.45)
    m['tx'] = mat("tx", (0.105, 0.128, 0.092), 0.55, 0.6, wear=0.70)
    m['porcelain'] = mat("porcelain", (0.300, 0.165, 0.090), 0.30, 0.0)
    m['port'] = mat("port", (0.030, 0.026, 0.030), 0.18, 0.0)
    # The arc's light: blue-white, the one cold glow in the mod. Saturated
    # in blue at 1.0, so it holds its colour instead of clipping to white.
    m['arc'] = mat("arc", (0.040, 0.055, 0.090), 0.30, 0.0,
                   emit=(0.52, 0.70, 1.00), emit_str=1.0)
    # The slag door: the warm-glow ceiling of docs/blender-renders.md,
    # emit_str * red under 0.5, or it walks off to lemon.
    m['slag'] = mat("slag", (0.118, 0.042, 0.014), 0.70, 0.0,
                    emit=(1.00, 0.34, 0.05), emit_str=0.46)

    static, moving = [], []
    add = static.append

    def glow(o):
        """Part of the working light: in fr.TINT, so it is left out of the
        entity sheet and becomes the whole of the glow sheet."""
        fr.TINT.append(o)
        static.append(o)

    # --- plinth -----------------------------------------------------------
    add(box(4.92, 4.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(4.72, 4.72, 0.09, (0, 0, 0.165), m=m['deck']))

    # --- hearth and shell -------------------------------------------------
    # The tilting cradle the shell sits in, then the brick hearth, then the
    # water-cooled panels.
    add(cyl_at(VX, VY, DECK_TOP + 0.05, SHELL_R + 0.07, 0.10, m['steel'],
               verts=48))
    add(cyl_at(VX, VY, (DECK_TOP + HEARTH_TOP) / 2, SHELL_R - 0.03,
               HEARTH_TOP - DECK_TOP, m['brick'], verts=48))
    add(cyl_at(VX, VY, (HEARTH_TOP + SHELL_TOP) / 2, SHELL_R,
               SHELL_TOP - HEARTH_TOP, m['shell'], verts=48))
    # Panel seams: the shell is a ring of cooling panels, and a plain
    # cylinder at this size is a tin can.
    for i in range(20):
        a = 2 * math.pi * (i + 0.5) / 20
        add(box(0.05, 0.07, SHELL_TOP - HEARTH_TOP - 0.06,
                (VX + (SHELL_R + 0.02) * math.cos(a),
                 VY + (SHELL_R + 0.02) * math.sin(a),
                 (HEARTH_TOP + SHELL_TOP) / 2),
                rot=(0, 0, a), m=m['steel']))
    # The cooling-water headers round the top and bottom of the panels.
    for z in (HEARTH_TOP + 0.04, SHELL_TOP - 0.02):
        add(torus_at((VX, VY, z), SHELL_R + 0.04, 0.045, m['steel'],
                     segments=48))

    # --- roof -------------------------------------------------------------
    add(cyl_at(VX, VY, ROOF_BASE - 0.05, SHELL_R + 0.05, 0.10, m['shell'],
               verts=48))
    # The outer roof is water-cooled panels like the shell, ribbed with
    # their pipes; only the centre round the electrodes is refractory. A
    # whole roof of pale brick was a white disc the electrodes were lost on.
    add(cone_at(VX, VY, ROOF_BASE, ROOF_R, DELTA_R, 0.30, m['shell'],
                verts=48))
    slope = math.atan2(0.30, ROOF_R - DELTA_R)
    for i in range(16):
        a = 2 * math.pi * (i + 0.5) / 16
        c, s = math.cos(a), math.sin(a)
        lift = 0.03 / math.cos(slope)
        add(bar((VX + (ROOF_R - 0.04) * c, VY + (ROOF_R - 0.04) * s,
                 ROOF_BASE + 0.02 + lift),
                (VX + (DELTA_R + 0.04) * c, VY + (DELTA_R + 0.04) * s,
                 ROOF_BASE + 0.28 + lift), 0.045, m['steel']))
    add(cyl_at(VX, VY, ROOF_BASE + 0.33, DELTA_R, 0.06, m['roof'],
               verts=40))

    # --- electrodes, clamps, arms ----------------------------------------
    for k, a_deg in enumerate(EL_ANGLES):
        ex, ey = electrode_xy(a_deg)
        # The port: a water-cooled collar round a dark gap, and in the glow
        # sheet the light coming up through that gap.
        add(cyl_at(ex, ey, DELTA_TOP + 0.01, EL_R + 0.10, 0.04, m['port'],
                   verts=24))
        add(torus_at((ex, ey, DELTA_TOP + 0.045), EL_R + 0.09, 0.028,
                     m['steel'], segments=24))
        glow(cyl_at(ex, ey, DELTA_TOP + 0.034, EL_R + 0.085, 0.02,
                    m['arc'], verts=24))

        group = []
        # The electrode itself, in three columns screwed end to end; the
        # joints are what make a black rod read as a graphite electrode.
        h = EL_TOP - (DELTA_TOP - 0.10)
        group.append(cyl_at(ex, ey, DELTA_TOP - 0.10 + h / 2, EL_R, h,
                            m['graphite'], verts=24))
        for z in (DELTA_TOP + 0.34, DELTA_TOP + 0.70):
            group.append(cyl_at(ex, ey, z, EL_R + 0.008, 0.025, m['joint'],
                                verts=24))
        # Clamp head, then the arm back to its mast, then the sleeve the arm
        # rides the mast on. Copper: the arm carries the current.
        arm_z = ARM_Z + (0.12 if k == 0 else 0.0)
        group.append(box(0.32, 0.32, 0.20, (ex, ey, arm_z), m=m['copper']))
        group.append(box(0.12, MAST_Y - ey, 0.14,
                         (ex, (MAST_Y + ey) / 2, arm_z), m=m['copper']))
        group.append(cyl_at(ex, MAST_Y, arm_z, MAST_R + 0.05, 0.34,
                            m['steel'], verts=20))
        moving.append(Slide(group, axis='Z', amplitude=STROKE,
                            phase=k / 3.0))

        # The mast, and the hydraulic cylinder at its foot that lifts it.
        add(cyl_at(ex, MAST_Y, (DECK_TOP + MAST_TOP) / 2, MAST_R,
                   MAST_TOP - DECK_TOP, m['yellow'], verts=20))
        add(cyl_at(ex, MAST_Y, MAST_TOP + 0.03, MAST_R + 0.02, 0.06,
                   m['steel'], verts=20))
        add(box(0.34, 0.34, 0.44, (ex, MAST_Y, DECK_TOP + 0.22),
                m=m['dark']))

    # --- bus tube behind the masts ---------------------------------------
    # Fed from the transformer and dropping to each mast; behind them, so
    # it is drawn over by them rather than over anything that works.
    BUS_Y, BUS_Z = MAST_Y + 0.32, 2.08
    add(cyl_at((TX + 0.35 + 0.55) / 2, BUS_Y, BUS_Z, 0.065,
               0.55 - (TX + 0.35), m['copper'], verts=16,
               rot=(0, math.pi / 2, 0)))
    for a_deg in EL_ANGLES:
        ex, _ = electrode_xy(a_deg)
        add(bar((ex, BUS_Y, BUS_Z), (ex, MAST_Y + MAST_R, BUS_Z + 0.18),
                0.06, m['copper']))

    # --- transformer, back left ------------------------------------------
    add(box(TW, TD, TH, (TX, TY, DECK_TOP + TH / 2), m=m['tx']))
    # Radiator fins on the west face, standing out from the tank.
    for i in range(7):
        y = TY - TD / 2 + 0.12 + i * (TD - 0.24) / 6
        add(box(0.16, 0.035, TH - 0.18, (TX - TW / 2 - 0.08, y,
                                          DECK_TOP + TH / 2), m=m['tx']))
    # Three bushings on the east side of the lid, and the bus from them up
    # to the tube behind the masts.
    for i in range(3):
        bx, by = TX + 0.26, TY - 0.30 + i * 0.30
        add(cyl_at(bx, by, DECK_TOP + TH + 0.13, 0.05, 0.26,
                   m['porcelain'], verts=12))
        for j in range(3):
            add(cyl_at(bx, by, DECK_TOP + TH + 0.06 + 0.07 * j, 0.075, 0.02,
                       m['porcelain'], verts=16))
    add(bar((TX + 0.26, TY + 0.30, DECK_TOP + TH + 0.26),
            (TX + 0.35, BUS_Y, BUS_Z), 0.07, m['copper']))
    # Cooling fan, lying flat in a shroud on the lid.
    fx, fy = TX - 0.12, TY + 0.05
    add(torus_at((fx, fy, FAN_Z + 0.02), FAN_R + 0.03, 0.035, m['steel'],
                 segments=32))
    add(cyl_at(fx, fy, FAN_Z - 0.06, FAN_R + 0.02, 0.06, m['steel'],
               verts=32))
    fan = [cyl_at(fx, fy, FAN_Z + 0.02, 0.07, 0.06, m['dark'], verts=16)]
    for i in range(6):
        a = 2 * math.pi * i / 6
        fan.append(box(FAN_R - 0.06, 0.09, 0.02,
                       (fx + (FAN_R / 2 + 0.02) * math.cos(a),
                        fy + (FAN_R / 2 + 0.02) * math.sin(a),
                        FAN_Z + 0.02),
                       rot=(0.35, 0, a), m=m['dark']))
    moving.append(Spin(fan, pivot=(fx, fy, 0), axis='Z', degrees=60))

    # --- fume offtake, north east, down to the output port ---------------
    # Out of the roof, up, east along X, north along Y and down to the
    # stub: straight runs with a ball at every bend, no square elbows.
    ox, oy = VX + 0.88, VY + 0.62
    top = 1.98
    px, py = 1.96, 1.0
    R = 0.13
    add(cyl_at(ox, oy, (ROOF_BASE + 0.10 + top) / 2, R,
               top - ROOF_BASE - 0.10, m['shell'], verts=20))
    add(cyl_at((ox + px) / 2, oy, top, R, px - ox, m['shell'], verts=20,
               rot=(0, math.pi / 2, 0)))
    add(cyl_at(px, (oy + py) / 2, top, R, py - oy, m['shell'], verts=20,
               rot=(math.pi / 2, 0, 0)))
    add(cyl_at(px, py, (0.37 + top) / 2, R, top - 0.37, m['shell'],
               verts=20))
    for x, y, z in ((ox, oy, top), (px, oy, top), (px, py, top),
                    (px, py, 0.37)):
        bpy.ops.mesh.primitive_uv_sphere_add(radius=R + 0.012,
                                             location=(x, y, z),
                                             segments=20, ring_count=10)
        o = bpy.context.object
        o.data.materials.append(m['shell'])
        add(o)
    add(cyl_at((px + 2.40) / 2, py, 0.37, 0.14, 2.40 - px, m['steel'],
               verts=24, rot=(0, math.pi / 2, 0)))
    add(cyl_at(2.46, py, 0.37, 0.19, 0.10, m['dark'], verts=24,
               rot=(0, math.pi / 2, 0)))

    # --- the two inlets, front of each flank -----------------------------
    # Model -X is west and +X east; the X sign does not flip between the
    # model and the prototype. Into the hearth, low down.
    def inlet(sx):
        y = -1.0
        inner = VX + sx * math.sqrt(SHELL_R ** 2 - (y - VY) ** 2) * 0.96
        length = abs(sx * 2.40 - inner)
        add(cyl_at((sx * 2.40 + inner) / 2, y, 0.37, 0.15, length,
                   m['steel'], verts=24, rot=(0, math.pi / 2, 0)))
        add(cyl_at(sx * 2.46, y, 0.37, 0.20, 0.10, m['dark'], verts=24,
                   rot=(0, math.pi / 2, 0)))
        # A valve block on the run, so it reads as a feed and not a strut.
        add(box(0.22, 0.30, 0.30, (sx * 1.92, y, 0.40), m=m['dark']))
        add(cyl_at(sx * 1.92, y, 0.62, 0.11, 0.03, m['yellow'], verts=16))

    inlet(-1)                    # west {-2, 1}
    inlet(1)                     # east { 2, 1}

    # --- slag door, south west ------------------------------------------
    # Off to one side of the front, so the tap spout can have the other.
    a = math.radians(-120)
    c, sn = math.cos(a), math.sin(a)
    face = a + math.pi / 2
    def on_shell(r, z):
        return (VX + r * c, VY + r * sn, z)
    add(box(0.70, 0.14, 0.50, on_shell(SHELL_R + 0.03, 0.95),
            rot=(0, 0, face), m=m['shell']))
    add(box(0.46, 0.06, 0.30, on_shell(SHELL_R + 0.10, 0.92),
            rot=(0, 0, face), m=m['port']))
    glow(box(0.44, 0.03, 0.28, on_shell(SHELL_R + 0.132, 0.92),
             rot=(0, 0, face), m=m['slag']))
    # The lip the slag runs off.
    add(box(0.32, 0.26, 0.05, on_shell(SHELL_R + 0.22, 0.76),
            rot=(0.45, 0, face), m=m['dark']))

    # --- tap spout, south east, down to the molten-metal port ----------
    # The melt leaves through a refractory launder into a tundish on the
    # deck, and from the tundish into the port at {1, 2}. Real furnaces tap
    # into a ladle; a pipe is what Factorio has instead.
    a = math.radians(-60)
    top = (VX + (SHELL_R - 0.05) * math.cos(a),
           VY + (SHELL_R - 0.05) * math.sin(a), 0.86)
    TUN_X, TUN_Y = 1.0, -2.0
    low = (TUN_X, TUN_Y + 0.12, 0.60)
    add(bar(top, low, 0.20, m['brick']))
    # The stream in the launder: lit, and just proud of it.
    glow(bar((top[0], top[1], top[2] + 0.105), (low[0], low[1],
                                                   low[2] + 0.105),
             0.10, m['slag']))
    add(box(0.46, 0.40, 0.34, (TUN_X, TUN_Y, DECK_TOP + 0.17),
            m=m['shell']))
    add(box(0.36, 0.30, 0.02, (TUN_X, TUN_Y, DECK_TOP + 0.345),
            m=m['port']))
    glow(box(0.34, 0.28, 0.02, (TUN_X, TUN_Y, DECK_TOP + 0.355),
             m=m['slag']))
    # The stub: heavier than the feeds, since metal is what runs in it.
    add(cyl_at(TUN_X, (TUN_Y - 0.20 - 2.40) / 2, 0.37, 0.16,
               2.40 - 0.20 + TUN_Y, m['steel'], verts=24,
               rot=(math.pi / 2, 0, 0)))
    add(cyl_at(TUN_X, -2.46, 0.37, 0.21, 0.10, m['dark'], verts=24,
               rot=(math.pi / 2, 0, 0)))

    return static, moving


fr.run(build, frame_tiles=10)
