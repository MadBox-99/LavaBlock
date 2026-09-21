"""Arboretum - Factorio 5x5 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python arboretum.py -- \
          --pass entity|shadow --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A glasshouse: four raised beds of conifers under sloped glass, lit by magenta
grow lamps under the eaves, with a centre-pivot irrigation boom sweeping over
them. Green and glass against the compressor's blue-grey, the condenser's teal
and the centrifuge's orange.

The roof deliberately stops short of the middle. A closed glass roof would sit
directly over the only moving part in the machine and mute it; an open oculus
keeps the boom legible from the game's camera and gives the building a
silhouette nothing else in the mod has.

Five tiles across, so it needs a wider render frame than the 3x3 machines -
see the frame_tiles argument to run().
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at,         # noqa: E402
                             box, MATS, mat)

ARMS = 3             # irrigation boom arms; the spin angle must be 360/ARMS
SPIN = 360 / ARMS    # for the loop to close

HALF = 2.5           # 5x5 footprint
EAVE_Z = 1.46        # top of the wall, where the roof starts
RIDGE_Z = 1.92       # inner edge of the roof, around the open oculus
OCULUS = 1.55        # half-width of the opening the boom sweeps under

# The boom sweeps a circle, so it has to clear two things at every radius: the
# underside of the roof above it and the treetops below it. Both are worked out
# here rather than eyeballed, because a static part crossing a moving one is
# almost invisible in a still and glaring in motion.
ARM_Z = 1.52                                    # arm centre
ARM_THK = 0.08
# Short of the walls on purpose: the roof skirt slopes down towards them, so
# every extra 10 cm of reach costs clearance the boom does not have to spare.
BOOM_R = 1.85                                   # arm reach
# Roof underside is lowest where the boom reaches furthest out.
ROOF_UNDER = EAVE_Z + (2.28 - BOOM_R) / (2.28 - OCULUS) * (RIDGE_Z - EAVE_Z) - 0.05
NOZZLE_BOTTOM = 1.32
TREE_TOP = 1.26                                 # and it has to fit under the boom
assert ARM_Z + ARM_THK / 2 + 0.012 < ROOF_UNDER, "boom fouls the roof"
assert TREE_TOP < NOZZLE_BOTTOM, "boom fouls the treetops"


def glass():
    """Alpha-blended, not refractive. Cycles renders transmission fine, but the
    sprite has to carry an alpha channel the game can composite, and alpha is
    what survives that trip - you end up seeing the ground through the walls,
    which is exactly right for a glasshouse."""
    m = mat("glass", (0.105, 0.165, 0.175), 0.05, 0.0)
    m.node_tree.nodes['Principled BSDF'].inputs['Alpha'].default_value = 0.08
    return m


def cone_at(x, y, z, r1, r2, h, m, verts=16):
    bpy.ops.mesh.primitive_cone_add(vertices=verts, radius1=r1, radius2=r2,
                                    depth=h, location=(x, y, z + h / 2))
    o = bpy.context.object
    o.data.materials.append(m)
    return o


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['glass'] = glass()
    # Barely metallic on purpose. The frame is all thin bars, and a bar is
    # mostly bevelled edge: at metallic 0.6 every edge blew out into a
    # green-tinted specular and the whole building read as a mint cage.
    m['frame'] = mat("frame", (0.030, 0.052, 0.034), 0.55, 0.25, wear=0.50)
    m['soil'] = mat("soil", (0.070, 0.052, 0.038), 0.90, 0.0, wear=0.60)
    m['bark'] = mat("bark", (0.085, 0.062, 0.045), 0.85, 0.0, wear=0.55)
    m['leaf'] = mat("leaf", (0.078, 0.195, 0.062), 0.78, 0.0, wear=0.40)
    # Magenta because that is what a real horticultural LED looks like, and
    # because no other machine in the mod owns that colour.
    m['grow'] = mat("grow", (0.120, 0.020, 0.100), 0.30, 0.0,
                    emit=(1.00, 0.30, 0.70), emit_str=0.40)
    static, spin = [], []

    # --- base ------------------------------------------------------------
    static.append(box(4.92, 4.92, 0.12, (0, 0, 0.06), m=m['dark']))
    static.append(box(4.72, 4.72, 0.09, (0, 0, 0.16), m=m['iron']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            static.append(cyl_at(sx * 2.20, sy * 2.20, 0.23, 0.085, 0.08,
                                 m['steel'], verts=6))

    # --- walls: glazing between mullions, on a painted sill ---------------
    for i in range(4):
        a = math.pi * i / 2
        c, s = math.cos(a), math.sin(a)
        # sill
        static.append(box(4.78, 0.30, 0.75, (-s * 2.24, c * 2.24, 0.535),
                          rot=(0, 0, a), m=m['iron']))
        static.append(box(4.84, 0.34, 0.09, (-s * 2.24, c * 2.24, 0.955),
                          rot=(0, 0, a), m=m['frame']))
        # clerestory glazing
        static.append(box(4.40, 0.05, 0.44, (-s * 2.28, c * 2.28, 1.22),
                          rot=(0, 0, a), m=m['glass']))
        # mullions
        for k in (-1, 0, 1):
            static.append(box(0.09, 0.12, 0.46,
                              (-s * 2.28 + c * k * 1.30,
                               c * 2.28 + s * k * 1.30, 1.22),
                              rot=(0, 0, a), m=m['frame']))
        # eaves beam
        static.append(box(4.72, 0.16, 0.14, (-s * 2.28, c * 2.28, EAVE_Z - 0.07),
                          rot=(0, 0, a), m=m['frame']))

    for sx in (-1, 1):                                   # corner posts
        for sy in (-1, 1):
            static.append(box(0.20, 0.20, 1.34, (sx * 2.28, sy * 2.28, 0.83),
                              m=m['frame']))

    # --- roof: four sloped panels around an open oculus -------------------
    # Worked out from the two heights rather than eyeballed, so the panels
    # actually meet the eaves beam and the oculus frame instead of floating.
    dy = 2.28 - OCULUS
    dz = RIDGE_Z - EAVE_Z
    slope = math.atan2(dz, dy)
    plen = math.hypot(dy, dz)
    for i in range(4):
        a = math.pi * i / 2
        c, s = math.cos(a), math.sin(a)
        py, pz = (2.28 + OCULUS) / 2, (EAVE_Z + RIDGE_Z) / 2
        p = box(4.50, plen, 0.05, (-s * py, c * py, pz),
                rot=(-slope, 0, 0), m=m['glass'])
        p.rotation_euler[2] = a          # swing the tilted panel to this side
        static.append(p)
        # oculus frame
        static.append(box(3.30, 0.13, 0.11, (-s * OCULUS, c * OCULUS, RIDGE_Z),
                          rot=(0, 0, a), m=m['frame']))

    # Hip rafters along the diagonals, which is also what hides the corners
    # where two rectangular panels overlap.
    hl = math.hypot(math.hypot(dy, dy), dz)
    hs = math.atan2(dz, math.hypot(dy, dy))
    for i in range(4):
        a = math.pi / 4 + math.pi * i / 2
        mx, my = (2.28 + OCULUS) / 2, (2.28 + OCULUS) / 2
        r = box(hl, 0.11, 0.11,
                (math.cos(a) * math.hypot(mx, my), math.sin(a) * math.hypot(mx, my),
                 (EAVE_Z + RIDGE_Z) / 2),
                rot=(0, hs, a), m=m['frame'])
        static.append(r)

    # --- grow lamps under the eaves --------------------------------------
    for i in range(4):
        a = math.pi * i / 2
        c, s = math.cos(a), math.sin(a)
        for k in (-1, 0, 1):
            static.append(box(1.05, 0.09, 0.06,
                              (-s * 1.96 + c * k * 1.35,
                               c * 1.96 + s * k * 1.35, EAVE_Z - 0.22),
                              rot=(0, 0, a), m=m['grow']))

    # --- four raised beds, one conifer each -------------------------------
    for sx in (-1, 1):
        for sy in (-1, 1):
            bx, by = sx * 0.95, sy * 0.95
            static.append(box(1.56, 1.56, 0.34, (bx, by, 0.33), m=m['soil']))
            for e in range(4):                       # kerb, four edges only
                ea = math.pi * e / 2
                ec, es = math.cos(ea), math.sin(ea)
                static.append(box(1.68, 0.11, 0.13,
                                  (bx - es * 0.79, by + ec * 0.79, 0.52),
                                  rot=(0, 0, ea), m=m['frame']))
            static.append(cyl_at(bx, by, 0.63, 0.07, 0.28, m['bark'], verts=10))
            static.append(cone_at(bx, by, 0.60, 0.40, 0.10, 0.44, m['leaf']))
            static.append(cone_at(bx, by, 0.90, 0.26, 0.02, 0.36, m['leaf']))

    # --- water inlet, north side (model +Y is Factorio north) -------------
    # Slim on purpose - the game draws pipe_picture over these.
    static.append(box(0.34, 0.44, 0.40, (0, 2.05, 0.36), m=m['iron']))
    static.append(cyl_at(0, 2.30, 0.36, 0.165, 0.70, m['steel'], verts=24,
                         rot=(math.pi / 2, 0, 0)))
    static.append(cyl_at(0, 2.46, 0.36, 0.215, 0.10, m['dark'], verts=24,
                         rot=(math.pi / 2, 0, 0)))

    # --- irrigation boom (animated) ---------------------------------------
    spin.append(cyl_at(0, 0, 0.84, 0.13, 1.28, m['steel'], verts=20))
    spin.append(cyl_at(0, 0, ARM_Z + 0.02, 0.22, 0.22, m['dark'], verts=20))
    for i in range(ARMS):
        a = 2 * math.pi * i / ARMS
        spin.append(box(BOOM_R, ARM_THK, ARM_THK,
                        (math.cos(a) * BOOM_R / 2, math.sin(a) * BOOM_R / 2,
                         ARM_Z), rot=(0, 0, a), m=m['steel']))
        for r in (0.72, 1.28, 1.84):                     # sprinkler heads
            spin.append(cyl_at(math.cos(a) * r, math.sin(a) * r,
                               NOZZLE_BOTTOM + 0.08, 0.045, 0.16, m['dark'],
                               verts=8))

    return static, spin


# One arm spacing over the whole sheet: 16 unique frames, no duplicate third.
# Nine tiles of frame, because a 5x5 machine plus its sun-side shadow does not
# fit in the six the 3x3 machines use.
fr.run(build, spin_degrees=SPIN, frame_tiles=9)
