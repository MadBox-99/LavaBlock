"""Fuel Plant - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python fuel_plant.py -- \
          --pass entity|shadow --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

Three things a fuel plant is recognised by, one per quarter of the pad. A
white insulated sphere on legs holds the oxygen, because a sphere is the
shape every cryogenic store is built in and nothing else in the mod is
round in that way. A rust-red lagged reactor beside it is where petroleum
gas and steam meet the catalyst. Across the front, a filling press charges
rocket fuel canisters, with a dosing pump's flywheel turning flat at its
east end.

The press head and the flywheel are the two moving parts, and both are at
the front of the pad with nothing built over them. The sphere and the
reactor stand behind, to the north, where the moving parts are drawn over
them and never under.

Four facings: two feeds on the south face and a product on the north.
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
SX, SY, SZ, S_R = 0.60, 0.52, 1.02, 0.60        # oxygen sphere
RX, RY, R_R = -0.74, 0.52, 0.40                 # reactor
R_Z0, R_Z1 = 0.26, 1.85

BENCH_X = (-0.95, 0.30)                         # filling press, front left
BENCH_Y, BENCH_D, BENCH_H = -0.62, 0.52, 0.40
CANS = 3
PRESS_Z = BENCH_H + 0.52
PRESS_STROKE = 0.09

WX, WY = 0.82, -0.40                            # dosing pump flywheel
W_R, W_Z = 0.30, 0.62
SPOKES = 5
SPIN = 360 / SPOKES

STUB_Z = 0.36


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
    # The sphere is the one white thing on the pad, so no wear at all.
    # Slightly cool, the way frosted insulation looks next to warm plate.
    m['lox'] = mat("lox", (0.520, 0.540, 0.565), 0.55, 0.0)
    # Rust-red lagging on the reactor: hot plant is painted to be seen, and
    # it keeps the reactor apart from the grey column and tank at a glance.
    m['lag'] = mat("lag", (0.300, 0.075, 0.045), 0.62, 0.30, wear=0.55)
    m['deck'] = mat("deck", (0.062, 0.058, 0.055), 0.80, 0.20, wear=0.55)
    m['bench'] = mat("bench", (0.200, 0.205, 0.210), 0.48, 0.80, wear=0.60)
    # Rocket fuel canisters, the same red the base game draws the item in.
    m['can'] = mat("can", (0.420, 0.070, 0.035), 0.40, 0.50)

    static, moving = [], []
    add = static.append

    # --- skid base --------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(cyl_at(sx * 1.24, sy * 1.24, 0.23, 0.075, 0.08, m['steel'],
                       verts=6))
    # Hazard kerb along the front edge: this pad handles liquid oxygen.
    for i in range(6):
        add(box(0.36, 0.10, 0.08, (-1.15 + i * 0.46, -1.34, 0.21),
                m=m['yellow'] if i % 2 == 0 else m['dark']))

    # --- oxygen sphere ----------------------------------------------------
    bpy.ops.mesh.primitive_uv_sphere_add(segments=48, ring_count=24,
                                         radius=S_R, location=(SX, SY, SZ))
    sphere = bpy.context.object
    sphere.data.materials.append(m['lox'])
    add(sphere)
    add(torus_at((SX, SY, SZ), S_R + 0.005, 0.030, m['steel'], segments=48))
    for k in range(4):
        a = math.pi / 4 + k * math.pi / 2
        lx, ly = SX + 0.46 * math.cos(a), SY + 0.46 * math.sin(a)
        add(pipe_z(lx, ly, 0.22, SZ - 0.05, 0.045, m['iron']))
    # Relief valve on the crown.
    add(pipe_z(SX, SY, SZ + S_R - 0.02, SZ + S_R + 0.12, 0.040, m['steel']))
    add(cyl_at(SX, SY, SZ + S_R + 0.14, 0.07, 0.05, m['yellow'], verts=12))

    # --- reactor ----------------------------------------------------------
    add(cyl_at(RX, RY, (R_Z0 + R_Z1) / 2, R_R, R_Z1 - R_Z0, m['lag'],
               verts=40))
    for z in (R_Z0 + 0.30, (R_Z0 + R_Z1) / 2, R_Z1 - 0.30):
        add(torus_at((RX, RY, z), R_R + 0.006, 0.020, m['dark'],
                     segments=40))
    bpy.ops.mesh.primitive_uv_sphere_add(segments=40, ring_count=12,
                                         radius=R_R, location=(RX, RY, R_Z1))
    head = bpy.context.object
    head.scale = (1.0, 1.0, 0.40)
    head.data.materials.append(m['steel'])
    add(head)
    # Catalyst hatch on the front, and a thermowell above it.
    add(cyl_at(RX + 0.10, RY - R_R - 0.04, 1.05, 0.12, 0.08, m['steel'],
               verts=20, rot=(math.pi / 2, 0, 0)))
    add(cyl_at(RX - 0.14, RY - R_R - 0.03, 1.45, 0.030, 0.10, m['yellow'],
               verts=8, rot=(math.pi / 2, 0, 0)))

    # --- filling press ----------------------------------------------------
    bx = (BENCH_X[0] + BENCH_X[1]) / 2
    bw = BENCH_X[1] - BENCH_X[0]
    add(box(bw, BENCH_D, BENCH_H, (bx, BENCH_Y, BENCH_H / 2 + 0.10),
            m=m['bench']))
    for i in range(CANS):
        x = BENCH_X[0] + bw * (i + 0.5) / CANS
        add(cyl_at(x, BENCH_Y - 0.06, BENCH_H + 0.21, 0.11, 0.22, m['can'],
                   verts=20))
        add(cyl_at(x, BENCH_Y - 0.06, BENCH_H + 0.33, 0.05, 0.04, m['steel'],
                   verts=12))
    # Guide posts at the ENDS of the bench and no beam over it, the same
    # rule as the Pug Mill's press: the canisters are what say "fuel".
    for x in BENCH_X:
        add(pipe_z(x, BENCH_Y + 0.12, 0.30, PRESS_Z + 0.02, 0.040,
                   m['iron']))
    press = [box(bw * 0.86, 0.16, 0.08, (bx, BENCH_Y + 0.12, PRESS_Z - 0.06),
                 m=m['steel'])]
    for i in range(CANS):
        x = BENCH_X[0] + bw * (i + 0.5) / CANS
        press.append(cyl_at(x, BENCH_Y + 0.02, PRESS_Z - 0.14, 0.045, 0.12,
                            m['dark'], verts=10))
    moving.append(Slide(press, axis='Z', amplitude=PRESS_STROKE))

    # --- dosing pump and its flywheel -------------------------------------
    add(box(0.46, 0.40, W_Z - 0.28, (WX, WY + 0.02, (W_Z - 0.28) / 2 + 0.20),
            m=m['iron']))
    add(cyl_at(WX, WY, W_Z - 0.05, 0.08, 0.10, m['dark'], verts=12))
    wheel = [torus_at((WX, WY, W_Z), W_R, 0.040, m['steel'], segments=40),
             cyl_at(WX, WY, W_Z, 0.07, 0.08, m['steel'], verts=16)]
    for i in range(SPOKES):
        a = 2 * math.pi * i / SPOKES
        wheel.append(box(W_R, 0.05, 0.04,
                         (WX + W_R / 2 * math.cos(a), WY + W_R / 2 * math.sin(a),
                          W_Z), rot=(0, 0, a), m=m['dark']))
    # One painted mark on the rim, so the turn reads even where the spokes
    # blur.
    wheel.append(cyl_at(WX + W_R, WY, W_Z + 0.03, 0.045, 0.04, m['yellow'],
                        verts=10))
    moving.append(Spin(wheel, pivot=(WX, WY, 0), axis='Z', degrees=SPIN))

    # --- pipework ---------------------------------------------------------
    # South-west feed up into the reactor; south-east feed to the pump and
    # on to the sphere; sphere and reactor down to the press manifold;
    # reactor product out to the north port.
    add(pipe_y(-1.0, -1.05, RY - R_R - 0.06, STUB_Z, 0.070, m['steel']))
    add(pipe_y(1.0, -1.05, WY, STUB_Z, 0.070, m['steel']))
    add(pipe_x(WX + 0.20, 1.0, WY, STUB_Z, 0.070, m['steel']))
    add(pipe_y(SX + 0.05, WY + 0.22, SY - S_R + 0.10, 0.34, 0.060,
               m['steel']))
    add(pipe_x(BENCH_X[1], WX - 0.22, BENCH_Y + 0.08, 0.34, 0.060,
               m['steel']))
    add(pipe_z(RX + R_R + 0.06, RY, STUB_Z, 0.80, 0.060, m['steel']))
    add(pipe_x(RX + R_R, 0.0, RY + 0.30, STUB_Z, 0.070, m['steel']))
    add(pipe_y(0.0, RY + 0.30, 1.05, STUB_Z, 0.070, m['steel']))

    # --- fluid connections: two in (S), one out (N) ----------------------
    port(static, m, -1.0, -1)
    port(static, m, 1.0, -1)
    port(static, m, 0.0, 1)

    return static, moving


fr.run(build)
