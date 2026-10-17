"""Coil Winder - Factorio 3x3 entity, rendered at 64 px/tile.

  render_all.sh coil_winder.py coil-winder <scratch> 32

The camera, materials, primitives and render loop live in factorio_render.

A vertical winding machine, the kind transformer windings are made on: the
coil stands upright on a turntable and turns about a vertical axis, while a
guide carriage rides up and down a column beside it, laying the wire on in
layers. Facing north it reads from the back of the sprite to the front:

  - the drive motor and its gearbox in the back left corner, low;
  - the guide column in the back right corner, with the tension roller on
    top and the carriage riding it. The carriage's arm reaches in to the
    coil and the wire runs from its roller onto the winding;
  - in the middle, the turntable on its drive drum and the coil on it: a
    copper winding on a steel mandrel, pressboard collars top and bottom,
    pressboard spacer strips standing round it, and a clamp spider on top;
  - the payoff spool lying flat in the front right corner, low, its wire
    running back to the column top;
  - the control cabinet in the front left corner.

Vertical and not horizontal for the reason docs/blender-renders.md gives
under "The spin axis": a coil turning about a horizontal axis is seen
end-on in two of the four facings and its animation is gone. Lying flat,
the turntable and the payoff spool turn in every facing. It is also how the
big ones are really built - a horizontal winder is for small bobbins.

Nothing stands over the coil. The column is beside it, the spool and the
cabinet are low and to the side, and the wire to the column top runs east
of the turntable, clear of it in all four facings.

Three moving parts at three rates: the coil and turntable (8 spacer strips,
4 jaws and a 4-armed spider - closes on 90 degrees), the payoff spool
(6 spokes - closes on 60), and the guide carriage riding up and down once
over the sheet.

FOUR facings: the column, spool and cabinet sit on named corners.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, torus_at,  # noqa: E402
                             box, bar, MATS, mat, Spin, Slide)

# --- plan ------------------------------------------------------------------
PAD = 2.80                    # just inside the 3x3 footprint
PAD_H = 0.12

CX, CY = 0.0, 0.05            # turntable and coil axis
DRUM_R, DRUM_H = 0.92, 0.30   # the drive drum the turntable sits on
TT_R, TT_H = 0.86, 0.10       # the turntable
TT_TOP = PAD_H + DRUM_H + TT_H

# The coil. Wound copper between two pressboard collars, on a mandrel that
# stands proud of the top so the clamp spider has something to hold.
COIL_IN = 0.30
COIL_OUT = 0.58
COLLAR = 0.04
WIND_Z0 = TT_TOP + COLLAR
WIND_H = 0.66
WIND_Z1 = WIND_Z0 + WIND_H
RIB = 0.022                   # one turn of wire, as a torus
RIB_PITCH = 0.05
STRIPS = 8                    # pressboard spacers round the winding
JAWS = 4
COIL_SPIN = 90.0              # 8 strips, 4 jaws, 4 spider arms all close
assert COIL_SPIN % (360.0 / STRIPS) == 0 and COIL_SPIN % (360.0 / JAWS) == 0

# Guide column in the back right corner. Its carriage rides the middle of
# the winding, half a winding-height up and down.
GX, GY = 1.00, 0.75
COL_TOP = 1.45
CAR_Z = WIND_Z0 + WIND_H / 2
CAR_STROKE = 0.25
assert CAR_Z - CAR_STROKE > WIND_Z0 - 0.05 and CAR_Z + CAR_STROKE < WIND_Z1

# Payoff spool, lying flat in the front right corner.
SX, SY = 0.92, -0.98
SPOOL_R = 0.38
STAND_R = 0.42
# The stand is round, and far enough out to clear the drive drum.
assert math.hypot(SX - CX, SY - CY) > DRUM_R + STAND_R
SPOKES = 6
SPOOL_SPIN = 360.0 / SPOKES

# Cabinet front left, motor back left.
KX, KY = -1.00, -1.00
MX, MY = -1.05, 0.85


def annulus(x, y, z, r_out, r_in, h, m, verts=48):
    """A flat ring with a real inner wall, cut with a boolean."""
    ring = cyl_at(x, y, z + h / 2, r_out, h, m, verts=verts)
    cutter = cyl_at(x, y, z + h / 2, r_in, h + 0.02, m, verts=verts)
    mod = ring.modifiers.new("bore", 'BOOLEAN')
    mod.operation = 'DIFFERENCE'
    mod.object = cutter
    bpy.context.view_layer.objects.active = ring
    bpy.ops.object.modifier_apply(modifier=mod.name)
    mesh = cutter.data
    bpy.data.objects.remove(cutter, do_unlink=True)
    bpy.data.meshes.remove(mesh)
    return ring


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS

    m['pad'] = mat("pad", (0.088, 0.082, 0.078), 0.90, 0.0, wear=0.55)
    # Machine-tool green. Nothing else in the mod wears it, so the winder is
    # told from the plate-grey machines at a glance, and copper reads
    # against it better than against grey.
    m['paint'] = mat("paint", (0.105, 0.175, 0.135), 0.55, 0.30, wear=0.60)
    # New enamelled wire, and the one bright thing on the machine. No wear:
    # the grime pass would lay dark patches over the part the sprite is
    # about.
    m['copper'] = mat("copper", (0.420, 0.180, 0.070), 0.34, 1.0)
    # Pressboard, the brown card transformer windings are insulated with.
    # Kept off the wear pass for the same reason as the copper.
    m['board'] = mat("board", (0.400, 0.290, 0.150), 0.85, 0.0)
    m['screen'] = mat("screen", (0.020, 0.030, 0.030), 0.20, 0.0,
                      emit=(0.10, 0.60, 0.50), emit_str=0.40)
    m['go'] = mat("go", (0.020, 0.100, 0.030), 0.40, 0.0,
                  emit=(0.10, 0.90, 0.20), emit_str=0.60)
    m['stop'] = mat("stop", (0.100, 0.010, 0.010), 0.40, 0.0,
                    emit=(0.90, 0.05, 0.05), emit_str=0.45)

    static = []
    add = static.append

    # --- pad and drive ----------------------------------------------------
    add(box(PAD, PAD, PAD_H, (0, 0, PAD_H / 2), m=m['pad']))
    add(cyl_at(CX, CY, PAD_H + DRUM_H / 2, DRUM_R, DRUM_H, m['paint'],
               verts=48))
    add(torus_at((CX, CY, PAD_H + DRUM_H - 0.02), DRUM_R + 0.005, 0.03,
                 m['steel'], segments=48))
    # Motor and gearbox, driving the drum from the back left.
    add(cyl_at(MX, MY, PAD_H + 0.20, 0.18, 0.40, m['paint'], verts=24))
    add(cyl_at(MX, MY, PAD_H + 0.42, 0.13, 0.05, m['dark'], verts=20))
    add(box(0.32, 0.26, 0.22, (MX + 0.22, MY - 0.22, PAD_H + 0.11),
            m=m['iron']))

    # --- the turning coil -------------------------------------------------
    turning = []
    t = turning.append
    t(cyl_at(CX, CY, TT_TOP - TT_H / 2, TT_R, TT_H, m['steel'], verts=56))
    # T-slots across the table, and the jaws between them. They are what
    # says the table is turning: a plain disc turning looks like a plain
    # disc standing still.
    for k in range(STRIPS):
        a = 2 * math.pi * k / STRIPS
        r = (COIL_OUT + 0.04 + TT_R - 0.02) / 2
        t(box(TT_R - COIL_OUT - 0.06, 0.04, 0.012,
              (CX + r * math.cos(a), CY + r * math.sin(a), TT_TOP + 0.004),
              rot=(0, 0, a), m=m['dark']))
    for k in range(JAWS):
        # Between the T-slots, not on them.
        a = 2 * math.pi * (k + 0.25) / JAWS
        r = 0.74
        t(box(0.14, 0.12, 0.10,
              (CX + r * math.cos(a), CY + r * math.sin(a), TT_TOP + 0.05),
              rot=(0, 0, a), m=m['yellow']))

    # The collars are rims, not discs. Full discs hid the whole top of the
    # winding under pressboard, and from this camera the top is most of
    # what the copper has to show.
    t(annulus(CX, CY, TT_TOP, COIL_OUT + 0.04, COIL_OUT - 0.07, COLLAR,
              m['board']))
    t(annulus(CX, CY, WIND_Z0, COIL_OUT, COIL_IN, WIND_H, m['copper']))
    # Turns of wire, as a stack of tori round the outside. Ribbed copper
    # says "wound"; a smooth copper drum says "pipe".
    z = WIND_Z0 + RIB_PITCH / 2
    while z < WIND_Z1 - RIB:
        t(torus_at((CX, CY, z), COIL_OUT, RIB, m['copper'], segments=48))
        z += RIB_PITCH
    t(annulus(CX, CY, WIND_Z1, COIL_OUT + 0.04, COIL_OUT - 0.07, COLLAR,
              m['board']))
    for k in range(STRIPS):
        a = 2 * math.pi * (k + 0.5) / STRIPS
        r = COIL_OUT + RIB + 0.012
        t(box(0.03, 0.055, WIND_H,
              (CX + r * math.cos(a), CY + r * math.sin(a),
               WIND_Z0 + WIND_H / 2), rot=(0, 0, a), m=m['board']))
    # Mandrel, standing proud, and the clamp spider holding the top collar.
    top = WIND_Z1 + COLLAR
    t(cyl_at(CX, CY, (TT_TOP + top + 0.08) / 2, COIL_IN, top + 0.08 - TT_TOP,
             m['steel'], verts=40))
    t(cyl_at(CX, CY, top + 0.13, 0.11, 0.10, m['iron'], verts=20))
    for k in range(JAWS):
        a = 2 * math.pi * k / JAWS
        r = (0.10 + COIL_OUT) / 2
        t(box(COIL_OUT - 0.10, 0.07, 0.06,
              (CX + r * math.cos(a), CY + r * math.sin(a), top + 0.03),
              rot=(0, 0, a), m=m['steel']))

    # --- guide column -----------------------------------------------------
    add(box(0.34, 0.34, 0.10, (GX, GY, PAD_H + 0.05), m=m['iron']))
    add(box(0.15, 0.15, COL_TOP - PAD_H - 0.10,
            (GX, GY, (PAD_H + 0.10 + COL_TOP) / 2), m=m['paint']))
    add(box(0.24, 0.22, 0.14, (GX, GY, COL_TOP + 0.07), m=m['paint']))
    # Tension roller on top, where the wire from the spool comes in.
    add(cyl_at(GX, GY - 0.06, COL_TOP + 0.20, 0.06, 0.22, m['steel'],
               verts=16, rot=(0, math.pi / 2, 0)))

    # The carriage and everything it carries. Its arm points at the coil
    # axis, so the roller on the end sits just off the winding in every
    # frame, clear of the turning strips.
    ux, uy = GX - CX, GY - CY
    n = math.hypot(ux, uy)
    ux, uy = ux / n, uy / n
    tip = (CX + ux * (COIL_OUT + 0.13), CY + uy * (COIL_OUT + 0.13))
    rest = (CX + ux * COIL_OUT, CY + uy * COIL_OUT)
    riding = [
        box(0.23, 0.23, 0.16, (GX, GY, CAR_Z), m=m['yellow']),
        bar((GX - ux * 0.12, GY - uy * 0.12, CAR_Z), (*tip, CAR_Z), 0.05,
            m['steel']),
        cyl_at(tip[0], tip[1], CAR_Z, 0.045, 0.10, m['dark'], verts=14),
        bar((*tip, CAR_Z), (*rest, CAR_Z), 0.014, m['copper']),
    ]

    # --- payoff spool -----------------------------------------------------
    add(cyl_at(SX, SY, PAD_H + 0.05, STAND_R, 0.10, m['paint'], verts=32))
    spool_z = PAD_H + 0.10
    spool = [
        cyl_at(SX, SY, spool_z + 0.02, SPOOL_R, 0.04, m['dark'], verts=40),
        cyl_at(SX, SY, spool_z + 0.04 + 0.15, SPOOL_R - 0.06, 0.30,
               m['copper'], verts=40),
        annulus(SX, SY, spool_z + 0.34, SPOOL_R, SPOOL_R - 0.08, 0.04,
                m['dark'], verts=40),
        cyl_at(SX, SY, spool_z + 0.38, 0.10, 0.08, m['iron'], verts=16),
    ]
    for zz in (spool_z + 0.10, spool_z + 0.19, spool_z + 0.28):
        spool.append(torus_at((SX, SY, zz), SPOOL_R - 0.06, 0.018,
                              m['copper'], segments=40))
    # Spokes on the top flange, with the wire showing between them: light
    # the gaps, not the spokes, and the spool reads as turning at any size.
    for k in range(SPOKES):
        a = 2 * math.pi * k / SPOKES
        r = (0.10 + SPOOL_R - 0.08) / 2
        spool.append(box(SPOOL_R - 0.18, 0.05, 0.04,
                         (SX + r * math.cos(a), SY + r * math.sin(a),
                          spool_z + 0.36), rot=(0, 0, a), m=m['dark']))
    # The wire, off the back of the spool and up to the column's roller.
    # It runs east of the turntable, clear of it.
    add(bar((SX + 0.05, SY + SPOOL_R - 0.06, spool_z + 0.26),
            (GX, GY - 0.06, COL_TOP + 0.20), 0.014, m['copper']))

    # --- control cabinet --------------------------------------------------
    add(box(0.48, 0.36, 0.72, (KX, KY, PAD_H + 0.36), m=m['paint']))
    add(box(0.52, 0.40, 0.04, (KX, KY, PAD_H + 0.74), m=m['iron']))
    front = KY - 0.18
    add(box(0.30, 0.012, 0.18, (KX, front - 0.004, PAD_H + 0.54),
            m=m['screen']))
    for dx, mm in ((-0.10, 'go'), (0.10, 'stop')):
        add(cyl_at(KX + dx, front - 0.01, PAD_H + 0.30, 0.035, 0.03, m[mm],
                   verts=12, rot=(math.pi / 2, 0, 0)))

    moving = [
        Spin(turning, pivot=(CX, CY, 0), axis='Z', degrees=COIL_SPIN),
        Spin(spool, pivot=(SX, SY, 0), axis='Z', degrees=-SPOOL_SPIN),
        Slide(riding, axis='Z', amplitude=CAR_STROKE),
    ]
    return static, moving


fr.run(build)
