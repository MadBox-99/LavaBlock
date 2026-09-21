"""Algae tank - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python algae_tank.py -- \
          --pass entity|shadow|tint|icon --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A sealed photobioreactor: four tall culture columns in a square, inside a
framed housing with a service gantry and a manifold over them, a circulation
pump at one corner and a dosing ram at the other.

Growing is this building's only job - the bio garden presses the harvest - so
the culture is most of what the model is, and the columns are deliberately
fat and tall. The bio garden's six slim tubes read as beads at 64 px a tile;
four columns of a tile and a half fill the silhouette, which is the point
when the thing the player wants to see is the algae.

Each column fills over the sheet and drains at the end, on its own staggered
phase, so the bank never empties all at once. The culture is rendered into
its own sheet and drawn as a working visualisation, which Factorio multiplies
by the recipe colour - so the same model shows green, blue or red depending
on what is piped in.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             bar, torus_at, MATS, mat, Spin, Slide, Grow)

# Square, not a row. Four columns in a line hide behind each other when the
# machine faces east or west - the tint sheet for those facings came out
# 33 px wide, one column's worth - and being able to see the culture is the
# whole point of this building. In a square the back pair stands clear above
# the front pair at this camera angle, from every facing.
COLUMNS = 4
COL_SPAN = 0.46
COL_POS = ((-COL_SPAN, -COL_SPAN), (COL_SPAN, -COL_SPAN),
           (COL_SPAN, COL_SPAN), (-COL_SPAN, COL_SPAN))
COL_R = 0.27                        # glass radius
COL_BASE, COL_TOP = 0.30, 1.88
CULTURE_R = COL_R - 0.045
CULTURE_BASE = COL_BASE + 0.06
CULTURE_TOP = COL_TOP - 0.10

PORTS = ((0, -1), (0, 1))
PORT_HALF_X, PORT_HALF_Y = 0.17, 0.22
for _x, _y in COL_POS:
    for _px, _py in PORTS:
        assert not (abs(_x - _px) < COL_R + PORT_HALF_X
                    and abs(_y - _py * 1.05) < COL_R + PORT_HALF_Y), \
            "culture column fouls a pipe stub"
assert 2 * COL_SPAN > 2 * COL_R + 0.10, "culture columns touch each other"

POST = 1.06                         # housing corner posts
GANTRY_Z = 2.10
assert GANTRY_Z > COL_TOP + 0.14, "gantry sits on the column heads"

PUMP_BLADES = 6
PUMP_SPIN = 360 / PUMP_BLADES
PUMP_X, PUMP_Y, PUMP_Z = -1.04, -0.96, 0.62

RAM_X, RAM_Y = 1.04, -0.96
RAM_STROKE = 0.09
RAM_BODY_TOP = 0.60
ROD_Z, ROD_LEN = 0.70, 0.42
assert ROD_Z - ROD_LEN / 2 + RAM_STROKE < RAM_BODY_TOP, "dosing ram lifts out"
for _px, _py in ((PUMP_X, PUMP_Y), (RAM_X, RAM_Y)):
    for _qx, _qy in PORTS:
        assert not (abs(_px - _qx) < 0.20 + PORT_HALF_X
                    and abs(_py - _qy * 1.05) < 0.22 + PORT_HALF_Y), \
            "corner machinery fouls a pipe stub"


def glass(name, alpha):
    """Alpha, not transmission: the sprite has to carry an alpha channel the
    game can composite, and a low alpha is what lets the culture read through
    the wall instead of disappearing behind a pale film."""
    m = mat(name, (0.105, 0.170, 0.150), 0.05, 0.0)
    m.node_tree.nodes['Principled BSDF'].inputs['Alpha'].default_value = alpha
    return m


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['glass'] = glass("glass", 0.05)
    m['frame'] = mat("frame", (0.030, 0.052, 0.034), 0.55, 0.25, wear=0.50)
    m['deck'] = mat("deck", (0.048, 0.048, 0.045), 0.80, 0.20, wear=0.55)
    m['kerb'] = mat("kerb", (0.300, 0.295, 0.278), 0.55, 0.6, wear=0.62)
    m['panel'] = mat("panel", (0.020, 0.080, 0.060), 0.30, 0.2,
                     emit=(0.30, 1.00, 0.60), emit_str=1.6)
    # The culture. Near-neutral in its own sheet, because Factorio multiplies
    # that sheet by the recipe colour and leftover hue would fight the tint -
    # a green culture would go black under the red recipe. The icon is not
    # tinted, so there it gets to be actual algae green.
    m['algae'] = mat("algae",
                     (0.760, 0.760, 0.745) if fr.PASS == 'tint'
                     else (0.095, 0.380, 0.130),
                     0.30, 0.0)

    static, spin = [], []
    add = static.append

    # --- skid base --------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(cyl_at(sx * 1.26, sy * 1.26, 0.23, 0.075, 0.08, m['steel'],
                       verts=6))
    add(box(1.78, 1.78, 0.14, (0, 0, 0.28), m=m['kerb']))       # plinth

    # --- the culture columns ----------------------------------------------
    for i, (cx, cy) in enumerate(COL_POS):
        # Glass wall. One cylinder, drawn over the culture, so the culture
        # is genuinely inside something rather than standing next to it.
        shell = cyl_at(cx, cy, (COL_BASE + COL_TOP) / 2, COL_R,
                       COL_TOP - COL_BASE, m['glass'], verts=24)
        add(shell)
        fr.CLEAR.append(shell)
        add(cyl_at(cx, cy, COL_BASE + 0.05, COL_R + 0.035, 0.12, m['frame'],
                   verts=24))
        # Slim and not black: a fat dark cap turned the four heads into four
        # heavy discs that dominated the top half of the sprite.
        add(cyl_at(cx, cy, COL_TOP - 0.03, COL_R + 0.015, 0.07, m['frame'],
                   verts=24))
        for f in (0.34, 0.68):                       # hoops on the glass
            add(torus_at((cx, cy, COL_BASE + (COL_TOP - COL_BASE) * f),
                         COL_R + 0.008, 0.020, m['frame']))
        # Sparger down the outward side, so it never stands between the
        # camera and the culture.
        sgn = 1.0 if cy > 0 else -1.0
        add(cyl_at(cx, cy + sgn * (COL_R + 0.03), (COL_BASE + COL_TOP) / 2,
                   0.026, COL_TOP - COL_BASE, m['steel'], verts=6))

        # The culture itself, and a slightly wider foam cap riding its
        # surface. Both scale together, so the cap stays on the liquid
        # wherever the level is.
        h = CULTURE_TOP - CULTURE_BASE
        col = [cyl_at(cx, cy, CULTURE_BASE + h / 2, CULTURE_R, h, m['algae'],
                      verts=24),
               cyl_at(cx, cy, CULTURE_TOP - 0.02, CULTURE_R + 0.012, 0.05,
                      m['algae'], verts=24)]
        # Into the Grow group and the tint layer, but NOT into `static`:
        # assemble() parents static objects last, which would take them back
        # off the group and quietly stop them growing.
        for o in col:
            fr.TINT.append(o)
        spin.append(Grow(col, pivot=(cx, cy, CULTURE_BASE),
                         phase=i / COLUMNS, low=0.06))

    # --- the housing round the bank ---------------------------------------
    # Four corner posts and a top frame: what makes the bank read as one
    # sealed object rather than as four loose pipes standing on a slab.
    for sx in (-POST, POST):
        for sy in (-POST, POST):
            add(box(0.09, 0.09, GANTRY_Z - 0.24,
                    (sx, sy, 0.24 + (GANTRY_Z - 0.24) / 2), m=m['frame']))
    for sy in (-POST, POST):
        add(bar((-POST, sy, GANTRY_Z - 0.06), (POST, sy, GANTRY_Z - 0.06),
                0.075, m['frame']))
    for sx in (-POST, POST):
        add(bar((sx, -POST, GANTRY_Z - 0.06), (sx, POST, GANTRY_Z - 0.06),
                0.075, m['frame']))

    # --- service gantry and the manifold over the columns ------------------
    # Behind the bank, not in front of it. -Y is towards the camera, so a
    # walkway on the near side lay straight across the culture and hid the
    # one thing this machine exists to show.
    add(box(2.00, 0.26, 0.05, (0, 0.92, GANTRY_Z), m=m['frame']))
    for px in (-0.86, -0.28, 0.30, 0.88):
        add(box(0.024, 0.024, 0.19, (px, 0.80, GANTRY_Z + 0.10),
                m=m['yellow']))
    for f in (0.19, 0.11):
        add(bar((-0.90, 0.80, GANTRY_Z + f), (0.92, 0.80, GANTRY_Z + f),
                0.016, m['yellow']))
    # Manifold: a run along each column pair, a crossover between them, and
    # a drop into every head.
    for my in (-COL_SPAN, COL_SPAN):
        add(cyl_at(0, my, GANTRY_Z - 0.22, 0.055, 2 * COL_SPAN + 0.30,
                   m['steel'], verts=10, rot=(0, math.pi / 2, 0)))
    add(cyl_at(0, 0, GANTRY_Z - 0.22, 0.05, 2 * COL_SPAN, m['steel'],
               verts=10, rot=(math.pi / 2, 0, 0)))
    for cx, cy in COL_POS:
        add(bar((cx, cy, GANTRY_Z - 0.22), (cx, cy, COL_TOP + 0.02), 0.045,
                m['steel']))

    # --- circulation pump: the one thing that obviously turns --------------
    add(box(0.40, 0.36, 0.44, (PUMP_X, PUMP_Y, 0.36), m=m['iron']))
    add(cyl_at(PUMP_X, PUMP_Y, 0.58, 0.19, 0.10, m['dark'], verts=20))
    imp = [cyl_at(PUMP_X, PUMP_Y, PUMP_Z + 0.04, 0.055, 0.08, m['dark'],
                  verts=12)]
    for i in range(PUMP_BLADES):
        a = 2 * math.pi * i / PUMP_BLADES
        b = box(0.20, 0.075, 0.020,
                (PUMP_X + 0.10 * math.cos(a), PUMP_Y + 0.10 * math.sin(a),
                 PUMP_Z + 0.04), rot=(0, 0, a), m=m['steel'])
        b.rotation_euler[1] = math.radians(22)
        imp.append(b)
    spin.append(Spin(imp, pivot=(PUMP_X, PUMP_Y, 0), degrees=PUMP_SPIN))
    add(bar((PUMP_X + 0.16, PUMP_Y, 0.52),
            (COL_POS[0][0], COL_POS[0][1] - COL_R, 0.46), 0.065, m['iron']))

    # --- dosing ram --------------------------------------------------------
    add(box(0.36, 0.32, 0.44, (RAM_X, RAM_Y, 0.36), m=m['iron']))
    add(box(0.26, 0.22, 0.07, (RAM_X, RAM_Y, RAM_BODY_TOP), m=m['dark']))
    add(box(0.20, 0.04, 0.12, (RAM_X, RAM_Y - 0.17, 0.46), m=m['panel']))
    ram = [cyl_at(RAM_X, RAM_Y, ROD_Z, 0.045, ROD_LEN, m['steel'], verts=14)]
    ram.append(cyl_at(RAM_X, RAM_Y, ROD_Z + ROD_LEN / 2 + 0.04, 0.11, 0.08,
                      m['yellow'], verts=16))
    spin.append(Slide(ram, axis='Z', amplitude=RAM_STROKE))
    add(bar((RAM_X - 0.16, RAM_Y, 0.52),
            (COL_POS[1][0], COL_POS[1][1] - COL_R, 0.46), 0.065, m['iron']))

    # --- fluid connections: water north, the strain's own solution south ---
    # Slim on purpose; the prototype leaves pipe_picture and pipe_covers off,
    # because a one-tile cover sprite cannot meet a stub that reaches past
    # that tile. See docs/blender-renders.md.
    for dx, dy in ((0, 1), (0, -1)):
        add(box(0.34, 0.44, 0.40, (dx * 1.05, dy * 1.05, 0.36), m=m['iron']))
        add(cyl_at(dx * 1.30, dy * 1.30, 0.36, 0.165, 0.70, m['steel'],
                   verts=24, rot=(math.pi / 2, 0, 0)))
        add(cyl_at(dx * 1.46, dy * 1.46, 0.36, 0.215, 0.10, m['dark'],
                   verts=24, rot=(math.pi / 2, 0, 0)))

    return static, spin


# The impeller turns by a symmetry of its own blade count, the ram closes on
# its own sine, and each column drains back to where it started, so every
# group lands on frame 0 again.
fr.run(build)
