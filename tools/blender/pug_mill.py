"""Pug Mill - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python pug_mill.py -- \
          --pass entity|shadow --direction north --frames 32 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

The oldest brickworks there is: a round tub of crushed rock and water with
a paddle turning through it, and a bench beside it where the mud is pressed
into moulds. Everything after that is the sun's job, which in this mod is
the item's own drying timer.

It is deliberately the least mechanical-looking building in the mod. Every
other machine here is plate and pipe; this one is a crock, a timber bench
and one iron paddle, because its whole argument is that it needs no furnace
and hardly any power. Warm brown against the Quench Pit's black, the
condenser's steel and teal, the compressor's blue-grey.

Unlike the Quench Pit, an arm over the tub is right here. That rule is not
"never cross the middle" - it is "do not cover the thing the sprite is
about", and there the middle was a glowing shaft. Here the middle is wet
grit, the arm turning through it is the only reason to look, and a tub with
nothing moving in it would be a barrel.

Four facings, because the water inlet and the bench are on named sides and
both have to turn with the entity.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, cone_at,  # noqa: E402
                             torus_at, box, MATS, mat, Spin, Slide)

# --- plan ------------------------------------------------------------------
BASE = 2.78                   # the pad, just inside the 3x3 footprint
BASE_H = 0.16

# The tub is pushed north so the bench has its own ground. In the first cut
# both sat on the centre line and the bench's back edge was inside the tub's
# radius, so the two read as one lump with a rake stuck in it.
TUB_R = 0.98                  # outer radius of the crock
TUB_Y = 0.26
TUB_WALL = 0.16
TUB_Z = BASE_H
TUB_H = 0.68
# Depth from rim to mix wants to be a real fraction of the tub's radius, the
# same lesson the Quench Pit's shaft taught: at 0.18 below the rim the mix
# was a flat lid with a rake over it, and the tub read as a tray.
MUD_Z = TUB_Z + 0.05
MUD_H = 0.20

SHAFT_R = 0.085
ARMS = 2
ARM_SPIN = 360.0 / ARMS       # two arms: half a turn closes the loop
ARM_Z = TUB_Z + TUB_H + 0.20
ARM_LEN = TUB_R - TUB_WALL - 0.06
PADDLES = 3                   # per arm, at three radii

BENCH_Y = -1.13               # the moulding bench, on the near side
BENCH_W, BENCH_D, BENCH_H = 1.80, 0.62, 0.52
MOULDS = 4
PRESS_Z = BENCH_H + 0.34
PRESS_STROKE = 0.10

INLET_Y = 1.50                # water comes in on the north face
STUB_Z = 0.34
STUB_R = 0.16


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS

    # Fired clay for the tub, timber for the bench. Neither colour appears
    # anywhere else in the mod, which is the point: this machine should not
    # be mistaken for the plate-and-pipe ones at a glance.
    # These four were all within a few hundredths of each other in the first
    # cut, and the render came back as one flat brown shape: pad, tub, bench
    # and mix indistinguishable. Warm does not mean uniform. They are spread
    # across the value range now, and the pad is taken out of the brown
    # family entirely so the tub has something to stand on.
    m['crock'] = mat("crock", (0.355, 0.200, 0.120), 0.82, 0.0, wear=0.50)
    m['timber'] = mat("timber", (0.330, 0.220, 0.130), 0.86, 0.0, wear=0.55)
    m['pad'] = mat("pad", (0.088, 0.082, 0.078), 0.90, 0.0, wear=0.55)
    # Wet mix. Very rough - mud takes no specular at all, and the one thing
    # that must not happen is it reading as a fluid. Lighter than seems
    # right in a swatch: it sits at the bottom of a tub, in its own shadow,
    # and at 0.15 it was a black hole with a rake over it.
    m['mud'] = mat("mud", (0.245, 0.158, 0.092), 0.96, 0.0, wear=0.30)
    # A formed brick, before it dries. The same clay brown the item icon is
    # tinted with, so the bench and the inventory agree.
    m['adobe'] = mat("adobe", (0.300, 0.180, 0.105), 0.88, 0.0, wear=0.30)

    static = []
    add = static.append

    # --- pad --------------------------------------------------------------
    add(box(BASE, BASE, BASE_H, (0, 0, BASE_H / 2), m=m['pad']))

    # --- the tub ----------------------------------------------------------
    # Built as a wall ring from two cylinders rather than a solid one, so the
    # camera can see down the inside face; a solid tub with a dark disc on
    # top is a barrel, not a vessel. The floor is a separate disc under the
    # mud, which is never seen but keeps the ring from being a tube in the
    # shadow pass.
    add(cyl_at(0, TUB_Y, TUB_Z, TUB_R, 0.07, m['crock'], verts=44))
    wall = cyl_at(0, TUB_Y, TUB_Z, TUB_R, TUB_H, m['crock'], verts=44)
    bore = cyl_at(0, TUB_Y, TUB_Z - 0.01, TUB_R - TUB_WALL, TUB_H + 0.02,
                  m['crock'], verts=44)
    mod = wall.modifiers.new("bore", 'BOOLEAN')
    mod.operation = 'DIFFERENCE'
    mod.object = bore
    bpy.context.view_layer.objects.active = wall
    bpy.ops.object.modifier_apply(modifier=mod.name)
    mesh = bore.data
    bpy.data.objects.remove(bore, do_unlink=True)
    bpy.data.meshes.remove(mesh)
    add(wall)
    # Iron bands round the crock, the way a wooden or fired tub is hooped.
    for z in (TUB_Z + 0.12, TUB_Z + TUB_H - 0.09):
        add(torus_at((0, TUB_Y, z), TUB_R + 0.005, 0.035, m['iron'],
                     segments=44))

    # --- the mix ----------------------------------------------------------
    # Three discs at three radii rather than one, so the surface is not a
    # flat lid. It never moves: the paddle is what says the mix is being
    # worked, and a heaving surface under a turning arm reads as boiling.
    add(cyl_at(0, TUB_Y, MUD_Z, TUB_R - TUB_WALL - 0.01, MUD_H, m['mud'],
               verts=44))
    add(cyl_at(-0.12, TUB_Y + 0.09, MUD_Z + MUD_H - 0.01, 0.46, 0.035,
               m['mud'], verts=24))
    add(cyl_at(0.24, TUB_Y - 0.18, MUD_Z + MUD_H + 0.01, 0.26, 0.030,
               m['mud'], verts=18))

    # --- paddle gear ------------------------------------------------------
    add(cyl_at(0, TUB_Y, ARM_Z + 0.10, 0.17, 0.16, m['iron'], verts=16))
    add(cyl_at(0, TUB_Y, ARM_Z + 0.26, 0.10, 0.09, m['steel'], verts=12))

    turning = [cyl_at(0, TUB_Y, MUD_Z, SHAFT_R, ARM_Z - MUD_Z + 0.12,
                      m['steel'], verts=14)]
    for i in range(ARMS):
        a = 2 * math.pi * i / ARMS
        cx, cy = math.cos(a), math.sin(a)
        turning.append(box(ARM_LEN, 0.10, 0.09,
                           (cx * ARM_LEN / 2, TUB_Y + cy * ARM_LEN / 2,
                            ARM_Z), rot=(0, 0, a), m=m['steel']))
        # Paddles hanging off the arm into the mix, each one a little
        # further out and each one raked, so the tub reads as being stirred
        # rather than as having a rake parked in it.
        for k in range(PADDLES):
            r = ARM_LEN * (0.34 + 0.28 * k)
            turning.append(box(0.055, 0.26, 0.40,
                               (cx * r, TUB_Y + cy * r, MUD_Z + 0.10),
                               rot=(0, 0, a + 0.42), m=m['iron']))

    # --- moulding bench ---------------------------------------------------
    add(box(BENCH_W, BENCH_D, BENCH_H, (0, BENCH_Y, BENCH_H / 2),
            m=m['timber']))
    add(box(BENCH_W + 0.06, BENCH_D + 0.06, 0.05,
            (0, BENCH_Y, BENCH_H + 0.01), m=m['timber']))
    # The moulds, and a formed brick sitting in each. They are what tells
    # the player what comes out of this building.
    # The moulds sit forward of centre, where the press head does not reach
    # over them, and the brick stands proud of its frame rather than level
    # with it - a brick flush in a dark iron mould is a hole.
    for i in range(MOULDS):
        x = -BENCH_W / 2 + BENCH_W * (i + 0.5) / MOULDS
        add(box(0.30, 0.30, 0.06, (x, BENCH_Y - 0.09, BENCH_H + 0.05),
                m=m['iron']))
        add(box(0.25, 0.25, 0.13, (x, BENCH_Y - 0.09, BENCH_H + 0.11),
                m=m['adobe']))

    # Press head over the moulds, on two guide posts at the ENDS of the
    # bench and with no beam across the top. The first cut had one, and a
    # beam spanning the moulds is exactly the gantry-over-the-working-parts
    # that gets deleted from every machine in this mod - the moulds are the
    # half of this building that says "bricks".
    #
    # The head is also shallower than the bench, so the moulds show in front
    # of it rather than only under it.
    for sx in (-1, 1):
        add(box(0.12, 0.12, PRESS_Z - 0.06,
                (sx * (BENCH_W / 2 + 0.03), BENCH_Y, (PRESS_Z - 0.06) / 2),
                m=m['iron']))
    press = [box(BENCH_W * 0.84, 0.22, 0.11,
                 (0, BENCH_Y + 0.09, PRESS_Z - 0.14), m=m['steel'])]
    for i in range(MOULDS):
        x = -BENCH_W / 2 + BENCH_W * (i + 0.5) / MOULDS
        press.append(box(0.20, 0.18, 0.10, (x, BENCH_Y + 0.09,
                                            PRESS_Z - 0.25), m=m['steel']))

    # --- water inlet ------------------------------------------------------
    add(cyl_at(0, INLET_Y - 0.20, STUB_Z, STUB_R, 0.46, m['iron'], verts=20,
               rot=(math.pi / 2, 0, 0)))
    add(torus_at((0, INLET_Y - 0.02, STUB_Z), STUB_R + 0.035, 0.035,
                 m['steel'], rot=(math.pi / 2, 0, 0)))
    # Riser and a spout over the tub rim, so the water plainly goes in.
    add(cyl_at(0, TUB_Y + TUB_R + 0.16, STUB_Z, 0.075,
               TUB_Z + TUB_H + 0.22 - STUB_Z, m['iron'], verts=12))
    add(cyl_at(0, TUB_Y + TUB_R - 0.02, TUB_Z + TUB_H + 0.18, 0.065, 0.42,
               m['iron'], verts=12, rot=(math.pi / 2, 0, 0)))
    add(cone_at(0, TUB_Y + TUB_R - 0.20, TUB_Z + TUB_H + 0.06, 0.030, 0.075,
                0.13, m['steel'], verts=12))

    moving = [
        Spin(turning, pivot=(0, TUB_Y, 0), axis='Z', degrees=ARM_SPIN),
        Slide(press, axis='Z', amplitude=PRESS_STROKE),
    ]
    return static, moving


fr.run(build)
