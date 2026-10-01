"""Magma reactor - Factorio 6x6 entity, rendered at 64 px/tile.

  render_all.sh magma_reactor.py magma-reactor <scratch> 1 north

The camera, materials, primitives and render loop live in factorio_render.

A fusion reactor underneath, so two things follow from the prototype rather
than from taste. Its graphics set takes a sprite and not an animation, so
nothing on the model moves and one frame is the whole sheet. And it is
built facing north or east only; the model is the same seen from all four
sides - eight identical nozzles, two to an edge, where the connections are -
so a single picture serves both, which is how the fusion reactor is drawn
too. Which nozzles carry plasma and which carry salt is alt-mode's job.

It is a crucible, not a tokamak: a squat refractory-lined vessel with three
magnetite coil rings round its middle holding the melt off the walls, a
domed lid with the cell loader on top, and a ring of sight glasses round
its base. The olivine lining is the green band on the plinth, and the coils
are the black rings - the two crystals the reactor is built from, where a
player can see them.

The sight glasses glow only while it runs: they are modelled twice, a dark
glass in the entity sheet and the glow just proud of it in fr.TINT, which
becomes the working-light sheet.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at,         # noqa: E402
                             box, bar, torus_at, MATS, mat)

HALF = 3.0
DECK = 0.22
VESSEL_R = 1.62
VESSEL_TOP = 2.05                # where the walls end and the lid begins
NOZZLE_Z = 0.62
# The connections sit on the edge tiles at +-1.5 along each side.
NOZZLE_OFF = 1.5


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['scorch'] = mat("scorch", (0.235, 0.150, 0.085), 0.60, 1.0, wear=0.90)
    m['concrete'] = mat("concrete", (0.300, 0.292, 0.275), 0.92, 0.0,
                        wear=0.50)
    # Olivine firebrick: the green of the olivine icon, gone rough and
    # matt, as a fired brick is.
    m['olivine'] = mat("olivine", (0.095, 0.150, 0.035), 0.85, 0.0,
                       wear=0.45)
    # Magnetite, the same black with a metal sheen its icon has.
    m['magnetite'] = mat("magnetite", (0.040, 0.040, 0.045), 0.50, 0.60)
    m['copper'] = mat("copper", (0.620, 0.300, 0.110), 0.30, 1.0, wear=0.45)
    m['glass'] = mat("glass", (0.030, 0.020, 0.030), 0.12, 0.0)
    m['plasma'] = mat("plasma", (0.300, 0.030, 0.200), 0.30, 0.0,
                      emit=(1.00, 0.16, 0.68), emit_str=1.20)

    static = []
    add = static.append

    def glow(o):
        fr.TINT.append(o)
        add(o)

    # --- plinth, with the olivine lining round the vessel's foot ------------
    add(box(5.86, 5.86, DECK, (0, 0, DECK / 2), m=m['concrete']))
    add(cyl_at(0, 0, DECK + 0.10, VESSEL_R + 0.55, 0.20, m['olivine'],
               verts=8))
    add(cyl_at(0, 0, DECK + 0.24, VESSEL_R + 0.38, 0.10, m['olivine'],
               verts=8))

    # --- the vessel ------------------------------------------------------
    wall_h = VESSEL_TOP - DECK - 0.30
    add(cyl_at(0, 0, DECK + 0.30 + wall_h / 2, VESSEL_R, wall_h,
               m['scorch'], verts=48))
    for z in (DECK + 0.40, VESSEL_TOP - 0.06):
        add(torus_at((0, 0, z), VESSEL_R + 0.02, 0.06, m['iron'],
                     segments=48))
    # Three coil rings round its middle. Black magnetite cores with a band
    # of copper winding showing on each, so a ring reads as a coil and not
    # as a hoop.
    for z in (0.98, 1.28, 1.58):
        add(torus_at((0, 0, z), VESSEL_R + 0.13, 0.12, m['magnetite'],
                     segments=48))
        add(torus_at((0, 0, z), VESSEL_R + 0.24, 0.035, m['copper'],
                     segments=48))
    # The lid: a shallow dome, banded, with the cell loader on top.
    bpy.ops.mesh.primitive_uv_sphere_add(segments=48, ring_count=24,
                                         radius=VESSEL_R,
                                         location=(0, 0, VESSEL_TOP))
    lid = bpy.context.object
    # Low. At half a sphere the lid was most of the picture from 45 degrees
    # and hid the coils and every sight glass under it.
    lid.scale = (1.0, 1.0, 0.36)
    # Scorched, like the magma turbine's hot end: the two are one system,
    # and a grey lid made the reactor read as a storage tank.
    lid.data.materials.append(m['scorch'])
    add(lid)
    lid_top = VESSEL_TOP + VESSEL_R * 0.36
    add(cyl_at(0, 0, lid_top + 0.10, 0.46, 0.32, m['steel'], verts=24))
    add(cyl_at(0, 0, lid_top + 0.30, 0.54, 0.08, m['dark'], verts=24))
    add(box(0.52, 0.52, 0.34, (0, 0, lid_top + 0.50), rot=(0, 0, math.pi / 4),
            m=m['yellow']))
    add(box(0.60, 0.60, 0.06, (0, 0, lid_top + 0.70), rot=(0, 0, math.pi / 4),
            m=m['dark']))
    # Ribs down the lid, eight of them to match the nozzles.
    for k in range(8):
        a = math.pi / 8 + k * math.pi / 4
        r0, r1 = 0.50, VESSEL_R * 0.98
        add(bar((r0 * math.cos(a), r0 * math.sin(a), lid_top - 0.02),
                (r1 * math.cos(a), r1 * math.sin(a), VESSEL_TOP + 0.05),
                0.07, m['dark']))

    # --- sight glasses, and the loader's ring: the working light ------------
    # Between the top coil and the lid, which is the band of wall a camera
    # looking down at 45 degrees can see all the way round.
    for k in range(8):
        a = k * math.pi / 8 * 2 + math.pi / 8
        x, y = math.cos(a), math.sin(a)
        r = VESSEL_R + 0.005
        add(box(0.08, 0.36, 0.24, (x * r, y * r, 1.86), rot=(0, 0, a),
                m=m['iron']))
        add(box(0.04, 0.28, 0.16, (x * (r + 0.04), y * (r + 0.04), 1.86),
                rot=(0, 0, a), m=m['glass']))
        glow(box(0.03, 0.25, 0.13, (x * (r + 0.065), y * (r + 0.065), 1.86),
                 rot=(0, 0, a), m=m['plasma']))
    add(torus_at((0, 0, lid_top - 0.03), 0.64, 0.05, m['glass'], segments=32))
    glow(torus_at((0, 0, lid_top - 0.02), 0.64, 0.055, m['plasma'],
                  segments=32))

    # --- eight nozzles, two to an edge --------------------------------------
    # Each runs straight out from the vessel wall to its connection tile on
    # the edge, with a flange there. All eight alike: see the header.
    for side in range(4):
        a = side * math.pi / 2
        ux, uy = math.cos(a), math.sin(a)            # out through this edge
        vx, vy = -uy, ux                             # along it
        for off in (-NOZZLE_OFF, NOZZLE_OFF):
            px, py = vx * off, vy * off
            # Where a line out along u from (px, py) leaves the vessel wall.
            start = math.sqrt(max(VESSEL_R ** 2 - off ** 2, 0.0)) - 0.10
            p0 = (px + ux * start, py + uy * start, NOZZLE_Z)
            p1 = (px + ux * (HALF - 0.28), py + uy * (HALF - 0.28), NOZZLE_Z)
            length = HALF - 0.28 - start
            mid = ((p0[0] + p1[0]) / 2, (p0[1] + p1[1]) / 2, NOZZLE_Z)
            add(cyl_at(*mid, 0.15, length, m['iron'], verts=20,
                       rot=(math.pi / 2, 0, a + math.pi / 2)))
            add(cyl_at(p0[0] + ux * 0.10, p0[1] + uy * 0.10, NOZZLE_Z, 0.21,
                       0.10, m['dark'], verts=20,
                       rot=(math.pi / 2, 0, a + math.pi / 2)))
            fx, fy = px + ux * (HALF - 0.16), py + uy * (HALF - 0.16)
            add(cyl_at(fx, fy, NOZZLE_Z, 0.26, 0.12, m['dark'], verts=20,
                       rot=(math.pi / 2, 0, a + math.pi / 2)))
            add(box(0.40, 0.40, NOZZLE_Z - DECK,
                    (px + ux * (HALF - 0.55), py + uy * (HALF - 0.55),
                     DECK + (NOZZLE_Z - DECK) / 2), m=m['iron']))

    # --- four corner accumulators, which is where the salt waits ----------
    for sx in (-1, 1):
        for sy in (-1, 1):
            cx, cy = sx * 2.30, sy * 2.30
            add(cyl_at(cx, cy, DECK + 0.62, 0.42, 1.24, m['steel'], verts=24))
            add(cyl_at(cx, cy, DECK + 1.28, 0.46, 0.08, m['dark'], verts=24))
            bpy.ops.mesh.primitive_uv_sphere_add(segments=24, ring_count=12,
                                                 radius=0.42,
                                                 location=(cx, cy,
                                                           DECK + 1.30))
            cap = bpy.context.object
            cap.scale = (1.0, 1.0, 0.45)
            cap.data.materials.append(m['steel'])
            add(cap)

    return static, []


# Ten tiles of frame: six of footprint, the loader standing about three
# tiles high, and the sun-side shadow.
fr.run(build, frame_tiles=10)
