"""Air cooler - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python air_cooler.py -- \
          --pass entity|shadow|icon --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A cryogenic chiller: a louvred plant box with two big counter-rotating axial
fans on its roof, a rime-covered expansion drum lying across the front, and a
compressor whose piston works up and down beside it.

Frost is the whole identity. Every other cold machine in the mod is grey or
teal; this one is the only one with white rime on it, which is what tells you
at a glance that the liquid nitrogen line starts here. The two fans turn
against each other for the same reason the condenser's do: one fan reads as a
detail stuck to a box, two reading against each other read as a machine.

Ports are where a deepcopied chemical plant leaves them for this entity:
inputs north and west, output south.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             bar, torus_at, cone_at, MATS, mat, Spin, Slide)

BODY_Y = 0.42
BODY_TOP = 0.98

FAN_BLADES = 6
FAN_SPIN = 360 / FAN_BLADES
FAN_X = 0.58                    # a pair, mirrored about the centre line
FAN_Z = BODY_TOP + 0.20
SHROUD_R = 0.50
BLADE_LEN, BLADE_CHORD, BLADE_THK = 0.40, 0.17, 0.024
BLADE_HUB = 0.12
assert BLADE_HUB + BLADE_LEN / 2 + 0.02 < SHROUD_R, "fan blades foul the shroud"
assert 2 * FAN_X > 2 * SHROUD_R + 0.08, "the two fan shrouds overlap"

DRUM_Y, DRUM_R, DRUM_HALF = -0.74, 0.30, 0.74
DRUM_Z = 0.56

COMP_X, COMP_Y = 1.08, -0.36
COMP_STROKE = 0.10
COMP_BODY_TOP = 0.86
ROD_Z, ROD_LEN = 0.88, 0.36
assert ROD_Z - ROD_LEN / 2 + COMP_STROKE < COMP_BODY_TOP, "piston lifts out"

# Inputs north and west, output south.
PORTS = [(0, -1), (-1, 0), (0, 1)]


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.048, 0.048, 0.045), 0.80, 0.20, wear=0.55)
    m['case'] = mat("case", (0.145, 0.170, 0.190), 0.48, 1.0, wear=0.75)
    # Rime. Rough and not at all metallic, which is what separates frost from
    # the polished steel next to it - a pale metal just looks like chrome.
    m['rime'] = mat("rime", (0.740, 0.790, 0.830), 0.88, 0.0, wear=0.30)
    m['cold'] = mat("cold", (0.300, 0.420, 0.480), 0.40, 0.9, wear=0.55)
    m['panel'] = mat("panel", (0.020, 0.060, 0.090), 0.30, 0.2,
                     emit=(0.35, 0.80, 1.00), emit_str=1.6)

    static, spin = [], []
    add = static.append

    # --- skid base --------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(cyl_at(sx * 1.26, sy * 1.26, 0.23, 0.075, 0.08, m['steel'],
                       verts=6))

    # --- plant box --------------------------------------------------------
    add(box(2.44, 1.26, BODY_TOP - 0.18, (0, BODY_Y, (0.18 + BODY_TOP) / 2),
            m=m['case']))
    add(box(2.52, 1.34, 0.07, (0, BODY_Y, BODY_TOP + 0.02), m=m['dark']))
    # Louvres down the camera-facing side: a plain box face is the deadest
    # thing a machine can show, and slats catch the light one edge at a time.
    for i in range(9):
        add(box(2.36, 0.05, 0.075,
                (0, BODY_Y - 0.64, 0.30 + i * 0.075), rot=(0.5, 0, 0),
                m=m['cold']))
    for sx in (-1, 1):
        add(box(0.06, 1.26, BODY_TOP - 0.20,
                (sx * 1.21, BODY_Y, (0.18 + BODY_TOP) / 2), m=m['steel']))

    # --- the two fans, turning against each other -------------------------
    for i, sx in enumerate((-1, 1)):
        cx = sx * FAN_X
        add(torus_at((cx, BODY_Y, FAN_Z), SHROUD_R, 0.055, m['steel']))
        add(cyl_at(cx, BODY_Y, FAN_Z - 0.13, SHROUD_R + 0.03, 0.10,
                   m['dark'], verts=28))
        for k in range(4):                          # guard bars over the fan
            a = math.pi * k / 4
            add(bar((cx - SHROUD_R * math.cos(a), BODY_Y - SHROUD_R * math.sin(a),
                     FAN_Z + 0.06),
                    (cx + SHROUD_R * math.cos(a), BODY_Y + SHROUD_R * math.sin(a),
                     FAN_Z + 0.06), 0.022, m['steel']))
        blades = [cyl_at(cx, BODY_Y, FAN_Z, BLADE_HUB, 0.10, m['dark'],
                         verts=14)]
        for k in range(FAN_BLADES):
            a = 2 * math.pi * k / FAN_BLADES
            b = box(BLADE_LEN, BLADE_CHORD, BLADE_THK,
                    (cx + (BLADE_HUB + BLADE_LEN / 2 - 0.04) * math.cos(a),
                     BODY_Y + (BLADE_HUB + BLADE_LEN / 2 - 0.04) * math.sin(a),
                     FAN_Z), rot=(0, 0, a), m=m['steel'])
            b.rotation_euler[1] = math.radians(26)
            blades.append(b)
        spin.append(Spin(blades, pivot=(cx, BODY_Y, 0),
                         degrees=(1 if i == 0 else -1) * FAN_SPIN))

    # --- rimed expansion drum across the front ----------------------------
    along_x = (0, math.pi / 2, 0)
    add(cyl_at(0, DRUM_Y, DRUM_Z, DRUM_R, DRUM_HALF * 2, m['rime'], verts=30,
               rot=along_x))
    for s in (-1, 1):
        cap = cone_at(0, 0, 0, DRUM_R, DRUM_R * 0.5, 0.14, m['rime'])
        cap.rotation_euler = (0, s * math.pi / 2, 0)
        cap.location = (s * (DRUM_HALF + 0.07), DRUM_Y, DRUM_Z)
        add(cap)
        add(box(0.16, 0.28, DRUM_Z - 0.18, (s * 0.50, DRUM_Y,
                (0.18 + DRUM_Z) / 2), m=m['dark']))
        add(torus_at((s * 0.50, DRUM_Y, DRUM_Z), DRUM_R + 0.014, 0.028,
                     m['cold'], rot=along_x))
    # Frost collars where the cold lines leave the drum.
    for s in (-1, 1):
        add(torus_at((s * 0.22, DRUM_Y, DRUM_Z), DRUM_R + 0.020, 0.036,
                     m['rime'], rot=along_x))
    add(cyl_at(0, DRUM_Y, DRUM_Z + DRUM_R + 0.10, 0.06, 0.22, m['cold'],
               verts=10))

    # --- compressor: the one part that goes up and down --------------------
    add(box(0.40, 0.46, COMP_BODY_TOP - 0.18,
            (COMP_X, COMP_Y, (0.18 + COMP_BODY_TOP) / 2), m=m['steel']))
    add(box(0.46, 0.52, 0.07, (COMP_X, COMP_Y, COMP_BODY_TOP + 0.02),
            m=m['dark']))
    add(box(0.20, 0.04, 0.12, (COMP_X, COMP_Y - 0.25, 0.54), m=m['panel']))
    ram = [cyl_at(COMP_X, COMP_Y, ROD_Z, 0.05, ROD_LEN, m['steel'], verts=14)]
    # Rimed, not teal: the head is the highest thing on this corner and a
    # white cap is what makes the stroke readable at sprite size.
    ram.append(cyl_at(COMP_X, COMP_Y, ROD_Z + ROD_LEN / 2 + 0.04, 0.12, 0.09,
                      m['rime'], verts=16))
    spin.append(Slide(ram, axis='Z', amplitude=COMP_STROKE))

    # --- cold pipework -----------------------------------------------------
    add(bar((COMP_X, COMP_Y - 0.20, 0.50), (DRUM_HALF + 0.06, DRUM_Y, 0.56),
            0.075, m['cold']))
    add(bar((0, DRUM_Y + DRUM_R, 0.62), (0, BODY_Y - 0.64, 0.62), 0.075,
            m['cold']))
    for s in (-1, 1):
        add(cyl_at(s * 1.06, DRUM_Y + 0.30, 0.34, 0.05, 0.32, m['rime'],
                   verts=8))

    # --- fluid ports: in north and west, out south -------------------------
    # Modelled stubs, not pipe_covers: a one-tile cover sprite cannot meet a
    # stub that reaches past that tile. See docs/blender-renders.md.
    for dx, dy in PORTS:
        ang = math.atan2(dy, dx)
        axis = (math.pi / 2, 0, ang + math.pi / 2)
        add(box(0.34, 0.44, 0.40, (dx * 1.05, dy * 1.05, 0.36),
                rot=(0, 0, ang), m=m['iron']))
        add(cyl_at(dx * 1.30, dy * 1.30, 0.36, 0.165, 0.70, m['steel'],
                   verts=24, rot=axis))
        add(cyl_at(dx * 1.46, dy * 1.46, 0.36, 0.215, 0.10, m['dark'],
                   verts=24, rot=axis))

    return static, spin


# Each fan turns one blade pitch over the sheet, in opposite directions, and
# the piston closes on its own sine, so every group lands on frame 0 again.
fr.run(build)
