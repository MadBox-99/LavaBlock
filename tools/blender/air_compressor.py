"""Air compressor - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python air_compressor.py -- \
          --pass entity|shadow --direction north --frames 32 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

Deliberately cold and grey against the lava centrifuge's orange: this machine
is the air route, not the lava route, and the two should be told apart at a
glance on a crowded base.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl, cyl_at,    # noqa: E402
                             cone, box, ring_of, MATS, mat)

BLADES = 8          # fan blade count; the spin angle must be a multiple of
SPIN = 360 / BLADES  # 360/BLADES for the loop to close
FX, FY = -0.62, -0.62   # fan axis; the impeller is off-centre, so run() has to
                        # be told about it or the blades orbit the machine


def ring(into, x, y, z, major, minor, material, segments=40):
    """A torus, for a rim that the eye reads as a hollow guard ring."""
    bpy.ops.mesh.primitive_torus_add(location=(x, y, z), major_radius=major,
                                     minor_radius=minor,
                                     major_segments=segments, minor_segments=8)
    o = bpy.context.object
    o.data.materials.append(material)
    into.append(o)
    return o


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['cool'] = mat("cool", (0.115, 0.150, 0.180), 0.42, 1.0, wear=0.70)
    m['lamp'] = mat("lamp", (0.030, 0.070, 0.080), 0.30, 0.2,
                    emit=(0.30, 0.85, 1.00), emit_str=2.4)
    static, spin = [], []

    # --- skid base ------------------------------------------------------
    static.append(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    static.append(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['iron']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            static.append(cyl_at(sx * 1.24, sy * 1.24, 0.23, 0.075, 0.08,
                                 m['steel'], verts=6))
    # hazard kerb along the front edge
    for i in range(6):
        static.append(box(0.36, 0.10, 0.10, (-1.15 + i * 0.46, -1.34, 0.22),
                          m=m['yellow'] if i % 2 == 0 else m['dark']))

    # Three separate masses, none hiding another: receiver across the back,
    # fan front left, motor front right. At 32 px per tile a machine reads by
    # its silhouette, so overlapping blocks just turn into mush.

    # --- receiver: a horizontal pressure vessel on saddles ---------------
    static.append(cyl_at(0, 0.80, 0.86, 0.52, 2.34, m['cool'], verts=48,
                         rot=(0, math.pi / 2, 0)))
    for sx in (-1, 1):                                   # dished ends
        static.append(cyl_at(sx * 1.18, 0.80, 0.86, 0.54, 0.10, m['steel'],
                             verts=48, rot=(0, math.pi / 2, 0)))
    for sx in (-1, 1):                                   # saddle supports
        static.append(box(0.24, 0.62, 0.62, (sx * 0.80, 0.80, 0.41), m=m['dark']))
    for i in range(5):                                   # strapping bands
        static.append(cyl_at(-0.92 + i * 0.46, 0.80, 0.86, 0.545, 0.05,
                             m['dark'], verts=48, rot=(0, math.pi / 2, 0)))

    # --- fan unit: low drum with the impeller open on top ----------------
    static.append(cyl_at(FX, FY, 0.44, 0.66, 0.50, m['cool'], verts=40))
    static.append(cyl_at(FX, FY, 0.71, 0.70, 0.06, m['dark'], verts=40))

    # The guard has to clear the impeller's sweep, not cut through it. Pitched
    # 28 deg, a blade's outer edge reaches z = 0.93; a bar crossing the blades
    # mid-air reads as broken geometry, where blades rising out of the drum's
    # flat top just read as a recessed impeller. Hence GUARD_Z, and the posts
    # that carry it - a grille floating over the drum on nothing looks no
    # better than one buried in the fan.
    GUARD_Z = 1.02
    ring(static, FX, FY, GUARD_Z, 0.70, 0.055, m['dark'])   # guard rim
    for i in range(3):                                      # guard bars on top
        static.append(box(1.40, 0.05, 0.045, (FX, FY, GUARD_Z),
                          rot=(0, 0, math.pi * i / 3), m=m['dark']))
    for i in range(6):                                      # posts under the ends
        a = math.pi * i / 3
        static.append(cyl_at(FX + 0.70 * math.cos(a), FY + 0.70 * math.sin(a),
                             0.87, 0.042, 0.30, m['dark'], verts=8))

    # --- fan (animated) --------------------------------------------------
    spin.append(cyl_at(FX, FY, 0.78, 0.17, 0.16, m['steel'], verts=24))
    for i in range(BLADES):
        a = 2 * math.pi * i / BLADES
        b = box(0.52, 0.26, 0.035,
                (FX + 0.34 * math.cos(a), FY + 0.34 * math.sin(a), 0.78),
                rot=(0, 0, a), m=m['steel'])
        b.rotation_euler[1] = math.radians(28)    # pitch, so the blades bite
        spin.append(b)

    # --- motor and control box ------------------------------------------
    static.append(cyl_at(0.74, -0.66, 0.52, 0.36, 0.86, m['iron'],
                         verts=32, rot=(0, math.pi / 2, 0)))
    for i in range(6):                                   # motor cooling fins
        static.append(cyl_at(0.36 + i * 0.16, -0.66, 0.52, 0.39, 0.04,
                             m['dark'], verts=32, rot=(0, math.pi / 2, 0)))
    static.append(cyl_at(1.22, -0.66, 0.52, 0.22, 0.14, m['dark'], verts=24,
                         rot=(0, math.pi / 2, 0)))
    static.append(cyl_at(FX, FY - 0.66, 0.44, 0.07, 0.06, m['lamp'], verts=16,
                         rot=(math.pi / 2, 0, 0)))

    # --- delivery pipe: fan drum to receiver, routed round the impeller --
    # Anything crossing the fan face reads as a pole stuck through it.
    static.append(cyl_at(0.08, -0.62, 0.36, 0.105, 0.42, m['steel'], verts=16,
                         rot=(0, math.pi / 2, 0)))
    static.append(cyl_at(0.08, -0.06, 0.36, 0.105, 1.20, m['steel'], verts=16,
                         rot=(math.pi / 2, 0, 0)))
    static.append(cyl_at(0.08, 0.52, 0.52, 0.105, 0.36, m['steel'], verts=16))

    # --- fluid connections: N in, S out (matches fluid_boxes) ------------
    # Slim on purpose - the game draws pipe_picture over these, and a stub
    # sized to a vanilla pipe doubles up with it.
    for dx, dy in ((0, 1), (0, -1)):
        ang = math.atan2(dy, dx)
        axis = (math.pi / 2, 0, ang + math.pi / 2)
        static.append(box(0.34, 0.44, 0.40, (dx * 1.05, dy * 1.05, 0.36),
                          rot=(0, 0, ang), m=m['iron']))
        static.append(cyl_at(dx * 1.30, dy * 1.30, 0.36, 0.165, 0.70,
                             m['steel'], verts=24, rot=axis))
        static.append(cyl_at(dx * 1.46, dy * 1.46, 0.36, 0.215, 0.10,
                             m['dark'], verts=24, rot=axis))

    return static, spin


fr.run(build, spin_degrees=SPIN * 2,   # two blade pitches, still seamless
       pivot=(FX, FY, 0))              # ...about the impeller's own axis
