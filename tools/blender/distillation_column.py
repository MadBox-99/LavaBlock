"""Distillation Column - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python distillation_column.py -- \
          --pass entity|shadow --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

The tower is the building. A clad column nearly four tiles tall on the west
half, ringed by its tray seams and two access platforms, with the feed line
climbing its face to the feed tray and the reboiler lying at its foot. The
east half is the overhead system every column has: a fin-fan air cooler that
condenses the vapour coming off the top, and the reflux drum and pump behind
it that send part of the condensate back down the tower.

The fan on the cooler is the part that turns. It lies flat, so it is seen
turning in all four facings, and nothing is built over it: the vapour line
comes down behind the cooler, to the north, where the fan is drawn over it
rather than the other way round. The reflux pump's ram is the second
motion, and the tower itself does not move at all - which is right, and is
what makes the two small things that do move read as the plant running.

Four facings: four ports on named faces.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at,         # noqa: E402
                             torus_at, box, MATS, mat, Spin, Slide)

# --- plan ------------------------------------------------------------------
CX, CY = -0.50, 0.30            # the column
C_R = 0.50
SKIRT_Z, SKIRT_TOP = 0.25, 0.60
TOP = 3.85                      # top tangent line of the shell
TRAY_PITCH = 0.40               # a seam per tray
PLATFORMS = (1.75, 3.05)
PLAT_R = 0.70                   # kept short of the fan's x range

# Fin-fan air cooler on the east half.
FX, FY = 0.75, -0.32            # fan axis
BANK_X = (0.15, 1.35)
BANK_Y = (-1.12, 0.46)
BANK_Z = (0.44, 0.62)
SHROUD_R, SHROUD_WALL = 0.58, 0.05
SHROUD_Z, SHROUD_H = BANK_Z[1], 0.20
BLADES = 6
SPIN = 360 / BLADES
BLADE_LEN, BLADE_CHORD, BLADE_THK = 0.40, 0.17, 0.030
PITCH = math.radians(22)
FAN_Z = SHROUD_Z + 0.10
BLADE_TOP = FAN_Z + (BLADE_LEN / 2) * math.sin(PITCH) \
    + (BLADE_THK / 2) * math.cos(PITCH) + 0.012
# Nothing above the sweep, and the shroud rim stands just clear of it so the
# blades are seen inside a ring rather than floating over a box.
assert BLADE_TOP < SHROUD_Z + SHROUD_H + 0.02, "blades stand out of the shroud"

# Reflux drum and pump, north of the cooler.
DRUM_Y, DRUM_Z, DRUM_R = 1.02, 0.42, 0.20
PX, PY = 0.24, 1.08
PUMP_BODY_TOP = 0.78
PUMP_STROKE = 0.08
ROD_Z, ROD_LEN = 0.86, 0.34
assert ROD_Z - ROD_LEN / 2 + PUMP_STROKE < PUMP_BODY_TOP, "pump rod lifts out"

STUB_Z = 0.36


def hollow(x, y, z, r, wall, h, material, verts=48):
    """A standing ring with an inner wall the camera can see down into."""
    outer = cyl_at(x, y, z + h / 2, r, h, material, verts=verts)
    bore = cyl_at(x, y, z + h / 2, r - wall, h + 0.02, material, verts=verts)
    mod = outer.modifiers.new("bore", 'BOOLEAN')
    mod.operation = 'DIFFERENCE'
    mod.object = bore
    bpy.context.view_layer.objects.active = outer
    bpy.ops.object.modifier_apply(modifier=mod.name)
    mesh = bore.data
    bpy.data.objects.remove(bore, do_unlink=True)
    bpy.data.meshes.remove(mesh)
    return outer


def pipe_y(x, y0, y1, z, r, material):
    return cyl_at(x, (y0 + y1) / 2, z, r, abs(y1 - y0), material, verts=14,
                  rot=(math.pi / 2, 0, 0))


def pipe_x(x0, x1, y, z, r, material):
    return cyl_at((x0 + x1) / 2, y, z, r, abs(x1 - x0), material, verts=14,
                  rot=(0, math.pi / 2, 0))


def pipe_z(x, y, z0, z1, r, material):
    return cyl_at(x, y, (z0 + z1) / 2, r, abs(z1 - z0), material, verts=14)


def port(static, m, x, sign):
    axis = (math.pi / 2, 0, 0)
    static.append(box(0.34, 0.40, 0.40, (x, sign * 1.05, STUB_Z), m=m['iron']))
    static.append(cyl_at(x, sign * 1.30, STUB_Z, 0.165, 0.70, m['steel'],
                         verts=24, rot=axis))
    static.append(cyl_at(x, sign * 1.46, STUB_Z, 0.215, 0.10, m['dark'],
                         verts=24, rot=axis))


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    # Aluminium cladding over the insulation, which is what the outside of a
    # real column is. Light, so no wear (see docs, Materials), and not fully
    # metallic or its shaded side goes black.
    m['clad'] = mat("clad", (0.400, 0.400, 0.388), 0.45, 0.65)
    m['seam'] = mat("seam", (0.150, 0.150, 0.145), 0.50, 0.80, wear=0.40)
    m['pad'] = mat("pad", (0.150, 0.145, 0.138), 0.92, 0.0, wear=0.55)
    m['galv'] = mat("galv", (0.240, 0.250, 0.245), 0.48, 0.85, wear=0.60)
    m['fins'] = mat("fins", (0.130, 0.135, 0.130), 0.60, 0.80, wear=0.50)

    static, moving = [], []
    add = static.append

    # --- plinth -----------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.10, (0, 0, 0.17), m=m['pad']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(cyl_at(sx * 1.24, sy * 1.24, 0.24, 0.075, 0.08, m['steel'],
                       verts=6))

    # --- the column -------------------------------------------------------
    add(cyl_at(CX, CY, (SKIRT_Z + SKIRT_TOP) / 2, C_R - 0.02,
               SKIRT_TOP - SKIRT_Z, m['seam'], verts=40))
    add(cyl_at(CX, CY, (SKIRT_TOP + TOP) / 2, C_R, TOP - SKIRT_TOP,
               m['clad'], verts=48))
    # Tray seams: one band per tray, which is what makes a tall cylinder
    # read as a column and not as a chimney or a silo.
    z = SKIRT_TOP + TRAY_PITCH
    while z < TOP - 0.1:
        add(torus_at((CX, CY, z), C_R + 0.004, 0.016, m['seam'],
                     segments=48))
        z += TRAY_PITCH
    # Top head, a flattened dome.
    bpy.ops.mesh.primitive_uv_sphere_add(segments=48, ring_count=16,
                                         radius=C_R, location=(CX, CY, TOP))
    head = bpy.context.object
    head.scale = (1.0, 1.0, 0.45)
    head.data.materials.append(m['clad'])
    add(head)
    add(torus_at((CX, CY, TOP), C_R + 0.006, 0.022, m['seam'], segments=48))

    # Manways on the south face, where the camera sees them.
    for mz in (1.25, 2.55):
        add(cyl_at(CX + 0.12, CY - C_R - 0.05, mz, 0.12, 0.12, m['seam'],
                   verts=20, rot=(math.pi / 2, 0, 0)))
        add(cyl_at(CX + 0.12, CY - C_R - 0.12, mz, 0.15, 0.03, m['steel'],
                   verts=20, rot=(math.pi / 2, 0, 0)))

    # Platforms and their handrails. Dark grating and hazard-yellow rails:
    # the rails are the one warm accent on an otherwise grey plant.
    for pz in PLATFORMS:
        add(cyl_at(CX, CY, pz, PLAT_R, 0.04, m['dark'], verts=40))
        add(torus_at((CX, CY, pz + 0.26), PLAT_R - 0.02, 0.014,
                     m['yellow'], segments=40))
        for k in range(8):
            a = 2 * math.pi * (k + 0.5) / 8
            add(cyl_at(CX + (PLAT_R - 0.02) * math.cos(a),
                       CY + (PLAT_R - 0.02) * math.sin(a), pz + 0.13,
                       0.012, 0.26, m['yellow'], verts=6))
    # Ladder up the west flank, rails only - a cage is a lattice the eye
    # reads as noise at this size.
    for dy in (-0.08, 0.08):
        add(pipe_z(CX - C_R - 0.07, CY + dy, SKIRT_TOP, PLATFORMS[1],
                   0.014, m['iron']))

    # --- feed line --------------------------------------------------------
    # From the south-west port up the column face to the feed tray, part way
    # up the tower where the wash goes in.
    fx, fy, feed_z = -1.0, CY - C_R - 0.22, 2.15
    add(pipe_y(fx, -1.05, fy, STUB_Z, 0.075, m['steel']))
    add(pipe_z(fx, fy, STUB_Z, feed_z, 0.075, m['steel']))
    add(pipe_x(fx, CX - 0.20, fy, feed_z, 0.075, m['steel']))
    add(pipe_y(CX - 0.20, fy, CY - C_R + 0.05, feed_z, 0.075, m['steel']))

    # --- reboiler ---------------------------------------------------------
    # A kettle lying at the foot of the tower, heated by the steam line from
    # the south-east port, with two risers into the bottom of the column.
    rx0, rx1, ry, rz, rr = -0.95, 0.10, -0.80, 0.46, 0.24
    add(pipe_x(rx0, rx1, ry, rz, rr, m['galv']))
    for x in (rx0 + 0.04, rx1 - 0.04):
        add(cyl_at(x, ry, rz, rr + 0.03, 0.05, m['dark'], verts=24,
                   rot=(0, math.pi / 2, 0)))
    for x in (CX - 0.18, CX + 0.18):
        add(pipe_y(x, ry, CY - C_R + 0.05, rz + 0.12, 0.060, m['steel']))
    add(pipe_x(rx1, 1.0, -1.12, STUB_Z, 0.070, m['steel']))
    add(pipe_y(rx1 - 0.02, -1.12, ry, STUB_Z, 0.070, m['steel']))

    # --- fin-fan cooler ---------------------------------------------------
    for sx in BANK_X:
        for sy in BANK_Y:
            add(pipe_z(sx + (0.05 if sx == BANK_X[0] else -0.05),
                       sy + (0.05 if sy == BANK_Y[0] else -0.05),
                       0.22, BANK_Z[0], 0.035, m['iron']))
    bx, by = (BANK_X[0] + BANK_X[1]) / 2, (BANK_Y[0] + BANK_Y[1]) / 2
    bw, bd = BANK_X[1] - BANK_X[0], BANK_Y[1] - BANK_Y[0]
    add(box(bw, bd, BANK_Z[1] - BANK_Z[0], (bx, by, sum(BANK_Z) / 2),
            m=m['galv']))
    # Finned tubes showing along the top of the bank, either side of the
    # shroud: rows of dark ribs, so the box reads as a radiator.
    for i in range(9):
        x = BANK_X[0] + 0.07 + i * (bw - 0.14) / 8
        add(box(0.035, bd - 0.10, 0.03, (x, by, BANK_Z[1] + 0.005),
                m=m['fins']))
    # Headers at both ends of the bundle.
    for hy in (BANK_Y[0] - 0.05, BANK_Y[1] + 0.05):
        add(box(bw, 0.10, 0.20, (bx, hy, sum(BANK_Z) / 2), m=m['iron']))
    # Fan shroud: a hollow ring the camera sees into, hazard yellow on its
    # rim so the fan is found at a glance.
    add(hollow(FX, FY, SHROUD_Z, SHROUD_R, SHROUD_WALL, SHROUD_H,
               m['galv']))
    add(torus_at((FX, FY, SHROUD_Z + SHROUD_H), SHROUD_R - 0.02, 0.022,
                 m['yellow'], segments=48))
    add(cyl_at(FX, FY, SHROUD_Z + 0.01, SHROUD_R - 0.04, 0.02, m['dark'],
               verts=40))
    add(cyl_at(FX, FY, FAN_Z - 0.07, 0.10, 0.10, m['dark'], verts=16))

    fan = [cyl_at(FX, FY, FAN_Z, 0.11, 0.08, m['steel'], verts=20)]
    for i in range(BLADES):
        a = 2 * math.pi * i / BLADES
        b = box(BLADE_LEN, BLADE_CHORD, BLADE_THK,
                (FX + 0.30 * math.cos(a), FY + 0.30 * math.sin(a), FAN_Z),
                rot=(0, 0, a), m=m['steel'])
        b.rotation_euler[1] = PITCH
        fan.append(b)
    moving.append(Spin(fan, pivot=(FX, FY, 0), axis='Z', degrees=SPIN))

    # --- overhead vapour line ---------------------------------------------
    # Off the top of the head, east, and down BEHIND the cooler to its north
    # header. North of the fan it is drawn over by the fan and never across
    # it.
    vx, vy = 0.10, 0.70
    vtop = TOP + C_R * 0.45 + 0.10
    add(pipe_z(CX, CY, TOP + C_R * 0.40, vtop, 0.090, m['clad']))
    add(pipe_x(CX, vx, CY, vtop, 0.090, m['clad']))
    add(pipe_y(vx, CY, vy, vtop, 0.090, m['clad']))
    add(pipe_z(vx, vy, BANK_Z[1] - 0.05, vtop, 0.090, m['clad']))
    add(pipe_x(vx, BANK_X[0] + 0.1, vy, BANK_Z[1] - 0.05, 0.090, m['clad']))

    # --- reflux drum and pump ---------------------------------------------
    add(pipe_x(0.30, 1.22, DRUM_Y, DRUM_Z, DRUM_R, m['galv']))
    for x in (0.30, 1.22):
        add(cyl_at(x, DRUM_Y, DRUM_Z, DRUM_R + 0.02, 0.04, m['dark'],
                   verts=24, rot=(0, math.pi / 2, 0)))
    add(pipe_z(0.95, BANK_Y[1] + 0.12, DRUM_Z, BANK_Z[0] + 0.05, 0.05,
               m['steel']))
    add(pipe_z(PX, PY, 0.22, PUMP_BODY_TOP - 0.10, 0.12, m['iron']))
    add(cyl_at(PX, PY, PUMP_BODY_TOP - 0.03, 0.14, 0.06, m['dark'],
               verts=20))
    ram = [cyl_at(PX, PY, ROD_Z, 0.040, ROD_LEN, m['steel'], verts=12),
           cyl_at(PX, PY, ROD_Z + ROD_LEN / 2, 0.10, 0.07, m['yellow'],
                  verts=16)]
    moving.append(Slide(ram, axis='Z', amplitude=PUMP_STROKE))

    # --- products to the north ports --------------------------------------
    # Ethanol from the drum to the north-east port; water from the column
    # sump to the north-west one.
    add(pipe_y(1.0, DRUM_Y, 1.05, STUB_Z, 0.070, m['steel']))
    add(pipe_z(-1.0, CY + 0.40, STUB_Z, 0.45, 0.070, m['steel']))
    add(pipe_y(-1.0, CY + 0.40, 1.05, STUB_Z, 0.070, m['steel']))

    # --- fluid connections: wash + steam in (S), water + ethanol out (N) --
    port(static, m, -1.0, -1)
    port(static, m, 1.0, -1)
    port(static, m, -1.0, 1)
    port(static, m, 1.0, 1)

    return static, moving


fr.run(build, frame_tiles=8)
