"""Item icons for the mod's own intermediates.

  blender --background --factory-startup --python parts.py -- \
          --pass tech --frames 1 --out DIR --part crusher-roll

These are not entities - they never stand on the ground - so they are
rendered with the technology pass rather than the entity one: a perspective
three-quarter view with no Y pre-stretch, which is how the base game draws a
gear wheel or a length of pipe. Reusing the map camera would give each part a
flattened top-down look that no other item icon in the game has.

One script rather than five, because a part is a handful of primitives and
five files of twenty lines each would only hide how small they are. `--part`
picks which one to build.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from mathutils import Vector                               # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             MATS, mat)

PART = fr.arg('--part', 'crusher-roll')

# Each part is modelled about a unit across. The wear shader reads object
# coordinates at a fixed scale, so a part built ten times too small comes out
# polished and a part built ten times too big comes out filthy.
#
# Build a part wherever it is natural to build it: sit_on_ground() drops the
# whole thing onto z = 0 before it is rendered, which it has to be, because
# the technology pass hides everything under the ground plane.


def crusher_roll(m):
    """The toothed roll itself - the part all three crushers are built from.

    The same shape the entity carries, kept deliberately recognisable: a
    player who has seen the machine should read this icon as one of the two
    drums turning inside it.
    """
    R, LEN, TOOTH = 0.34, 0.92, 0.055
    lie = (0, math.pi / 2, 0)
    out = [cyl_at(0, 0, 0, R, LEN, m['roll'], verts=32, rot=lie)]
    cols, rows = 10, 4
    for row in range(rows):
        x = -LEN / 2 + LEN * (row + 0.5) / rows
        for c in range(cols):
            # Stagger alternate rows, so the teeth bite in a spiral rather
            # than in rings - rings read as a thread, not as teeth.
            a = 2 * math.pi * (c + 0.5 * (row % 2)) / cols
            out.append(box(0.07, 0.085, TOOTH * 2,
                           (x, (R + TOOTH * 0.4) * math.sin(a),
                            (R + TOOTH * 0.4) * math.cos(a)),
                           rot=(a, 0, 0), m=m['tooth']))
    for sx in (-1, 1):
        out.append(cyl_at(sx * LEN / 2, 0, 0, R * 0.80, 0.05, m['steel'],
                          verts=32, rot=lie))
        out.append(cyl_at(sx * (LEN / 2 + 0.10), 0, 0, 0.09, 0.22, m['steel'],
                          verts=16, rot=lie))
    return out


def culture_column(m):
    """A glazed growing column - what the algae tank stands four of.

    Framed rather than glazed: a transparent shell at 32 px is a smudge, and
    the thing that says "there is something growing in here" is the colour of
    the culture, not the glass in front of it. Steel hoops and mullions with
    the culture showing between them read as a column at every size.
    """
    H, R = 0.94, 0.235
    out = [cyl_at(0, 0, 0, R - 0.03, H, m['culture'], verts=24)]
    for k in range(4):
        a = math.pi / 2 * k
        out.append(box(0.05, 0.05, H + 0.04,
                       (R * math.cos(a), R * math.sin(a), 0), m=m['steel']))
    for z in (-H / 2 + 0.06, 0.0, H / 2 - 0.06):
        out.append(cyl_at(0, 0, z, R + 0.025, 0.05, m['steel'], verts=24))
    out.append(cyl_at(0, 0, -H / 2 - 0.05, 0.27, 0.10, m['dark'], verts=24))
    out.append(cyl_at(0, 0, H / 2 + 0.05, 0.27, 0.10, m['steel'], verts=24))
    out.append(cyl_at(0, 0, H / 2 + 0.17, 0.05, 0.16, m['dark'], verts=12))
    return out


def grow_lamp(m):
    """The lamp over a planting bed.

    The lit tube is the whole icon, so nothing may be allowed to cover it.
    Two earlier versions failed on exactly that: a bulb tucked up inside a
    shade reads as a funnel, and a full-width reflector over the tube reads
    as a grey beam, because this camera looks down at the thing and the
    reflector is what it sees. The reflector here covers the back half only
    and the magenta faces the lens.
    """
    L = 0.92
    lie = (0, math.pi / 2, 0)
    out = [cyl_at(0, 0, 0.02, 0.125, L, m['lamp'], verts=20, rot=lie),
           box(L + 0.06, 0.26, 0.05, (0, 0.15, 0.19), m=m['case']),
           box(L + 0.06, 0.05, 0.24, (0, 0.27, 0.08), rot=(0.40, 0, 0),
               m=m['case'])]
    for sx in (-1, 1):
        out.append(box(0.05, 0.05, 0.16, (sx * L * 0.36, 0.15, 0.29),
                       m=m['dark']))
        out.append(cyl_at(sx * (L / 2 + 0.03), 0, 0.02, 0.09, 0.06, m['dark'],
                          verts=12, rot=lie))
    return out


def condenser_coil(m):
    """A finned tube - the cooling element the water condenser stands two of."""
    LEN = 1.00
    lie = (0, math.pi / 2, 0)
    out = [cyl_at(0, 0, 0, 0.09, LEN, m['copper'], verts=24, rot=lie)]
    n = 11
    for i in range(n):
        x = -LEN / 2 + LEN * (i + 0.5) / n
        out.append(cyl_at(x, 0, 0, 0.27, 0.022, m['fin'], verts=28, rot=lie))
    for sx in (-1, 1):
        out.append(cyl_at(sx * (LEN / 2 + 0.06), 0, 0, 0.10, 0.14,
                          m['steel'], verts=20, rot=lie))
        out.append(cyl_at(sx * (LEN / 2 + 0.13), 0, 0.10, 0.065, 0.22,
                          m['steel'], verts=16))
    return out


def basalt_gravel(m):
    """Crushed basalt: what comes off the first pass and feeds the second.

    Angular chips, and much darker than the vanilla stone icon. Both matter:
    stone, basalt and gravel travel the same belts, and three grey heaps of
    rounded pebbles would be three items nobody can tell apart - which is a
    complaint this mod has already had to answer once.
    """
    out = []
    chips = [(-0.27, -0.09, 0.21, 0.5, 5), (0.19, -0.21, 0.25, 1.7, 6),
             (0.29, 0.17, 0.20, 2.6, 5), (-0.15, 0.25, 0.18, 0.9, 6),
             (0.00, 0.00, 0.27, 2.1, 6), (-0.35, 0.19, 0.14, 1.3, 5),
             (0.35, -0.03, 0.13, 0.4, 5)]
    for x, y, r, a, v in chips:
        # A low-vertex double cone, not a sphere: crushed rock is flakes with
        # faces and edges, and a subdivided sphere is a pebble however much
        # it is squashed.
        bpy.ops.mesh.primitive_cone_add(vertices=v, radius1=r, radius2=r * 0.55,
                                        depth=r * 1.25,
                                        location=(x, y, r * 0.55))
        o = bpy.context.object
        o.rotation_euler = (a * 0.30, a * 0.22, a * 1.30)
        o.scale = (1.0, 0.94, 0.78)
        o.data.materials.append(m['basalt'])
        out.append(o)
    return out


def silica_crystal(m):
    """A cluster of grown crystal, the way it comes off the hearth shelf.

    Six-sided spikes, not faceted gems. A gem says treasure; a hexagonal
    prism with a broken base says something was grown and snapped off, which
    is exactly what the machine does to it.
    """
    out = []
    for x, y, r, h, tilt, turn in ((0.00, 0.00, 0.26, 1.05, 0.06, 0.0),
                                   (0.30, 0.10, 0.17, 0.68, 0.34, 1.1),
                                   (-0.22, 0.18, 0.14, 0.52, -0.40, 2.3),
                                   (0.06, -0.28, 0.12, 0.40, 0.46, 3.6)):
        o = fr.cone_at(x, y, 0.22, r, r * 0.14, h, m['crystal'], verts=6)
        o.rotation_euler = (tilt * math.cos(turn), tilt * math.sin(turn), turn)
        out.append(o)
    # The rock it grew out of, so the spikes stand on something instead of
    # hanging in the air the way a floating icon always does.
    out.append(cyl_at(0, 0, 0.15, 0.78, 0.30, m['basalt'], verts=7))
    return out


def glass(m):
    """Three cast sheets, stacked and offset.

    One sheet seen at this angle is a rhombus and reads as a plate of metal.
    Three of them with their edges showing read as sheet glass, because the
    edge is the only place glass has a colour of its own.
    """
    out = []
    for i, (dx, dy) in enumerate(((-0.20, -0.13), (0.00, 0.00), (0.19, 0.14))):
        # Enough offset that each sheet's own edge is clear of the one below
        # it. At a tenth of a sheet's width the stack fuses into one slab,
        # which is the same green rectangle the single-sheet version was.
        out.append(box(0.92, 0.66, 0.07, (dx, dy, 0.04 + i * 0.16),
                       rot=(0, 0, 0.16 * i), m=m['glass']))
    return out


def glazed_panel(m):
    """A pane in a steel frame - the wall the glasshouses are built from."""
    W, H, T, Z = 0.98, 0.74, 0.06, 0.05
    out = [box(W, H, T, (0, 0, Z), m=m['glass'])]
    for sx, sy, w, h in ((0, 1, W + 0.10, 0.09), (0, -1, W + 0.10, 0.09),
                         (1, 0, 0.09, H + 0.10), (-1, 0, 0.09, H + 0.10)):
        out.append(box(w, h, T + 0.05,
                       (sx * (W / 2 + 0.02), sy * (H / 2 + 0.02), Z),
                       m=m['frame']))
    # One mullion across the pane. A bare rectangle of glass in a frame is a
    # window; a divided one is a built panel, and the difference is what
    # keeps this from reading as the glass item with a border on it.
    out.append(box(0.07, H, T + 0.03, (0, 0, Z), m=m['frame']))
    return out


PARTS = {
    'crusher-roll': crusher_roll,
    'culture-column': culture_column,
    'grow-lamp': grow_lamp,
    'condenser-coil': condenser_coil,
    'basalt-gravel': basalt_gravel,
    'silica-crystal': silica_crystal,
    'glass': glass,
    'glazed-panel': glazed_panel,
}
assert PART in PARTS, "%s is not one of %s" % (PART, sorted(PARTS))


def sit_on_ground(objs):
    """Lift the part until its lowest point rests on z = 0.

    The technology pass stands its subject on a shadow catcher, and a shadow
    catcher stands in for the background: anything below it is simply not in
    the picture. A part authored about the origin - which is the natural way
    to build one - therefore loses everything under its own centre. The
    crusher roll was rendering as half a drum, the culture column as
    everything above its middle hoop, and the condenser coil as half-moons
    where its fins should be. None of it looked broken; it just looked like
    a small icon.

    Fixed here rather than by rewriting every coordinate in every part, so a
    part stays authored about its own centre and this remains one rule in
    one place that the next part gets for free.
    """
    bpy.context.view_layer.update()
    low = min((o.matrix_world @ Vector(c)).z
              for o in objs if o.type == 'MESH' for c in o.bound_box)
    for o in objs:
        o.location.z -= low
    bpy.context.view_layer.update()


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['case'] = mat("case", (0.235, 0.224, 0.210), 0.62, 1.0, wear=0.78)
    m['roll'] = mat("roll", (0.300, 0.290, 0.280), 0.50, 1.0, wear=0.70)
    m['tooth'] = mat("tooth", (0.430, 0.418, 0.400), 0.32, 1.0, wear=0.55)
    m['copper'] = mat("copper", (0.420, 0.180, 0.070), 0.38, 1.0, wear=0.60)
    m['fin'] = mat("fin", (0.330, 0.320, 0.300), 0.44, 1.0, wear=0.55)
    # Dark and slightly violet. Lit at a mid grey under the icon sun it
    # comes back as vanilla stone; taken all the way down it comes back
    # as coal. The tint is the same one the basalt item wears.
    m['basalt'] = mat("basalt", (0.086, 0.080, 0.098), 0.88, 0.0, wear=0.45)
    m['culture'] = mat("culture", (0.090, 0.330, 0.105), 0.42, 0.0)
    # There is no tonemapping on this view transform, so emission above
    # about 1.5 clips to white and the one thing the icon is for - the
    # colour - is the first thing lost.
    m['lamp'] = mat("lamp", (0.40, 0.06, 0.33), 0.30, 0.0,
                    emit=(1.00, 0.16, 0.80), emit_str=1.25)
    # The same amethyst the hearth grows, so the item and the machine agree.
    m['crystal'] = mat("crystal", (0.205, 0.135, 0.395), 0.18, 0.0,
                       emit=(0.40, 0.26, 0.86), emit_str=0.26)
    # Glass is the one material here that is mostly not its own colour: it
    # is what is behind it, plus a green edge. Transmission does that; a
    # pale opaque blue just gives painted tin.
    m['glass'] = mat("glass", (0.62, 0.84, 0.74), 0.04, 0.0)
    _g = m['glass'].node_tree.nodes['Principled BSDF']
    _g.inputs['Transmission Weight'].default_value = 0.92
    _g.inputs['IOR'].default_value = 1.50
    m['frame'] = mat("frame", (0.300, 0.290, 0.278), 0.42, 1.0, wear=0.62)
    objs = PARTS[PART](m)
    sit_on_ground(objs)
    return objs, []


fr.run(build, frame_tiles=3)
