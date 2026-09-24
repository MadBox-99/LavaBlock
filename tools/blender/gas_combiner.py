"""Gas Combiner - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python gas_combiner.py --
          --pass entity|shadow|icon --direction north --frames 32 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A gas blending skid: two upright receivers standing at the back, a mixing
drum lying across the front with a lit sight glass in the middle of it, and
a blower on the end of the drum driving the circulation.

Two receivers, not one. One bottle on a frame is a gas store and says
nothing about what the machine does to what is in it; two of them feeding a
single drum say "these go in and one thing comes out", which is the whole
machine. They are deliberately unequal in height, because two identical
cylinders read as a pair of legs rather than as two supplies.

Tall things at the back, the lit thing at the front. The camera sits on the
model's -Y side, so anything at -Y is nearer and lower in the sprite: put
the receivers there and they stand in front of the drum and hide the only
part worth looking at. The first version did exactly that.

Brass and deep blue. The air compressor next door is cold grey with a big
intake fan, and the two will stand side by side in every gas build on the
island - so this one takes the palette nothing else in the mod uses, and
keeps its blower small and off to one corner rather than large and on top.

The blower's impeller lies flat. On a machine that can be rotated that is
not a style choice: see the note at FAN_N for what a standing wheel does to
the east and west sheets.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             bar, torus_at, MATS, mat, Spin, Slide)

# Which way round the world is under this camera, because getting it wrong
# is how a machine ends up with a pipe connection on the opposite edge from
# its own nozzle:
#
#     model +Y -> top of the sprite    -> north -> position {0, -1}
#     model -Y -> bottom of the sprite -> south -> position {0,  1}
#     model +X -> right                -> east  -> position {1,  0}
#     model -X -> left                 -> west  -> position {-1, 0}
#
# Y flips sign between the model and the prototype and X does not, because
# Factorio counts Y southwards while the render puts +Y at the top.

DECK_TOP = 0.21

# --- the two receivers, at the back --------------------------------------
REC = (  # x, y, radius, height
    (-0.72, 0.78, 0.33, 1.62),
    (0.58, 0.74, 0.27, 1.18),
)

# --- the mixing drum, across the front -----------------------------------
# Shifted left and shortened, to leave the front right corner empty for
# the blower wheel. A drum spanning the full width leaves the wheel with
# nowhere to stand but on top of the drum, where it is half hidden.
DRUM_X = -0.34
DRUM_Y = -0.62
DRUM_Z = 0.60
DRUM_R = 0.42
DRUM_LEN = 1.52

# --- the blower ----------------------------------------------------------
# A centrifugal blower with an UPRIGHT shaft, so the impeller lies flat.
#
# It stood up facing the camera before, on the reasoning that a wheel on the
# end of the drum turns about an axis pointing across the screen and is seen
# edge on. That reasoning was right and it only covered the north facing.
# This machine rotates, and Factorio turns the whole model about Z: a wheel
# whose axis is Y facing north has its axis along X facing east, which is
# exactly the edge-on case it was built to avoid. It vanished completely in
# the east sheet and came back as a single brass line in the west one, which
# left those two facings with no visible motion at all.
#
# Only Z survives all four. A disc lying flat is turned about Z by the
# facing and stays lying flat, so the 45-degree camera sees it as an ellipse
# from every side. Nothing else is safe on a machine that rotates.
FAN_N = 6                       # blades, so the sheet closes on a sixth turn
FAN_SPIN = 360.0 / FAN_N
FAN_X = 0.96
FAN_Y = -0.56
FAN_R = 0.38
VOLUTE_H = 0.40                 # the housing the impeller sits on top of
FAN_Z = DECK_TOP + VOLUTE_H + 0.07


def receiver(x, y, r, h, m):
    """One upright gas receiver: a capped cylinder in two straps."""
    z0 = DECK_TOP
    out = [cyl_at(x, y, z0 + h / 2, r, h, m['brass'], verts=28),
           cyl_at(x, y, z0 + h + 0.02, r * 0.80, 0.07, m['dark'], verts=28),
           cyl_at(x, y, z0 + 0.04, r * 1.06, 0.10, m['dark'], verts=28)]
    for t in (0.34, 0.74):
        out.append(torus_at((x, y, z0 + h * t), r + 0.015, 0.035, m['steel']))
    # The take-off on top, bending down and forward to the drum.
    out.append(cyl_at(x, y, z0 + h + 0.14, 0.07, 0.20, m['brass'], verts=12))
    # Down the back of its own bottle and along the deck, not diagonally
    # across the front of the machine: two pale rods laid over the drum
    # read as scaffolding, and they crossed the one lit part of the model.
    out.append(bar((x, y, z0 + h + 0.22), (x, y - r - 0.12, z0 + h * 0.5),
                   0.055, m['brass']))
    out.append(bar((x, y - r - 0.12, z0 + h * 0.5),
                   (x * 0.55, 0.12, DECK_TOP + 0.14), 0.055, m['brass']))
    return out


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.050, 0.048, 0.046), 0.80, 0.20, wear=0.55)
    m['case'] = mat("case", (0.082, 0.124, 0.232), 0.52, 0.55, wear=0.78)
    m['brass'] = mat("brass", (0.370, 0.256, 0.078), 0.32, 1.0, wear=0.62)
    # The blend behind the sight glass. This is the one lit thing on the
    # machine, and the Standard view transform has no tonemapping, so
    # anything much above 1.5 clips to white and loses its colour.
    m['glow'] = mat("glow", (0.075, 0.150, 0.130), 0.18, 0.0,
                    emit=(0.34, 0.96, 0.78), emit_str=1.15)

    static, spin, slide = [], [], []
    add = static.append

    # --- plinth -----------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))

    # --- receivers --------------------------------------------------------
    for x, y, r, h in REC:
        for o in receiver(x, y, r, h, m):
            add(o)

    # --- mixing drum ------------------------------------------------------
    lie = (0, math.pi / 2, 0)
    add(cyl_at(DRUM_X, DRUM_Y, DRUM_Z, DRUM_R, DRUM_LEN, m['case'], verts=32,
               rot=lie))
    for sx in (-1, 1):
        add(cyl_at(DRUM_X + sx * DRUM_LEN / 2, DRUM_Y, DRUM_Z, DRUM_R + 0.03, 0.09,
                   m['steel'], verts=32, rot=lie))
        add(box(0.22, 0.48, DRUM_Z - DECK_TOP + 0.10,
                (DRUM_X + sx * DRUM_LEN * 0.32, DRUM_Y,
                 (DRUM_Z + DECK_TOP) / 2 - 0.06),
                m=m['case']))

    # --- the sight glass, standing proud of the near face -----------------
    # Proud, not flush. Set into the drum at the radius it reads as nothing:
    # the brass surround ends up in front of the glass and caps the light,
    # which is what the first version did. So the glass sits outside the
    # shell and the surround sits outside the glass again.
    gy = DRUM_Y - DRUM_R
    add(box(0.82, 0.09, 0.40, (DRUM_X, gy - 0.015, DRUM_Z + 0.03),
            m=m['brass']))
    add(box(0.72, 0.09, 0.30, (DRUM_X, gy - 0.055, DRUM_Z + 0.03),
            m=m['glow']))
    for sx in (-1, 1):
        add(box(0.05, 0.10, 0.34, (DRUM_X + sx * 0.26, gy - 0.075, DRUM_Z + 0.03),
                m=m['brass']))

    # --- blower, impeller lying flat --------------------------------------
    # The volute, and a dark face on TOP of it for the blades to turn
    # against. The blades go above that face, never down inside the
    # housing: a body that swallows the one part which had to be seen is
    # the mistake this repo has made more than any other.
    add(cyl_at(FAN_X, FAN_Y, DECK_TOP + VOLUTE_H / 2, FAN_R + 0.06,
               VOLUTE_H, m['case'], verts=24))
    add(cyl_at(FAN_X, FAN_Y, DECK_TOP + VOLUTE_H + 0.015, FAN_R + 0.01,
               0.03, m['dark'], verts=24))
    add(torus_at((FAN_X, FAN_Y, FAN_Z + 0.01), FAN_R + 0.05, 0.035,
                 m['brass']))
    fan = []
    for i in range(FAN_N):
        a = 2 * math.pi * i / FAN_N
        fan.append(box(FAN_R * 1.7, 0.10, 0.045, (FAN_X, FAN_Y, FAN_Z),
                       rot=(0, 0, a), m=m['brass']))
    fan.append(cyl_at(FAN_X, FAN_Y, FAN_Z + 0.03, 0.10, 0.10, m['steel'],
                      verts=14))
    spin.append(Spin(fan, pivot=(FAN_X, FAN_Y, FAN_Z), axis='Z',
                     degrees=FAN_SPIN))
    # The duct back to the drum, leaving the volute's side rather than the
    # old wheel's hub.
    add(bar((FAN_X - FAN_R - 0.02, FAN_Y, DECK_TOP + VOLUTE_H * 0.62),
            (DRUM_X + DRUM_LEN / 2 - 0.06, DRUM_Y, DRUM_Z), 0.07,
            m['steel']))

    # --- the dosing ram, on the deck between drum and receivers -----------
    # A gas is blended by metering it, not by stirring it, so the second
    # moving part meters: a plunger riding up and down in a brass barrel,
    # out in the open where it can be seen.
    RX, RY = -0.20, 0.16
    add(box(0.34, 0.34, 0.30, (RX, RY, DECK_TOP + 0.15), m=m['case']))
    add(cyl_at(RX, RY, DECK_TOP + 0.56, 0.115, 0.52, m['brass'], verts=16))
    ram = [cyl_at(RX, RY, DECK_TOP + 0.70, 0.07, 0.44, m['steel'], verts=12),
           cyl_at(RX, RY, DECK_TOP + 0.94, 0.14, 0.09, m['dark'], verts=12)]
    slide.append(Slide(ram, axis='Z', amplitude=0.10))

    # --- manifold along the deck ------------------------------------------
    add(bar((-1.26, 0.10, 0.32), (1.26, 0.10, 0.32), 0.08, m['brass']))
    for sx in (-1, 1):
        add(cyl_at(sx * 0.62, 0.10, 0.44, 0.05, 0.16, m['brass'], verts=10))
        add(cyl_at(sx * 0.62, 0.10, 0.54, 0.10, 0.04, m['steel'], verts=12))

    # --- ports ------------------------------------------------------------
    # Two gases in on the flanks, the blend out at the back. Front is left
    # clear: it is where the sight glass is, and a stub across it would be
    # a pipe drawn over the one part of the machine worth seeing.
    def port(dx, dy, pipe):
        ax = (0, math.pi / 2, 0) if dx else (math.pi / 2, 0, 0)
        add(box(0.46 if dx else 0.36, 0.36 if dx else 0.46, 0.42,
                (dx * 1.06, dy * 1.06, 0.37), m=m['case']))
        add(cyl_at(dx * 1.30, dy * 1.30, 0.37, 0.155, 0.70, pipe,
                   verts=24, rot=ax))
        add(cyl_at(dx * 1.46, dy * 1.46, 0.37, 0.205, 0.10, m['dark'],
                   verts=24, rot=ax))

    port(-1, 0, m['brass'])          # west,  {-1, 0} - first gas in
    port(1, 0, m['brass'])           # east,  { 1, 0} - second gas in
    port(0, 1, m['steel'])           # north, { 0,-1} - the blend out
    add(bar((-1.06, 0, 0.54), (-0.72, 0.44, DECK_TOP + 0.34), 0.06,
            m['brass']))
    add(bar((1.06, 0, 0.54), (0.58, 0.40, DECK_TOP + 0.30), 0.06, m['brass']))

    return static, spin + slide


fr.run(build)
