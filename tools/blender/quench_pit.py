"""Quench Pit - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python quench_pit.py -- \
          --pass entity|shadow --direction north --frames 32 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A lined shaft down to the melt. Fluid arrives through a ring main on the
deck, four nozzles drop it over the lip, and it goes into the lava the
island floats on. The machine does not process anything, so there is no
vessel and no product to show: the subject is the hole, and everything else
is there to frame it.

Two decisions follow from that, and they are the whole model.

NOTHING CROSSES THE HOLE. A rotating spray arm was the obvious way to give
the pit a moving part, and a round pit is exactly the shape that supports
one on a rim track with no centre column. It was dropped anyway: the glow is
the only thing in this sprite worth looking at, and an arm sweeping over it
dims the one feature the machine has. This repo has four separate cases of a
solid body swallowing the part that had to be seen, and this would have been
the fifth. All the motion is on the rim instead - four metering rams, a
flywheel on a corner pier, and the melt itself breathing.

THE SPIN AXIS IS Z. The machine is rotatable, and Factorio turns the model
about Z with the entity, so a wheel standing up on Y becomes edge-on facing
east. The Gas Combiner shipped with that bug; see docs/blender-renders.md.
Here the flywheel lies flat for that reason and not for a mechanical one.

Colour: black basalt with hazard yellow. Every other machine in the mod is
steel, teal, blue-grey or orange, and none of them is black - which is right
for the one building whose job is to destroy what you feed it.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, cone_at,  # noqa: E402
                             torus_at, box, ring_of, MATS, mat,
                             Spin, Slide)

# --- plan ------------------------------------------------------------------
DECK_R = 1.42                 # outer radius of the deck
PIT_R = 0.84                  # the hole
# The deck is this tall because of the shaft, not the machine: at 0.56 the
# melt sat close enough to the lip to read as a full pool, and a pool is not
# something you tip fluid into. Depth from lip to melt is DECK_H + CURB_H -
# MELT_Z, and it wants to be most of the hole's radius before the far wall
# shows enough of itself to say "this goes down".
DECK_H = 0.70
FLOOR_Z = 0.04                # bottom of the shaft
MELT_Z = 0.09
CURB_H = 0.11                 # kerb standing proud of the deck
CURB_R = 0.99

PIER = 0.47                   # corner pier, full width
PIER_XY = 1.00                # pier centres, so they sit on the deck's rim
PIER_H = 0.74

MAIN_R = 1.16                 # ring main radius
MAIN_Z = 0.70
STUB_Z = 0.34                 # inlet stubs, at pipe height
STUB_R = 0.17
EDGE = 1.50                   # the entity's own edge - stubs reach it

NOZZLES = 4
RAMS = 4
RAM_R = 1.09                  # metering rams, just outside the kerb
RAM_Z = 0.98
RAM_STROKE = 0.085

FLY_R = 0.27                  # flywheel on the south-east pier
FLY_SPOKES = 6
FLY_SPIN = 360.0 / FLY_SPOKES
FLY_Z = PIER_H + 0.07

# The melt breathes rather than sloshes. A big amplitude reads as a lift
# rather than as a surface, because the disc's edge is hidden by the kerb and
# only its brightness against the shaft wall changes.
MELT_HEAVE = 0.032


def annulus(z, r_out, r_in, h, m, verts=48):
    """A flat ring: a deck with a hole in it.

    There is no primitive for this and no way to fake it - a dark disc laid
    on a solid deck reads as a painted circle at 45 degrees, not as a hole,
    because a hole is known by its inner wall. perforated_drum does the same
    boolean for its bore, so the solver is already part of this toolkit.
    """
    bpy.ops.mesh.primitive_cylinder_add(vertices=verts, radius=r_out,
                                        depth=h, location=(0, 0, z + h / 2))
    shell = bpy.context.object
    shell.data.materials.append(m)
    bpy.ops.mesh.primitive_cylinder_add(vertices=verts, radius=r_in,
                                        depth=h + 0.02,
                                        location=(0, 0, z + h / 2))
    bore = bpy.context.object
    mod = shell.modifiers.new("bore", 'BOOLEAN')
    mod.operation = 'DIFFERENCE'
    mod.object = bore
    bpy.context.view_layer.objects.active = shell
    bpy.ops.object.modifier_apply(modifier=mod.name)
    mesh = bore.data
    bpy.data.objects.remove(bore, do_unlink=True)
    bpy.data.meshes.remove(mesh)
    return shell


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS

    # Basalt, not the palette's iron: this is a cast structure sunk into
    # cooled lava, and the mod's greys all belong to machines that are bolted
    # together out of plate.
    m['basalt'] = mat("basalt", (0.078, 0.072, 0.070), 0.88, 0.0, wear=0.55)
    # The melt. Weaker than the palette's `lava`, which is tuned for a strip
    # or a spout: here it is a disc 1.7 tiles across and the strongest thing
    # in the frame, and at 1.9 the red channel saturates over that area and
    # the whole hole goes lemon. Keep emit_str * emit.r near 1 and the colour
    # stays orange. See the emission note in docs/blender-renders.md.
    m['melt'] = mat("melt", (0.130, 0.040, 0.012), 0.72, 0.0,
                    emit=(1.00, 0.28, 0.035), emit_str=1.05)
    # Crust floating on it. No emission at all - the contrast between these
    # and the melt under them is what stops the hole reading as a flat light.
    m['crust'] = mat("crust", (0.060, 0.055, 0.056), 0.90, 0.0, wear=0.55)

    static = []
    add = static.append

    # --- deck and shaft ---------------------------------------------------
    add(annulus(0.0, DECK_R, PIT_R, DECK_H, m['basalt']))
    # Shaft floor, well below the deck so the wall has depth to show. The
    # melt sits on it rather than filling to the brim: a pit brim-full of
    # lava is a pool, and a pool is not something you tip fluid into.
    add(cyl_at(0, 0, FLOOR_Z, PIT_R - 0.01, 0.06, m['crust'], verts=48))

    # --- the kerb ---------------------------------------------------------
    # A raised lip is what makes the deck read as the edge of a drop. Flush
    # with the deck the hole looks painted on.
    add(annulus(DECK_H, CURB_R, PIT_R, CURB_H, m['steel']))

    # Hazard banding, alternate blocks. Sixteen is enough to read as stripes
    # at 64 px a tile and few enough that each block is still several pixels.
    def band(x, y, a, z):
        i = int(round(a / (2 * math.pi) * 16))
        return box(0.15, 0.075, 0.035, (x, y, z), rot=(0, 0, a),
                   m=m['yellow'] if i % 2 == 0 else m['dark'])

    static.extend(ring_of(band, 16, (CURB_R + PIT_R) / 2,
                          DECK_H + CURB_H + 0.005))

    # --- corner piers -----------------------------------------------------
    # The deck is round and the footprint is square. Without these the sprite
    # is a circle in a square hole and the machine looks smaller than the
    # three tiles it actually occupies.
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(box(PIER, PIER, PIER_H,
                    (sx * PIER_XY, sy * PIER_XY, PIER_H / 2), m=m['basalt']))
            # Steel cap, not a yellow one. A yellow slab on each pier was
            # four bright squares at the corners of the sprite, and the eye
            # went to them instead of to the hole. The hazard colour earns
            # its place as a stripe on the kerb and the flywheel rim, where
            # it is a line rather than a field.
            add(box(PIER + 0.06, PIER + 0.06, 0.055,
                    (sx * PIER_XY, sy * PIER_XY, PIER_H + 0.02),
                    m=m['steel']))
            add(box(PIER + 0.07, 0.055, 0.075,
                    (sx * PIER_XY, sy * (PIER_XY - PIER / 2 - 0.01),
                     PIER_H - 0.10), m=m['yellow']))

    # --- inlets: four stubs, a ring main, four nozzles --------------------
    for i in range(4):
        a = i * math.pi / 2
        cx, cy = math.cos(a), math.sin(a)
        # Stub, reaching the entity edge where Factorio draws the pipe.
        add(cyl_at(cx * (EDGE - 0.17), cy * (EDGE - 0.17), STUB_Z,
                   STUB_R, 0.44, m['iron'], verts=20,
                   rot=(math.pi / 2, 0, a + math.pi / 2)))
        add(torus_at((cx * (EDGE - 0.02), cy * (EDGE - 0.02), STUB_Z),
                     STUB_R + 0.035, 0.035, m['steel'],
                     rot=(math.pi / 2, 0, a + math.pi / 2)))
        # Riser from the stub up to the ring main.
        add(cyl_at(cx * MAIN_R, cy * MAIN_R, STUB_Z, 0.085,
                   MAIN_Z - STUB_Z + 0.06, m['iron'], verts=14))

    add(torus_at((0, 0, MAIN_Z), MAIN_R, 0.078, m['iron'], segments=48))

    # Nozzles on the diagonals, so they do not sit on top of the risers.
    # They overhang the lip by a hair and point down the wall - far enough in
    # to read as pouring into the pit, not so far as to hang over the glow.
    for i in range(NOZZLES):
        a = math.pi / 4 + i * math.pi / 2
        cx, cy = math.cos(a), math.sin(a)
        add(cyl_at(cx * MAIN_R, cy * MAIN_R, MAIN_Z, 0.062, 0.30,
                   m['iron'], verts=12, rot=(math.pi / 2, 0, a + math.pi / 2)))
        # The downcomer stands ON the kerb, not beside it. In the first cut
        # it ended at MAIN_Z - 0.20, which is below the top of the kerb, so
        # the kerb hid the only part that says where the fluid goes.
        noz_r = PIT_R + 0.06
        noz_z = DECK_H + CURB_H + 0.02
        add(cyl_at(cx * noz_r, cy * noz_r, noz_z, 0.062, 0.30,
                   m['iron'], verts=12))
        add(cone_at(cx * noz_r, cy * noz_r, noz_z - 0.13,
                    0.030, 0.080, 0.14, m['steel'], verts=12))

    # --- the melt ---------------------------------------------------------
    # The first cut was one orange disc with four dark spots on it, and it
    # read as a flat light with dirt on it. What a cooling melt actually
    # looks like - and what the mod's own science pack icon is built on - is
    # the opposite arrangement: dark crust over most of it, with the glow
    # coming up through the cracks between plates. So the plates are the
    # surface and the melt is what shows between them.
    melt = [cyl_at(0, 0, MELT_Z, PIT_R - 0.045, 0.05, m['melt'], verts=48)]
    # A chilled ring where the melt meets the cold shaft wall. Without it the
    # glow runs right up to the stonework and the pit has no floor, just a
    # bright circle.
    melt.append(annulus(MELT_Z + 0.042, PIT_R - 0.045, PIT_R - 0.20, 0.028,
                        m['crust'], verts=48))
    # Plates, hexagonal and at four sizes, covering roughly two thirds and
    # leaving the rest as cracks. Written out rather than randomised so the
    # sheet is reproducible; the positions are deliberately uneven, because
    # anything regular here reads as a machined grating.
    for x, y, r, rot in ((-0.26, 0.20, 0.22, 0.3), (0.24, -0.10, 0.19, 1.1),
                         (0.02, 0.44, 0.14, 2.0), (0.35, 0.30, 0.12, 0.7),
                         (-0.34, -0.22, 0.16, 1.6), (0.10, -0.40, 0.13, 2.6),
                         (-0.05, 0.05, 0.11, 0.9), (0.47, -0.30, 0.09, 1.9),
                         (-0.48, 0.02, 0.10, 2.3)):
        melt.append(cyl_at(x, y, MELT_Z + 0.045, r, 0.026, m['crust'],
                           verts=6, rot=(0, 0, rot)))

    # --- metering rams ----------------------------------------------------
    # Four short rams on the kerb, worked in opposite pairs. A ram going up
    # and down says "this machine is dosing something" in a way a wheel does
    # not, and it sits outside the hole where it costs the glow nothing.
    rams = []
    for i in range(RAMS):
        a = i * math.pi / 2 + math.pi / 4
        cx, cy = math.cos(a) * RAM_R, math.sin(a) * RAM_R
        add(cyl_at(cx, cy, RAM_Z, 0.115, 0.30, m['steel'], verts=16))
        add(torus_at((cx, cy, RAM_Z), 0.135, 0.028, m['yellow']))
        rams.append((i, cyl_at(cx, cy, RAM_Z - 0.26, 0.048, 0.30,
                               m['steel'], verts=12)))

    # --- flywheel ---------------------------------------------------------
    fx, fy = PIER_XY, -PIER_XY                  # south-east pier, near side
    add(cyl_at(fx, fy, FLY_Z - 0.06, 0.075, 0.08, m['iron'], verts=12))
    # Steel spokes inside a yellow rim. Yellow spokes on a dark disc read
    # as a six-pointed star rather than as a wheel, because the bright parts
    # were the only ones the eye joined up and they do not touch.
    fly = [cyl_at(fx, fy, FLY_Z, FLY_R, 0.035, m['dark'], verts=24),
           torus_at((fx, fy, FLY_Z + 0.03), FLY_R - 0.02, 0.032, m['yellow']),
           cyl_at(fx, fy, FLY_Z - 0.01, 0.085, 0.07, m['steel'], verts=12)]
    for k in range(FLY_SPOKES):
        a = 2 * math.pi * k / FLY_SPOKES
        fly.append(box(FLY_R * 0.92, 0.045, 0.045,
                       (fx + math.cos(a) * FLY_R * 0.46,
                        fy + math.sin(a) * FLY_R * 0.46, FLY_Z + 0.03),
                       rot=(0, 0, a), m=m['steel']))

    moving = [
        Slide(melt, axis='Z', amplitude=MELT_HEAVE),
        # Opposite pairs: phase 0 and 0.5 of a turn, so two are down while
        # two are up and the machine never looks like one part copied round.
        Slide([o for i, o in rams if i % 2 == 0], axis='Z',
              amplitude=RAM_STROKE, phase=0.0),
        Slide([o for i, o in rams if i % 2 == 1], axis='Z',
              amplitude=RAM_STROKE, phase=0.5),
        Spin(fly, pivot=(fx, fy, FLY_Z), axis='Z', degrees=FLY_SPIN),
    ]
    return static, moving


fr.run(build)
