"""Laser cutter - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python laser_cutter.py -- \
          --pass entity|shadow|tint|icon|tech --direction north --frames 32 \
          --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A cutting bed at the front and a ruby laser at the back. The laser rod lies
along the rear edge in its housing, and a yellow boom swings out from a
column behind the bed and sweeps the cutting head back and forth across the
workpiece, beam down.

Nothing stands over the bed but the boom, and the boom is the moving part:
there is no gantry, no hood and no bridge. A gantry is how a real flatbed
cutter is built, and at this camera it would be a bar laid across the one
thing the sprite is for.

One sheet, not four. The cutter has no fluid connections, so a rotated one
would show exactly the same picture - see the quench pit, which is built
the same way for the same reason.

The workpiece is the recipe-tinted layer: grey in its own sheet, coloured by
the recipe in game, so the same bed carries a sapphire blank or a silicon
one depending on what is being cut.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             Swing, MATS, mat)

SWING_DEG = 28              # each way from the centre line
PIVOT = (0.0, 0.95, 1.45)   # the column top the boom turns on
BOOM_REACH = 1.37           # pivot to cutting head, in plan
BED_TOP = 0.46


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    # Graphite, not steel. Every other machine on the island is steel,
    # teal, blue-grey, orange or black; a laser is a clean-room machine and
    # this is the one dark, cool, painted casing among them.
    m['case'] = mat("case", (0.080, 0.086, 0.098), 0.48, 0.55, wear=0.55)
    m['deck'] = mat("deck", (0.048, 0.048, 0.045), 0.80, 0.20, wear=0.55)
    m['slat'] = mat("slat", (0.330, 0.320, 0.300), 0.40, 1.0, wear=0.60)
    m['pit'] = mat("pit", (0.012, 0.012, 0.012), 0.90, 0.0)
    # The rod glows red through its window and stays red: a warm emission
    # clips towards yellow once its red channel saturates, so the green and
    # blue here are kept at next to nothing.
    m['rod'] = mat("rod", (0.200, 0.004, 0.010), 0.30, 0.0,
                   emit=(1.00, 0.030, 0.050), emit_str=0.55)
    m['beam'] = mat("beam", (0.300, 0.010, 0.010), 0.20, 0.0,
                    emit=(1.00, 0.060, 0.050), emit_str=1.10)
    m['spot'] = mat("spot", (0.400, 0.200, 0.050), 0.30, 0.0,
                    emit=(1.00, 0.480, 0.140), emit_str=0.90)
    m['screen'] = mat("screen", (0.020, 0.080, 0.060), 0.30, 0.2,
                      emit=(0.30, 1.00, 0.60), emit_str=1.2)
    # The blank on the bed. Neutral grey in its own sheet so the recipe tint
    # can colour it; the icon is not tinted, so there it is a sapphire blank.
    m['blank'] = mat("blank",
                     (0.720, 0.720, 0.705) if fr.PASS == 'tint'
                     else (0.030, 0.070, 0.300),
                     0.25, 0.0)

    static, spin = [], []
    add = static.append

    # --- skid base --------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.08, (0, 0, 0.16), m=m['deck']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(cyl_at(sx * 1.26, sy * 1.26, 0.23, 0.075, 0.08, m['steel'],
                       verts=6))

    # --- the cutting bed, front and centre -------------------------------
    # A frame with a black pit in it and slats across the pit. The slats run
    # north-south so they stand side by side across the sprite: set apart in
    # X they stay separate lines at 64 px, where a row set apart in depth
    # would fuse into one grey slab.
    BY, BW, BD = -0.38, 2.30, 1.50
    add(box(BW, BD, BED_TOP - 0.20, (0, BY, (BED_TOP + 0.20) / 2),
            m=m['case']))
    add(box(BW - 0.16, BD - 0.16, 0.02, (0, BY, BED_TOP + 0.005),
            m=m['pit']))
    slats = 15
    for i in range(slats):
        x = -(BW - 0.30) / 2 + (BW - 0.30) * i / (slats - 1)
        add(box(0.035, BD - 0.22, 0.07, (x, BY, BED_TOP + 0.04),
                m=m['slat']))
    # The blank being cut, lying on the slats.
    blank = box(1.40, 0.78, 0.03, (0, BY - 0.02, BED_TOP + 0.09),
                m=m['blank'])
    add(blank)
    fr.TINT.append(blank)

    # --- the laser, along the back edge ----------------------------------
    # Low and behind the column, so the boom passes over it and nothing
    # passes over the bed. The rod shows through a slot in the housing's
    # front face: a ruby laser is a red crystal rod lit from the side, and
    # the red is what says so.
    lie = (0, math.pi / 2, 0)
    add(cyl_at(0, 1.20, 0.52, 0.19, 2.40, m['case'], verts=24, rot=lie))
    add(box(1.90, 0.10, 0.12, (0, 1.03, 0.52), m=m['pit']))
    add(cyl_at(0, 1.00, 0.52, 0.045, 1.84, m['rod'], verts=12, rot=lie))
    for sx in (-1, 1):
        add(cyl_at(sx * 1.22, 1.20, 0.52, 0.22, 0.10, m['steel'], verts=24,
                   rot=lie))

    # --- column the boom turns on ----------------------------------------
    add(box(0.46, 0.46, PIVOT[2] - 0.20, (0, PIVOT[1], (PIVOT[2] + 0.20) / 2),
            m=m['case']))
    add(box(0.52, 0.52, 0.08, (0, PIVOT[1], PIVOT[2] - 0.04), m=m['steel']))

    # --- to the sides, and lower than the boom ---------------------------
    # Control cabinet east, fume extractor west. Both stand at the rear
    # corners and stop well under the boom, so its sweep is clear of them
    # and neither is drawn over the bed.
    add(box(0.56, 0.70, 0.86, (1.04, 0.86, 0.63), m=m['case']))
    add(box(0.36, 0.03, 0.22, (1.04, 0.50, 0.80), m=m['screen']))
    add(cyl_at(-1.06, 0.90, 0.56, 0.20, 0.72, m['steel'], verts=20))
    add(cyl_at(-1.06, 0.90, 0.96, 0.24, 0.08, m['dark'], verts=20))
    add(box(0.50, 0.18, 0.14, (-0.78, 0.90, 0.46), m=m['steel']))

    # --- the boom, head and beam (animated) ------------------------------
    px, py, pz = PIVOT
    tip = py - BOOM_REACH
    arm = [cyl_at(px, py, pz + 0.07, 0.20, 0.14, m['yellow'], verts=24),
           box(0.18, BOOM_REACH + 0.10, 0.15,
               (px, (py + tip) / 2, pz + 0.07), m=m['yellow']),
           # The cutting head hangs off the end of the boom.
           box(0.32, 0.32, 0.40, (px, tip, pz - 0.14), m=m['case']),
           box(0.33, 0.04, 0.06, (px, tip - 0.16, pz - 0.02), m=m['rod']),
           fr.cone_at(px, tip, pz - 0.49, 0.040, 0.100, 0.15, m['steel'],
                      verts=16)]
    beam_top, beam_low = pz - 0.49, BED_TOP + 0.105
    arm.append(cyl_at(px, tip, (beam_top + beam_low) / 2, 0.025,
                      beam_top - beam_low, m['beam'], verts=10))
    arm.append(cyl_at(px, tip, beam_low + 0.004, 0.07, 0.008, m['spot'],
                      verts=16))
    spin.append(Swing(arm, pivot=PIVOT, axis_vec=(0.0, 0.0, 1.0),
                      degrees=SWING_DEG))
    return static, spin


fr.run(build)
