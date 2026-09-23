"""Geothermal turbine - Factorio 3x5 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python geo_thermal_turbine.py -- \
          --pass entity|shadow --direction north --frames 32 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A generator, not a crafting machine, so it wants two sheets rather than four:
Factorio asks a generator for `vertical_animation` and `horizontal_animation`
only. Render --direction north for the vertical one and east for the
horizontal one and leave south and west alone; they are the same machine seen
from the other end and no generator in the game uses them.

This one burns lava straight off the island at over a thousand degrees, which
is the whole conceit: there is no boiler and no steam anywhere in it. So the
machine is built as a hot half and a cold half split across its length, and
the two are deliberately different colours - ochre-scorched iron at the lava
end to the north, clean steel and copper at the generator end to the south.
That is also the one thing that tells it apart from the vanilla steam turbine
it used to borrow its picture from, which is grey end to end.

Three rams stand up the east flank behind the flywheel, a third of a turn
apart so they work in sequence rather than pumping as one block. They are
what makes this read as an engine rather than a tank with a wheel on it,
and a vertical stroke is the only motion a generator can rely on: it
projects to screen-vertical in both of its facings and can never be
turned edge-on.

The flywheel stands up on the east flank facing the camera rather than
lying inside the casing. A wheel whose axis runs across the screen is seen edge-on
and never reads as turning, which crusher.py found out the expensive way; and
standing it clear of the casing rather than in it keeps the one moving part
of the machine from being drawn over by the still parts of it.

Axis convention, because it has cost this repo two bugs already: modelled +Y
renders at the TOP of the sprite, which is north, and Factorio counts Y
southwards - so a stub modelled at y = +2.2 is prototype position {0,-2}.
Y flips sign between model and prototype; X does not. Both ends of this
machine carry a port, so the two happen to be mirror images, but the next
model will not be so forgiving.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at,         # noqa: E402
                             box, bar, torus_at, MATS, mat, Spin,
                             Slide)

# 3x5 footprint. The collision box is 2.5 x 4.7, so the shell stays just
# inside these and the ports reach out to the connection tiles.
HALF_X, HALF_Y = 1.5, 2.5

# The casing runs up the west side and the flywheel stands on the east, so
# neither is ever in front of the other from a camera that looks from the
# south. Three tiles is not wide enough to put them side by side with room to
# spare, so these two numbers are the whole layout.
CASE_X = -0.46
CASE_R = 0.60
CASE_S, CASE_N = -1.45, 1.95     # south (cold) end .. north (hot) end
CASE_MID = 0.10                  # where scorched iron gives way to steel
CASE_Z = 0.86

# The wheel sits HIGH on purpose. At casing height it was hidden behind
# the barrel in the horizontal facing - one model serves both sheets
# here, and a part that only clears the machine in one of them costs
# half the animation. Its top has to stand above the barrel's top.
WHEEL_X, WHEEL_Y, WHEEL_Z = 0.92, 0.22, 1.40
WHEEL_R = 0.66
SPOKES = 6
WHEEL_SPIN = 360 / SPOKES        # a turn the spokes are symmetric under

FAN_N = 8
# Flat on top of the generator can, axis Z. A camera looking down at 45
# degrees sees the top of a machine whichever way it is turned, so a
# lying fan is the one moving part that cannot be rotated out of view.
FAN_X, FAN_Y, FAN_Z = -0.46, -1.86, 1.40
FAN_R = 0.32
FAN_SPIN = 360 / FAN_N

# Three rams up the east flank, driving the wheel. A vertical slide is the
# one motion that survives both facings of a generator without any thought:
# it projects to screen-vertical whichever way the machine is turned, so
# unlike a standing wheel it can never go edge-on. And at x = +0.96 they sit
# on the camera side in the horizontal sheet as well, because a -90 degree
# turn sends (x, y) to (y, -x) and a positive x becomes a southern y.
RAM_N = 3
RAM_X = 0.96
# North of the flywheel, not level with it. The wheel sits at y = 0.22
# and is the nearer object to a camera looking from the south, so it
# stays in front of the rams instead of the two fighting for the same
# patch of sprite.
RAM_Y = (0.98, 1.46, 1.94)
RAM_BASE = 0.26                  # deck top; the cylinders stand on it
RAM_CYL_H = 0.64
RAM_THROW = 0.13

PORT_Y = 2.18                    # +Y is north; the mirror port is at -PORT_Y


def disc(x, y, z, r, thick, m, verts=32):
    """A wheel, a flange or a band: a cylinder whose axis runs north-south,
    so it stands up in the sprite and faces the camera."""
    return cyl_at(x, y, z, r, thick, m, verts=verts, rot=(math.pi / 2, 0, 0))


def barrel(x, y0, y1, r, m, verts=28):
    """A length of casing between two points on the north-south axis."""
    return cyl_at(x, (y0 + y1) / 2, CASE_Z, r, y1 - y0, m, verts=verts,
                  rot=(math.pi / 2, 0, 0))


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    # Three colours the base palette does not carry: the scorched ochre of
    # iron that has had lava inside it for a long time, and the brass and
    # copper that say "this end is electrical" at 64 px without a label.
    m['scorch'] = mat("scorch", (0.235, 0.150, 0.085), 0.60, 1.0, wear=0.90)
    m['brass'] = mat("brass", (0.520, 0.380, 0.115), 0.34, 1.0, wear=0.55)
    m['copper'] = mat("copper", (0.620, 0.300, 0.110), 0.30, 1.0, wear=0.45)
    # The feed pipe's own glow. The shared `lava` material is tuned for an
    # open pool and at 1.9 it clips to a flat neon orange on a thin pipe,
    # which reads as a strip light painted on the casing rather than as
    # something hot inside a pipe. Lower emission keeps the shading.
    m['feed'] = mat("feed", (0.300, 0.105, 0.030), 0.52, 0.30,
                    emit=(1.00, 0.34, 0.05), emit_str=1.10)

    static, spin = [], []
    add = static.append

    # --- plinth ----------------------------------------------------------
    add(box(2.86, 4.80, 0.16, (0, 0, 0.08), m=m['iron']))
    add(box(2.62, 4.56, 0.10, (0, 0, 0.21), m=m['steel']))
    for sx in (-1, 1):
        for sy in (-1.72, 0, 1.72):
            add(box(0.30, 0.30, 0.12, (sx * 1.18, sy, 0.28), m=m['steel']))

    # --- the casing: hot half north, cold half south ---------------------
    # One barrel in two materials rather than two barrels. The lagging runs
    # continuously down the machine and only its colour changes, which says
    # "this end is the hot one" without inventing a seam that is not there.
    add(barrel(CASE_X, CASE_MID, CASE_N, CASE_R, m['scorch']))
    add(barrel(CASE_X, CASE_S, CASE_MID, CASE_R * 0.96, m['steel']))
    # Banding rings, spaced unevenly so the barrel does not read as a ruler.
    for y in (-1.20, -0.62, 0.02, 0.48, 1.05, 1.62):
        add(disc(CASE_X, y, CASE_Z, CASE_R + 0.05, 0.07, m['iron'], verts=28))

    # Inspection door and gauges, on the cold half where a fitter could
    # actually stand.
    add(box(0.44, 0.34, 0.38, (CASE_X + 0.50, -0.78, CASE_Z + 0.06),
            rot=(0, 0.20, 0), m=m['steel']))
    for dy in (-0.10, 0.12):
        add(disc(CASE_X + 0.70, -0.78 + dy, CASE_Z + 0.20, 0.075, 0.05,
                 m['brass'], verts=16))

    # --- the hot end: lava manifold --------------------------------------
    # The glow lives in the pipework and the throat, never in the casing
    # itself. A barrel glowing along its whole length looks like it is about
    # to fail; a barrel with hot pipes going into it looks like it is working.
    # The feed runs along the WEST FLANK, not along the top and not butting
    # into the end. Bolted to the end it was swallowed whole by the casing;
    # laid along the top it sat directly over the barrel's own axis, and a
    # 45-degree camera projects that straight onto the barrel, so it came
    # out as a glowing stripe painted down the lagging. Beside the barrel it
    # is separated from it in screen space and reads as what it is.
    HDR_X = CASE_X - 0.76
    HDR_Z = 0.74
    add(cyl_at(HDR_X, (0.22 + CASE_N + 0.18) / 2, HDR_Z, 0.145,
               CASE_N - 0.04, m['feed'], verts=20, rot=(math.pi / 2, 0, 0)))
    add(disc(HDR_X, CASE_N + 0.18, HDR_Z, 0.175, 0.09, m['dark'], verts=20))
    add(disc(HDR_X, 0.22, HDR_Z, 0.175, 0.09, m['iron'], verts=20))
    # Spurs into the side of the casing, glowing where they enter it.
    for y in (0.52, 1.12, 1.68):
        add(bar((HDR_X + 0.02, y, HDR_Z), (CASE_X - 0.18, y, CASE_Z - 0.08),
                0.085, m['hot']))
        add(disc(CASE_X - 0.16, y, CASE_Z - 0.07, 0.105, 0.07, m['iron'],
                 verts=16))
    # Legs down to the plinth, so the run is carried rather than floating.
    for y in (0.40, 1.40):
        add(bar((HDR_X, y, HDR_Z - 0.10), (HDR_X, y, 0.26), 0.06,
                m['steel']))
    # The throat: where the feed turns into the hot end of the barrel. The
    # one place an open glow belongs, and the brightest thing on the machine.
    add(bar((HDR_X, CASE_N + 0.10, HDR_Z),
            (CASE_X, CASE_N + 0.10, CASE_Z - 0.02), 0.13, m['lava']))
    add(disc(CASE_X, CASE_N - 0.02, CASE_Z - 0.02, 0.19, 0.10, m['lava'],
             verts=20))

    # --- the cold end: generator can, terminals, exhaust -----------------
    add(barrel(CASE_X, -2.30, -1.42, 0.50, m['steel'], verts=24))
    add(disc(CASE_X, -2.34, CASE_Z, 0.52, 0.08, m['dark'], verts=24))
    add(box(0.56, 0.44, 0.50, (CASE_X + 0.68, -2.00, 0.47), m=m['dark']))
    # Bus bars off the terminal box - the only copper on the machine, and the
    # clearest single cue that this end makes electricity.
    for dz in (0.0, 0.11):
        add(bar((CASE_X + 0.44, -2.00, 0.60 + dz),
                (CASE_X + 0.96, -2.00, 0.60 + dz), 0.05, m['copper']))
    # Exhaust stack, on the cold half and well clear of the flywheel.
    add(cyl_at(CASE_X - 0.64, -1.05, 0.30, 0.16, 1.24, m['iron'], verts=16))
    add(cyl_at(CASE_X - 0.64, -1.05, 1.56, 0.20, 0.10, m['dark'], verts=16))

    # --- flywheel, standing up on the east flank -------------------------
    # Pedestal and bearing caps are static; only the wheel itself turns.
    add(box(0.46, 0.66, WHEEL_Z - 0.16, (WHEEL_X, WHEEL_Y,
                                         (WHEEL_Z - 0.16) / 2 + 0.16),
            m=m['iron']))
    add(box(0.66, 0.86, 0.16, (WHEEL_X, WHEEL_Y, 0.30), m=m['steel']))
    for sy in (-1, 1):
        add(disc(WHEEL_X, WHEEL_Y + sy * 0.28, WHEEL_Z, 0.17, 0.12,
                 m['steel'], verts=16))
    # Drive shaft up to the raised bearing, so the wheel is connected to
    # something rather than standing next to it.
    add(bar((CASE_X + 0.30, WHEEL_Y, CASE_Z + 0.30),
            (WHEEL_X - 0.24, WHEEL_Y, WHEEL_Z), 0.085, m['steel']))

    # A rim and spokes, never a solid disc. The first cut of this wheel had
    # a filled centre plate as thick as the spokes, so the spokes were
    # invisible behind it and the whole flywheel turned into a dark coin
    # that did not read as turning at all - which is the exact failure the
    # camera-facing axis was chosen to avoid.
    wheel = []
    wheel.append(torus_at((WHEEL_X, WHEEL_Y, WHEEL_Z), WHEEL_R, 0.085,
                          m['iron'], rot=(math.pi / 2, 0, 0), segments=36))
    wheel.append(disc(WHEEL_X, WHEEL_Y, WHEEL_Z, 0.20, 0.26, m['steel'],
                      verts=20))
    for i in range(SPOKES):
        a = 2 * math.pi * i / SPOKES
        wheel.append(box(0.085, 0.10, WHEEL_R * 1.9,
                         (WHEEL_X, WHEEL_Y, WHEEL_Z), rot=(0, a, 0),
                         m=m['steel']))
    spin.append(Spin(wheel, pivot=(WHEEL_X, WHEEL_Y, WHEEL_Z), axis='Y',
                     degrees=WHEEL_SPIN))

    # --- the rams --------------------------------------------------------
    # Each one gets its own Slide and its own phase, a third of a turn
    # apart, so they work in sequence instead of pumping as one block. A
    # Slide closes its own loop - amplitude*sin(2*pi*f/frames) is back where
    # it started on the last frame - so the phases cost nothing in frames.
    for i, ry in enumerate(RAM_Y):
        # Cylinder, standing on the deck. Static: only the rod moves.
        add(cyl_at(RAM_X, ry, RAM_BASE + RAM_CYL_H / 2, 0.215, RAM_CYL_H,
                   m['steel'], verts=18))
        add(disc(RAM_X, ry, RAM_BASE + RAM_CYL_H, 0.245, 0.07, m['iron'],
                 verts=18))
        add(disc(RAM_X, ry, RAM_BASE + 0.04, 0.255, 0.08, m['iron'],
                 verts=18))
        # A short feed off the hot half into each cylinder, so the rams are
        # driven by the machine rather than standing beside it. Steel, with
        # only a collar glowing where it leaves the casing: in `hot` along
        # its whole length each feed came out as a bright orange bar laid
        # straight across the barrel, three of which read as scaffolding
        # painted on the machine rather than as pipework going into it.
        add(bar((CASE_X + CASE_R - 0.06, ry, RAM_BASE + 0.34),
                (RAM_X - 0.16, ry, RAM_BASE + 0.34), 0.065, m['steel']))
        add(cyl_at(CASE_X + CASE_R - 0.02, ry, RAM_BASE + 0.34, 0.085, 0.10,
                   m['hot'], verts=12, rot=(0, math.pi / 2, 0)))
        rod = [cyl_at(RAM_X, ry, RAM_BASE + RAM_CYL_H + 0.26, 0.085, 0.50,
                      m['steel'], verts=12),
               box(0.30, 0.24, 0.11, (RAM_X, ry, RAM_BASE + RAM_CYL_H + 0.54),
                   m=m['iron'])]
        spin.append(Slide(rod, axis='Z', amplitude=RAM_THROW,
                          phase=i / RAM_N))

    # --- cooling fan on the generator, also camera-facing -----------------
    # A second turning part at a different rate. One moving thing on a
    # machine this size reads as a still picture with a detail stuck to it.
    # A guard ring, not a backing plate: a disc behind the blades swallows
    # them at 64 px the same way the flywheel's centre plate did.
    add(cyl_at(FAN_X, FAN_Y, FAN_Z - 0.18, FAN_R + 0.10, 0.22, m['dark'],
               verts=24))
    add(torus_at((FAN_X, FAN_Y, FAN_Z + 0.02), FAN_R + 0.08, 0.045,
                 m['dark'], segments=24))
    fan = []
    for i in range(FAN_N):
        a = 2 * math.pi * i / FAN_N
        fan.append(box(FAN_R * 1.8, 0.13, 0.045, (FAN_X, FAN_Y, FAN_Z),
                       rot=(0, 0, a), m=m['steel']))
    fan.append(cyl_at(FAN_X, FAN_Y, FAN_Z, 0.10, 0.16, m['iron'], verts=16))
    spin.append(Spin(fan, pivot=(FAN_X, FAN_Y, FAN_Z), axis='Z',
                     degrees=FAN_SPIN))

    # --- fluid connections, north and south ------------------------------
    # The prototype leaves pipe_picture and pipe_covers off, so the model has
    # to carry the ports itself. Both ends are input-output, the way a steam
    # turbine's are, so a row of these can be plumbed straight through - and
    # the north one is drawn in lava because that is the end it arrives at.
    for sy in (1, -1):
        pipe = m['lava'] if sy > 0 else m['steel']
        add(box(0.60, 0.34, 0.52, (CASE_X, sy * (PORT_Y - 0.36), 0.43),
                m=m['iron']))
        add(cyl_at(CASE_X, sy * PORT_Y, 0.43, 0.185, 0.72, pipe, verts=24,
                   rot=(math.pi / 2, 0, 0)))
        add(disc(CASE_X, sy * (PORT_Y + 0.20), 0.43, 0.235, 0.10, m['dark'],
                 verts=24))

    return static, spin


# Nine tiles of frame: the machine is five tiles on its long axis and the
# sun-side shadow of a barrel this tall runs well past the footprint. The
# same number has to serve both facings, because the frame is square and the
# long axis swaps between them.
fr.run(build, frame_tiles=9)
