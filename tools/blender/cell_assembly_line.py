"""Cell Assembly Line - Factorio 3x6 entity, rendered at 64 px/tile.

  render_all.sh cell_assembly_line.py cell-assembly-line <scratch> 16

The camera, materials, primitives and render loop live in factorio_render.

A lithium-ion cell line, in the order a real one runs: the coated cathode
and anode foils come off their reels, a winder rolls them with the
separator into a jelly roll, the rolls are canned, filled with electrolyte
and closed, and the finished cells are charged for the first time on a
formation rack, which is where a cell line spends most of its floor.

Facing north it runs south to north, and reads from the back of the sprite
to the front:

  - the formation rack along the west side of the north half, its top
    shelf full of cells under charge, each with its indicator lit;
  - the cell conveyor up the east side of the north half, carrying the
    finished cells north to the rack's end;
  - the electrolyte drum on the west edge, piped low to the start of the
    conveyor, where the cans are filled;
  - the winding head in the middle, a turntable lying flat with three
    mandrels on it, turning;
  - the two foil reels at the south end side by side across X - copper
    anode on the west, aluminium cathode on the east - their webs running
    north to the winder.

Two kinds of motion: the turntable turns a third of a turn over the sheet,
which is one mandrel along, and the cells travel north on the conveyor one
pitch over the sheet (factorio_render.Travel), each taken out as it reaches
the rack's end. The formation lights are the working light: modelled dark
in the entity sheet and lit just proud of it in fr.TINT.

The port, Blender +Y being north and Factorio counting Y southwards: the
electrolyte comes in on the west edge at {-1, -0.5}.

FOUR facings: the reels, the rack and the port sit on named sides.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             torus_at, MATS, mat, Spin, Travel)

DECK_TOP = 0.21
PIPE_Z = 0.37

# --- foil reels, south end ---------------------------------------------------
REEL_Y = -2.30
REEL_Z = 0.62
REEL_R = 0.34
REEL_L = 0.46

# --- winding head --------------------------------------------------------------
WX, WY = 0.0, -0.80
WIND_R = 0.50
WIND_Z = DECK_TOP + 0.42

# --- conveyor and rack ---------------------------------------------------------
CONV_X = 0.62
CONV_Y0, CONV_Y1 = -0.10, 2.75
CONV_TOP = 0.52
PITCH = 0.30
CELL_R, CELL_H = 0.075, 0.20
RACK_X = -0.55
RACK_Y0, RACK_Y1 = 0.30, 2.85
RACK_TOP = 1.05

# --- electrolyte -------------------------------------------------------------
PORT_Y = 0.50                    # modelled north is Factorio -Y: { -1, -0.5 }
DRUM_X, DRUM_Y = -1.15, -0.35
DOSE_Y = -0.15                   # between the winder's base and the rack


def lie_x(x, y, z, r, length, material, verts=24):
    return cyl_at(x, y, z, r, length, material, verts=verts,
                  rot=(0, math.pi / 2, 0))


def lie_y(x, y, z, r, length, material, verts=24):
    return cyl_at(x, y, z, r, length, material, verts=verts,
                  rot=(math.pi / 2, 0, 0))


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.050, 0.048, 0.046), 0.80, 0.20, wear=0.55)
    # Clean-room grey-blue: a cell line runs in a dry room, and it should
    # read cleaner than the island's foundries. Kept at a mid value; a
    # white casing under this sun is a hole in the picture.
    m['casing'] = mat("casing", (0.250, 0.290, 0.340), 0.45, 0.30)
    m['belt'] = mat("belt", (0.025, 0.026, 0.030), 0.75, 0.0)
    m['copper'] = mat("copper", (0.520, 0.230, 0.080), 0.30, 1.0)
    m['alu'] = mat("alu", (0.330, 0.340, 0.360), 0.30, 1.0)
    m['separator'] = mat("separator", (0.300, 0.300, 0.290), 0.70, 0.0)
    # The cells: a blue sleeve and a bare steel top, as they come off the
    # line.
    m['sleeve'] = mat("sleeve", (0.030, 0.090, 0.260), 0.35, 0.0)
    m['cap'] = mat("cap", (0.420, 0.420, 0.430), 0.25, 1.0)
    m['led_off'] = mat("led_off", (0.020, 0.030, 0.020), 0.20, 0.0)
    # Formation lights: green, kept saturated and well under the clip.
    m['led'] = mat("led", (0.050, 0.200, 0.060), 0.30, 0.0,
                   emit=(0.30, 1.00, 0.35), emit_str=0.90)
    m['drum'] = mat("drum", (0.320, 0.120, 0.050), 0.45, 0.5, wear=0.55)
    m['screen'] = mat("screen", (0.010, 0.030, 0.035), 0.20, 0.0,
                      emit=(0.20, 0.75, 0.70), emit_str=0.35)

    static, moving = [], []
    add = static.append

    def cell(x, y, z):
        """A finished cell standing upright, as two objects."""
        return [cyl_at(x, y, z + CELL_H / 2 - 0.01, CELL_R, CELL_H - 0.02,
                       m['sleeve'], verts=16),
                cyl_at(x, y, z + CELL_H - 0.005, CELL_R * 0.92, 0.02,
                       m['cap'], verts=16)]

    # --- plinth -----------------------------------------------------------
    add(box(2.92, 5.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.76, 5.76, 0.09, (0, 0, 0.165), m=m['deck']))

    # --- foil reels -------------------------------------------------------
    # Copper anode west, aluminium cathode east, side by side across X so
    # they read as two even though they share an axis.
    for sx, foil in ((-1, m['copper']), (1, m['alu'])):
        x = sx * 0.55
        add(lie_x(x, REEL_Y, REEL_Z, REEL_R, REEL_L, foil, verts=40))
        for ex in (-1, 1):
            add(lie_x(x + ex * (REEL_L / 2 + 0.02), REEL_Y, REEL_Z,
                      REEL_R + 0.05, 0.03, m['steel'], verts=40))
        add(lie_x(x + sx * 0.03, REEL_Y, REEL_Z, 0.06, REEL_L + 0.64,
                  m['dark'], verts=12))
        # The web off the top of the reel, north to the winder, low.
        add(box(REEL_L - 0.06, WY - REEL_Y - WIND_R + 0.10, 0.01,
                (x * 0.60, (REEL_Y + WY - WIND_R) / 2 + 0.05,
                 REEL_Z + REEL_R - 0.04),
                rot=(-0.30, 0, 0), m=foil))
    # The stands.
    for x in (-1.16, 0.0, 1.16):
        add(box(0.10, 0.36, REEL_Z - DECK_TOP,
                (x, REEL_Y, (DECK_TOP + REEL_Z) / 2), m=m['casing']))

    # --- winding head -----------------------------------------------------
    add(box(1.30, 1.10, WIND_Z - DECK_TOP - 0.04,
            (WX, WY, (DECK_TOP + WIND_Z - 0.04) / 2), m=m['casing']))
    head = [cyl_at(WX, WY, WIND_Z, WIND_R, 0.06, m['steel'], verts=48)]
    for k in range(3):
        a = 2 * math.pi * k / 3
        mx, my = WX + 0.30 * math.cos(a), WY + 0.30 * math.sin(a)
        head.append(cyl_at(mx, my, WIND_Z + 0.12, 0.06, 0.20, m['dark'],
                           verts=16))
        # A jelly roll half wound on each mandrel: separator grey with a
        # copper edge showing.
        head.append(cyl_at(mx, my, WIND_Z + 0.10, 0.11 + 0.02 * k, 0.12,
                           m['separator'], verts=20))
        head.append(cyl_at(mx, my, WIND_Z + 0.165, 0.11 + 0.02 * k, 0.01,
                           m['copper'], verts=20))
    moving.append(Spin(head, pivot=(WX, WY, 0), axis='Z', degrees=120))
    # The separator film comes in from the east side, off a small spool.
    add(lie_y(1.05, WY, WIND_Z + 0.05, 0.16, 0.30, m['separator'],
              verts=24))
    add(lie_y(1.05, WY, WIND_Z + 0.05, 0.05, 0.40, m['dark'], verts=12))

    # --- cell conveyor ----------------------------------------------------
    add(box(0.30, CONV_Y1 - CONV_Y0, CONV_TOP - DECK_TOP,
            (CONV_X, (CONV_Y0 + CONV_Y1) / 2, (DECK_TOP + CONV_TOP) / 2),
            m=m['casing']))
    add(box(0.24, CONV_Y1 - CONV_Y0, 0.02,
            (CONV_X, (CONV_Y0 + CONV_Y1) / 2, CONV_TOP + 0.01), m=m['belt']))
    for sx in (-1, 1):
        add(box(0.03, CONV_Y1 - CONV_Y0, 0.06,
                (CONV_X + sx * 0.14, (CONV_Y0 + CONV_Y1) / 2,
                 CONV_TOP + 0.03), m=m['steel']))
    cells = []
    y = CONV_Y0 + 0.10
    while y <= CONV_Y1 - 0.10 + PITCH:
        cells += cell(CONV_X, y, CONV_TOP + 0.02)
        y += PITCH
    moving.append(Travel(cells, axis='Y', distance=PITCH,
                         limit=CONV_Y1 - 0.10))
    # The can-closing station at the start of the conveyor, beside the
    # belt rather than over it.
    add(box(0.30, 0.36, 0.42, (CONV_X + 0.36, CONV_Y0 + 0.30,
                                DECK_TOP + 0.21), m=m['yellow']))

    # --- formation rack ---------------------------------------------------
    rx0, rx1 = RACK_X - 0.42, RACK_X + 0.42
    for x in (rx0 + 0.03, rx1 - 0.03):
        for y in (RACK_Y0 + 0.03, (RACK_Y0 + RACK_Y1) / 2, RACK_Y1 - 0.03):
            add(box(0.05, 0.05, RACK_TOP - DECK_TOP,
                    (x, y, (DECK_TOP + RACK_TOP) / 2), m=m['casing']))
    for z in (0.55, RACK_TOP - 0.02):
        add(box(rx1 - rx0, RACK_Y1 - RACK_Y0, 0.04,
                (RACK_X, (RACK_Y0 + RACK_Y1) / 2, z), m=m['casing']))
    # Cells under charge on the top shelf, five across and eight deep, each
    # with its light beside it.
    for i in range(5):
        for j in range(8):
            x = rx0 + 0.11 + i * 0.155
            y = RACK_Y0 + 0.18 + j * 0.30
            for o in cell(x, y, RACK_TOP):
                add(o)
            add(box(0.04, 0.04, 0.012, (x + 0.08, y - 0.10, RACK_TOP + 0.026),
                    m=m['led_off']))
            lit = box(0.04, 0.04, 0.012, (x + 0.08, y - 0.10,
                                          RACK_TOP + 0.034), m=m['led'])
            fr.TINT.append(lit)
            add(lit)
    # The charging cabinet at the south end of the rack.
    add(box(0.84, 0.30, 0.80, (RACK_X, RACK_Y0 - 0.20, DECK_TOP + 0.40),
            m=m['dark']))
    add(box(0.40, 0.02, 0.18, (RACK_X - 0.12, RACK_Y0 - 0.36,
                               DECK_TOP + 0.55), m=m['screen']))

    # --- electrolyte drum and the port ------------------------------------
    add(cyl_at(DRUM_X, DRUM_Y, DECK_TOP + 0.30, 0.22, 0.60, m['drum'],
               verts=24))
    for z in (DECK_TOP + 0.10, DECK_TOP + 0.50):
        add(torus_at((DRUM_X, DRUM_Y, z), 0.225, 0.015, m['dark'],
                     segments=24))
    # The stub out of the west edge, a bend, and the run south to the drum.
    add(lie_x((-1.40 + DRUM_X) / 2, PORT_Y, PIPE_Z, 0.14, DRUM_X + 1.40,
              m['steel']))
    add(lie_x(-1.46, PORT_Y, PIPE_Z, 0.19, 0.10, m['dark']))
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.15,
                                         location=(DRUM_X, PORT_Y, PIPE_Z),
                                         segments=20, ring_count=10)
    bend = bpy.context.object
    bend.data.materials.append(m['steel'])
    add(bend)
    add(lie_y(DRUM_X, (PORT_Y + DRUM_Y + 0.20) / 2, PIPE_Z, 0.10,
              PORT_Y - DRUM_Y - 0.20, m['steel']))
    # The dosing line from the drum, low along the deck to the start of the
    # conveyor, where the cans are filled.
    add(lie_x((DRUM_X + 0.08 + CONV_X - 0.15) / 2, DOSE_Y, DECK_TOP + 0.05,
              0.035, CONV_X - 0.15 - DRUM_X - 0.08, m['steel'], verts=12))

    # --- control desk, south east -----------------------------------------
    add(box(0.40, 0.30, 0.60, (1.10, -1.75, DECK_TOP + 0.30), m=m['dark']))
    add(box(0.40, 0.02, 0.05, (1.10, -1.91, DECK_TOP + 0.52),
            m=m['yellow']))

    return static, moving


fr.run(build, frame_tiles=8)
