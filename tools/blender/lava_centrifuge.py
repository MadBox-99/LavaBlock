"""Lava centrifuge - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python lava_centrifuge.py --           --pass entity|shadow --direction north --frames 32 --out DIR

The camera, materials, primitives and render loop live in factorio_render.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl, cyl_at,    # noqa: E402
                             cone, box, ring_of, perforated_drum, MATS)

SPIN_DEGREES = 120          # three counterweight arms, 120 deg apart
BASKET_HOLES = 24           # holes round each row of the rotor basket
# The basket's pattern repeats every 360/BASKET_HOLES degrees. If the sheet
# does not turn it by a whole number of those, frame 0 and frame 32 show the
# holes in different places and the loop jumps once a revolution.
assert (SPIN_DEGREES * BASKET_HOLES) % 360 == 0, \
    "the basket hole pattern does not close over the sheet"


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    static, spin = [], []

    # --- foundation: octagonal plate + bolt ring -------------------------
    static.append(cyl(1.46, 0.10, 0.00, verts=8, m=m['dark'], name="pad"))
    static.append(cyl(1.34, 0.08, 0.10, verts=8, m=m['iron'], name="pad2"))
    static += ring_of(lambda x, y, a, z: cyl_at(x, y, z, 0.045, 0.05, m['steel'], verts=6),
                      16, 1.24, 0.20)

    # Wide plinth, narrow tall tower. With the ground unsquashed you see a lot
    # of top surface, so anything wide up high reads as a lid and hides the
    # drum - the base-game centrifuge solves this the same way.

    # --- lower vessel with a glowing heat seam ---------------------------
    static.append(cyl(1.06, 0.62, 0.18, m=m['iron'], name="body"))
    static.append(cyl(1.09, 0.06, 0.80, m=m['dark'], name="bodyRim"))
    static.append(cyl(1.07, 0.05, 0.50, m=m['hot'], name="seam"))

    # radial cooling fins
    static += ring_of(
        lambda x, y, a, z: box(0.30, 0.045, 0.46, (x * 1.08, y * 1.08, z),
                               rot=(0, 0, a), m=m['steel']),
        18, 0.95, 0.46)

    # --- drum cage: two rings + vertical bars, rotor glows between them --
    static.append(cyl(0.86, 0.07, 0.86, m=m['dark'], name="cageLo"))
    static.append(cyl(0.86, 0.08, 1.86, m=m['dark'], name="cageHi"))
    static += ring_of(
        lambda x, y, a, z: box(0.085, 0.07, 0.93, (x, y, z), rot=(0, 0, a), m=m['iron']),
        12, 0.825, 1.395)

    # --- rotor (animated) ------------------------------------------------
    # A drilled basket over the glowing core, not a ring of nine flat bars.
    # At 64 px a tile the gaps between those bars closed up and the rotor
    # read as a plain dark tube with a hot edge; through a perforated wall
    # the glow comes out as a grid of points that is unmistakably turning.
    #
    # Outer radius stays inside the static cage bars, whose inner faces sit
    # at 0.825 - 0.085/2 = 0.782.
    spin.append(cyl(0.68, 0.95, 0.90, m=m['lava'], name="rotorCore"))
    assert 0.755 + 0.005 < 0.825 - 0.085 / 2, "rotor basket fouls the cage bars"
    spin.append(perforated_drum(0, 0, 1.37, 0.755, 0.05, 0.90, m['iron'],
                                rows=6, per_row=BASKET_HOLES, hole_r=0.045,
                                name="basket"))
    spin.append(cyl(0.72, 0.05, 0.88, verts=32, m=m['iron'], name="rotorLip"))

    # --- top cap + spindle (flat, so it doesn't swallow the drum) --------
    static.append(cone(0.88, 0.60, 0.20, 1.94, m=m['steel'], name="cap"))
    static.append(cyl(0.62, 0.045, 2.14, m=m['dark'], name="capRim"))
    static += ring_of(lambda x, y, a, z: cyl_at(x, y, z, 0.038, 0.045, m['steel'], verts=6),
                      12, 0.78, 2.00)
    static.append(cyl(0.13, 0.18, 2.185, verts=16, m=m['steel'], name="spindle"))

    # --- counterweight arms (animated): makes the spin unmistakable ------
    spin.append(cyl(0.22, 0.09, 2.32, verts=24, m=m['yellow'], name="hub"))
    for i in range(3):
        a = 2 * math.pi * i / 3
        spin.append(box(0.58, 0.075, 0.06,
                        (0.32 * math.cos(a), 0.32 * math.sin(a), 2.36),
                        rot=(0, 0, a), m=m['yellow']))
        spin.append(cyl_at(0.58 * math.cos(a), 0.58 * math.sin(a), 2.28,
                           0.10, 0.20, m['steel']))

    # --- external bracing struts: base plate up to the cage rim ----------
    for i in range(3):
        a = 2 * math.pi * i / 3 + math.pi / 6
        static.append(box(0.10, 0.09, 1.36,
                          (1.10 * math.cos(a), 1.10 * math.sin(a), 0.87),
                          rot=(0, 0, a), m=m['dark']))

    # --- fluid connections: N in, E in, S out (matches fluid_boxes) ------
    # Deliberately slimmer than a vanilla pipe: the game draws its own
    # pipe_picture and pipe_covers over the connection, and a stub sized to the
    # vanilla pipe doubles up with it. These read as the machine's own ports.
    for dx, dy, hot in ((0, 1, False), (1, 0, False), (0, -1, True)):
        ang = math.atan2(dy, dx)
        axis = (math.pi / 2, 0, ang + math.pi / 2)      # lay the cylinder flat
        # housing block against the vessel, then pipe run, then end flange
        static.append(box(0.34, 0.44, 0.40, (dx * 1.05, dy * 1.05, 0.36),
                          rot=(0, 0, ang), m=m['iron']))
        static.append(cyl_at(dx * 1.30, dy * 1.30, 0.36, 0.165, 0.70, m['steel'],
                             verts=24, rot=axis))
        static.append(cyl_at(dx * 1.46, dy * 1.46, 0.36, 0.215, 0.10, m['dark'],
                             verts=24, rot=axis))
        if hot:
            static.append(cyl_at(dx * 1.34, dy * 1.34, 0.36, 0.115, 0.52, m['hot'],
                                 verts=24, rot=axis))

    return static, spin


fr.run(build, spin_degrees=SPIN_DEGREES)   # arms and basket both close
