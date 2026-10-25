"""Eddy Current Separator - Factorio 3x5 entity, rendered at 64 px/tile.

  render_all.sh eddy_current_separator.py eddy-current-separator <scratch> 16

The camera, materials, primitives and render loop live in factorio_render.

An eddy current separator, the machine every scrapyard sorts its metal
with: shredded scrap rides a belt onto a head drum with a magnet rotor
spinning inside it, and the rotor's field drives currents through every
piece of copper, aluminium and brass, which kicks them clear off the end of
the belt. Iron, plastic and stone are not thrown and drop straight down. A
splitter plate between the two catches them in two bins.

Facing north, the belt runs south to north, and it reads from the back of
the sprite to the front:

  - the far bin beyond the splitter plate, full of bright metal: the
    copper, aluminium and brass the rotor threw;
  - the near bin under the drum, dark: what fell off;
  - the head drum across the north end of the belt, its pole strips
    turning, with its motor on the east end;
  - the belt itself, carrying a scatter of mixed scrap north;
  - the feed chute over the south end of the belt, which is where the scrap
    comes in, and the control cabinet in the south west corner.

Two kinds of motion: the scrap travels north on the belt, one pitch over
the sheet (factorio_render.Travel), and the drum turns by one pole pitch.
Both ends of the belt are covered - the chute at the tail, the drum at the
head - so the lump that leaves at one end and the one that appears at the
other are not seen to pop.

The drum turns about X, a wheel facing the camera, which the guide warns
against on a four-way machine. It is a long drum lying down, not a wheel
standing up: turned east its axis runs north-south and the camera still
looks down onto its top, where the pole strips are.

No fluid ports. FOUR facings anyway, because the bins and the motor sit on
named ends.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import random                                                 # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             MATS, mat, Spin, Travel, Flipbook)

DECK_TOP = 0.21

# --- the belt --------------------------------------------------------------
BELT_W = 1.20
BELT_TOP = 0.70
TAIL_Y = -2.05
HEAD_Y = 0.80                    # the head drum's axis
DRUM_R = 0.28
DRUM_Z = BELT_TOP - DRUM_R
DRUM_L = 1.50                     # longer than the belt, so its ends show
POLES = 8                        # pole strips round the drum
PITCH = 0.80                     # spacing of the scrap pattern on the belt
STREAMS = 4                      # pieces in the air at once, metal
DROPS = 2                        # and falling, rubbish

# --- beyond the head -------------------------------------------------------
SPLIT_Y = 1.62                   # the splitter plate
FAR_Y = 2.06                     # where the thrown metal lands
BIN_TOP = 0.50


def lie_x(x, y, z, r, length, material, verts=24):
    return cyl_at(x, y, z, r, length, material, verts=verts,
                  rot=(0, math.pi / 2, 0))


def open_bin(x0, x1, y0, y1, top, material, wall=0.04):
    """Four walls and a floor, open at the top."""
    out = [box(x1 - x0, y1 - y0, 0.04, ((x0 + x1) / 2, (y0 + y1) / 2,
                                        DECK_TOP + 0.02), m=material)]
    h = top - DECK_TOP
    zc = DECK_TOP + h / 2
    out.append(box(x1 - x0, wall, h, ((x0 + x1) / 2, y0 + wall / 2, zc),
                   m=material))
    out.append(box(x1 - x0, wall, h, ((x0 + x1) / 2, y1 - wall / 2, zc),
                   m=material))
    out.append(box(wall, y1 - y0, h, (x0 + wall / 2, (y0 + y1) / 2, zc),
                   m=material))
    out.append(box(wall, y1 - y0, h, (x1 - wall / 2, (y0 + y1) / 2, zc),
                   m=material))
    return out


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.050, 0.048, 0.046), 0.80, 0.20, wear=0.55)
    # Fulgora's teal on the frame, so the machine sits with the planet's
    # own buildings and apart from the island's greys and ochres.
    m['frame'] = mat("frame", (0.040, 0.150, 0.170), 0.48, 0.70, wear=0.70)
    m['rubber'] = mat("rubber", (0.022, 0.022, 0.024), 0.80, 0.0)
    # The drum shell is stainless, which the rotor's field passes through;
    # the pole strips are what show it turning.
    m['shell'] = mat("shell", (0.420, 0.420, 0.430), 0.30, 1.0)
    m['pole'] = mat("pole", (0.050, 0.055, 0.070), 0.40, 0.6)
    m['screen'] = mat("screen", (0.010, 0.030, 0.035), 0.20, 0.0,
                      emit=(0.20, 0.75, 0.70), emit_str=0.35)
    # The scrap, in the colours that tell the metals apart.
    # Darker in the swatch than they read: the sun takes a small bright
    # metal face to white, and three white specks are not three metals.
    m['copper'] = mat("copper", (0.480, 0.200, 0.070), 0.40, 1.0)
    m['alu'] = mat("alu", (0.220, 0.228, 0.245), 0.45, 1.0)
    m['brass'] = mat("brass", (0.420, 0.300, 0.080), 0.40, 1.0)
    m['rust'] = mat("rust", (0.180, 0.090, 0.050), 0.80, 0.4)
    m['pcb'] = mat("pcb", (0.030, 0.200, 0.070), 0.50, 0.0)
    metals = [m['copper'], m['alu'], m['brass']]
    rubbish = [m['rust'], m['pcb'], m['dark']]

    rnd = random.Random(11)

    def lump(x, y, z, size, material):
        return box(size, size * rnd.uniform(0.6, 1.2), size * 0.55,
                   (x, y, z), rot=(rnd.uniform(-0.3, 0.3),
                                   rnd.uniform(-0.3, 0.3),
                                   rnd.uniform(0, math.pi)),
                   m=material)

    static, moving = [], []
    add = static.append

    # --- plinth -----------------------------------------------------------
    add(box(2.92, 4.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.76, 4.76, 0.09, (0, 0, 0.165), m=m['deck']))

    # --- frame ------------------------------------------------------------
    for sx in (-1, 1):
        x = sx * (BELT_W / 2 + 0.10)
        add(box(0.12, HEAD_Y - TAIL_Y + 0.20, 0.17,
                (x, (TAIL_Y + HEAD_Y) / 2, BELT_TOP - 0.10), m=m['frame']))
        for y in (TAIL_Y + 0.15, -0.45, HEAD_Y - 0.10):
            add(box(0.10, 0.10, BELT_TOP - 0.18 - DECK_TOP,
                    (x, y, (DECK_TOP + BELT_TOP - 0.18) / 2), m=m['frame']))
        # Bearing blocks for the two drums.
        for y, z in ((TAIL_Y, BELT_TOP - 0.10), (HEAD_Y, DRUM_Z)):
            add(box(0.16, 0.22, 0.20, (sx * (DRUM_L / 2 + 0.05), y, z),
                    m=m['dark']))

    # --- the belt ---------------------------------------------------------
    add(box(BELT_W, HEAD_Y - TAIL_Y, 0.04,
            (0, (TAIL_Y + HEAD_Y) / 2, BELT_TOP - 0.02), m=m['rubber']))
    add(lie_x(0, TAIL_Y, BELT_TOP - 0.10, 0.10, BELT_W + 0.06,
              m['rubber']))

    # --- the head drum ----------------------------------------------------
    drum = [lie_x(0, HEAD_Y, DRUM_Z, DRUM_R, DRUM_L, m['shell'], verts=48)]
    for k in range(POLES):
        a = 2 * math.pi * k / POLES
        drum.append(box(DRUM_L - 0.06, 0.07, 0.02,
                        (0, HEAD_Y + (DRUM_R + 0.005) * math.cos(a),
                         DRUM_Z + (DRUM_R + 0.005) * math.sin(a)),
                        rot=(a + math.pi / 2, 0, 0), m=m['pole']))
    moving.append(Spin(drum, pivot=(0, HEAD_Y, DRUM_Z), axis='X',
                       degrees=360 / POLES))
    # The motor on the east end, coupled straight to the drum.
    add(lie_x(DRUM_L / 2 + 0.30, HEAD_Y, DRUM_Z, 0.17, 0.32, m['iron']))
    add(lie_x(DRUM_L / 2 + 0.48, HEAD_Y, DRUM_Z, 0.12, 0.04, m['dark']))
    add(lie_x(DRUM_L / 2 + 0.11, HEAD_Y, DRUM_Z, 0.06, 0.10, m['steel'],
              verts=12))

    # --- the scrap on the belt ---------------------------------------------
    # A pattern repeated every PITCH, carried one PITCH north over the sheet.
    # It starts under the chute and is laid on one pitch past the top of
    # the drum; Travel takes each lump out as it passes the top, which is
    # where the rotor throws it.
    cargo = []
    pattern = []
    for i in range(9):
        pool = metals if i % 2 == 0 else rubbish
        pattern.append((rnd.uniform(-0.48, 0.48), PITCH * (i + rnd.uniform(0.1, 0.9)) / 9,
                        rnd.uniform(0.07, 0.12), rnd.choice(pool)))
    y = TAIL_Y + 0.12
    while y <= HEAD_Y + PITCH:
        for px, py, size, mm in pattern:
            cargo.append(lump(px, y + py, BELT_TOP + size * 0.25, size, mm))
        y += PITCH
    moving.append(Travel(cargo, axis='Y', distance=PITCH, limit=HEAD_Y))


    # --- the throw ----------------------------------------------------------
    # The metal leaves the top of the drum in an arc over the splitter and
    # lands in the far bin; the rest drops off the front of the drum into the
    # near bin. Each piece is on its own curve, so this is a Flipbook: the
    # pieces in the air on each frame, STREAMS of them a quarter of a flight
    # apart, so on the next frame each has moved on by 1/FRAMES of a quarter
    # and the last frame leads back into the first.
    frames = fr.FRAMES
    y0, z0 = HEAD_Y + 0.08, BELT_TOP + 0.04
    y1, z1 = FAR_Y, BIN_TOP - 0.02
    peak = 0.42                  # how far over the start the arc rises

    def arc(t):
        # A parabola through both ends, rising `peak` over the line between
        # them at its middle.
        return (y0 + (y1 - y0) * t,
                z0 + (z1 - z0) * t + 4 * peak * t * (1 - t))

    flight = []
    for f in range(frames):
        objs = []
        for j in range(STREAMS):
            t = (j + f / frames) / STREAMS
            y, z = arc(t)
            objs.append(lump(-0.30 + 0.20 * j, y, z, 0.09,
                             metals[j % len(metals)]))
        for j in range(DROPS):
            t = (j + f / frames) / DROPS
            objs.append(lump(-0.15 + 0.35 * j, HEAD_Y + DRUM_R + 0.06,
                             BELT_TOP - 0.10 - (BELT_TOP - BIN_TOP) * t,
                             0.09, rubbish[j % len(rubbish)]))
        flight.append(objs)
    moving.append(Flipbook(flight))

    # --- feed chute over the tail -----------------------------------------
    # Sloping down onto the belt from the south edge. Low, and only over
    # the first stretch of belt, which is where the scrap lands anyway.
    add(box(1.00, 0.70, 0.04, (0, TAIL_Y - 0.12, BELT_TOP + 0.24),
            rot=(-0.40, 0, 0), m=m['frame']))
    for sx in (-1, 1):
        add(box(0.04, 0.70, 0.22, (sx * 0.50, TAIL_Y - 0.12,
                                   BELT_TOP + 0.30),
                rot=(-0.40, 0, 0), m=m['frame']))
    for sx in (-1, 1):
        add(box(0.08, 0.08, BELT_TOP + 0.30 - DECK_TOP,
                (sx * 0.46, TAIL_Y - 0.42, (DECK_TOP + BELT_TOP + 0.30) / 2),
                m=m['dark']))
    for k in range(3):
        add(lump(-0.25 + 0.25 * k, TAIL_Y - 0.25, BELT_TOP + 0.36, 0.10,
                 (metals + rubbish)[k * 2]))

    # --- the two bins and the splitter ------------------------------------
    near = open_bin(-0.62, 0.62, HEAD_Y + 0.20, SPLIT_Y - 0.03, BIN_TOP,
                    m['iron'])
    far = open_bin(-0.62, 0.62, SPLIT_Y + 0.03, 2.38, BIN_TOP, m['iron'])
    for o in near + far:
        add(o)
    # The splitter plate: a knife edge standing higher than the bins, set
    # where the thrown metal clears it and the rest does not.
    add(box(1.24, 0.03, 0.66 - DECK_TOP, (0, SPLIT_Y, (DECK_TOP + 0.66) / 2),
            m=m['frame']))
    # What each bin has caught: bright metal beyond the plate, dark rubbish
    # under the drum.
    for k in range(14):
        add(lump(rnd.uniform(-0.48, 0.48), rnd.uniform(SPLIT_Y + 0.12, 2.26),
                 BIN_TOP - 0.10 + rnd.uniform(0, 0.06), rnd.uniform(0.08, 0.13),
                 rnd.choice(metals)))
    for k in range(9):
        add(lump(rnd.uniform(-0.48, 0.48), rnd.uniform(HEAD_Y + 0.32, SPLIT_Y - 0.12),
                 BIN_TOP - 0.14 + rnd.uniform(0, 0.05), rnd.uniform(0.08, 0.12),
                 rnd.choice(rubbish)))

    # --- control cabinet, south west --------------------------------------
    kx, ky = -1.05, -2.05
    add(box(0.50, 0.40, 0.70, (kx, ky, DECK_TOP + 0.35), m=m['dark']))
    add(box(0.50, 0.02, 0.06, (kx, ky - 0.21, DECK_TOP + 0.62),
            m=m['yellow']))
    add(box(0.28, 0.02, 0.16, (kx - 0.05, ky - 0.21, DECK_TOP + 0.42),
            m=m['screen']))
    return static, moving


fr.run(build, frame_tiles=7)
