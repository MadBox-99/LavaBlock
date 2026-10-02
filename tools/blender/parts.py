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


def straw(m):
    """A standing sheaf, tied at the waist - what the Arboretum cuts.

    A sheaf and not a bale: a bale at this angle is a yellow box, and a box
    is the one silhouette every item icon already has. The stalks are
    straight rods twisted a third of a turn between foot and head, which is
    how a real sheaf gets its waist - lines that lean round each other
    pinch in the middle without any of them bending.

    Render it with --ground 0. It stands tall and thin on a small foot, so
    the contact shadow falls wide of it and the crop takes a grey smear
    along with the sheaf.
    """
    import random
    rnd = random.Random(7)
    H, TWIST = 1.0, math.radians(110)
    out = []

    def rod(p1, p2, r, material):
        d = Vector(p2) - Vector(p1)
        mid = (Vector(p1) + Vector(p2)) / 2
        o = cyl_at(mid.x, mid.y, mid.z, r, d.length, material, verts=5,
                   rot=(0, math.acos(d.z / d.length), math.atan2(d.y, d.x)))
        return o

    for ring_r, count in ((0.10, 7), (0.20, 13), (0.29, 18), (0.37, 24)):
        for k in range(count):
            a = 2 * math.pi * (k + rnd.random() * 0.6) / count
            rb = ring_r * (0.9 + rnd.random() * 0.2)
            rt = ring_r * (1.0 + rnd.random() * 0.25)
            top = H * (0.92 + rnd.random() * 0.14)
            p1 = (rb * math.cos(a), rb * math.sin(a), 0.0)
            p2 = (rt * math.cos(a + TWIST), rt * math.sin(a + TWIST), top)
            out.append(rod(p1, p2, 0.016, m['straw']))
            # An ear on most stalks. Without them the sheaf is a bundle of
            # sticks; the heads are what say it was grass.
            if rnd.random() < 0.7:
                bpy.ops.mesh.primitive_uv_sphere_add(segments=8, ring_count=6,
                                                     radius=0.035,
                                                     location=p2)
                o = bpy.context.object
                o.scale = (1.0, 1.0, 2.4)
                o.data.materials.append(m['ear'])
                out.append(o)
    # The waist of a twisted ring is cos(TWIST / 2) of its radius.
    waist = 0.40 * math.cos(TWIST / 2)
    for dz in (-0.035, 0.035):
        out.append(fr.torus_at((0, 0, H / 2 + dz), waist, 0.022, m['twine']))
    return out


# ------------------------------------------------ slag, crystals and lime
#
# Six crystals come out of one recipe at random, so they share belts and
# chests by the handful. Each gets its own colour AND its own silhouette -
# cube, a cluster of small octahedra, roofed prism, flat column, double
# spindle, two large octahedra - so that two of them are never told apart by
# hue alone.


def hull(pts, material, loc=(0, 0, 0), rot=(0, 0, 0)):
    """The convex hull of a point set, as one faceted solid.

    Every crystal habit here is convex, and a hull is the one construction
    that gives each a clean set of faces without authoring a face list by
    hand for every shape.
    """
    import bmesh
    bm = bmesh.new()
    for p in pts:
        bm.verts.new(p)
    bmesh.ops.convex_hull(bm, input=list(bm.verts))
    bmesh.ops.delete(bm, geom=[v for v in bm.verts if not v.link_faces],
                     context='VERTS')
    bmesh.ops.recalc_face_normals(bm, faces=list(bm.faces))
    me = bpy.data.meshes.new("hull")
    bm.to_mesh(me)
    bm.free()
    o = bpy.data.objects.new("hull", me)
    bpy.context.collection.objects.link(o)
    o.location, o.rotation_euler = loc, rot
    o.data.materials.append(material)
    return o


def ring(n, r, z, phase=0.0):
    return [(r * math.cos(2 * math.pi * k / n + phase),
             r * math.sin(2 * math.pi * k / n + phase), z) for k in range(n)]


def octa(r):
    return ring(4, r, 0.0) + [(0, 0, r), (0, 0, -r)]


def jittered(o, rnd, amount):
    """Push every vertex in or out a little, so a primitive stops being one."""
    for v in o.data.vertices:
        v.co *= 1.0 + (rnd.random() * 2 - 1) * amount
    return o


def lava_slag(m):
    """Skimmed slag, cooled in lumps.

    Rounded and brown where basalt gravel is flaked and violet-black: the two
    travel the same belts, and slag is a melt that ran and set, not a rock
    that was broken.
    """
    import random
    rnd = random.Random(11)
    out = []
    for x, y, r in ((-0.20, -0.10, 0.27), (0.20, -0.14, 0.22),
                    (0.06, 0.22, 0.25), (-0.30, 0.24, 0.15),
                    (0.34, 0.16, 0.14)):
        bpy.ops.mesh.primitive_ico_sphere_add(subdivisions=2, radius=r,
                                              location=(x, y, r * 0.7))
        o = jittered(bpy.context.object, rnd, 0.16)
        o.scale = (1.0, 0.92, 0.72)
        o.data.materials.append(m['slag'])
        out.append(o)
    return out


def pyrite(m):
    """Fool's gold: brassy cubes grown through one another."""
    out = []
    for s, loc, rot in ((0.50, (0.00, 0.00, 0.25), (0.00, 0.00, 0.30)),
                        (0.36, (0.30, 0.18, 0.30), (0.45, 0.20, 0.90)),
                        (0.30, (-0.26, 0.24, 0.26), (0.20, 0.55, -0.40))):
        out.append(box(s, s, s, loc, rot=rot, m=m['pyrite']))
    return out


def magnetite(m):
    """Magnetite, the iron oxide that crystallises out of iron-rich slag.

    A cluster of small black octahedra with a metal sheen. The diamond is an
    octahedron too, which is why this one is many and small and dark: the
    diamond is two, large and clear.
    """
    out = []
    for r, loc, rot in ((0.26, (0.00, 0.00, 0.26), (0.20, 0.30, 0.3)),
                        (0.19, (0.34, 0.10, 0.19), (0.50, 0.10, 1.0)),
                        (0.17, (-0.30, 0.16, 0.17), (0.30, 0.60, -0.5)),
                        (0.15, (0.08, -0.32, 0.15), (0.70, 0.20, 0.2)),
                        (0.13, (-0.14, 0.36, 0.13), (0.10, 0.40, 1.4)),
                        (0.12, (0.24, -0.18, 0.12), (0.40, 0.70, 0.6)),
                        (0.10, (0.04, 0.06, 0.50), (0.60, 0.30, 0.9))):
        out.append(hull(octa(r), m['magnetite'], loc=loc, rot=rot))
    return out


def olivine(m):
    """Stubby green crystals with a ridged roof, the olivine habit."""
    def roofed(w, d, h, roof):
        return [(sx * w, sy * d, z) for sx in (-1, 1) for sy in (-1, 1)
                for z in (0.0, h)] + [(sx * w * 0.55, 0.0, h + roof)
                                      for sx in (-1, 1)]
    out = []
    for w, d, h, roof, loc, rot in (
            (0.20, 0.15, 0.36, 0.16, (0.00, 0.00, 0.0), (0.0, 0.0, 0.2)),
            (0.15, 0.11, 0.24, 0.12, (0.30, 0.12, 0.0), (0.35, 0.0, 1.2)),
            (0.14, 0.10, 0.20, 0.10, (-0.28, 0.16, 0.0), (-0.30, 0.1, 2.4)),
            (0.12, 0.09, 0.16, 0.08, (0.02, -0.30, 0.0), (0.0, 0.40, 0.6))):
        out.append(hull(roofed(w, d, h, roof), m['olivine'], loc=loc, rot=rot))
    return out


def ruby(m):
    """Red corundum: flat-ended six-sided columns, not spikes.

    The flat end is what keeps it apart from the silica crystal, which is
    the same six-sided habit brought to a point.
    """
    return [cyl_at(0.00, 0.00, 0.26, 0.24, 0.52, m['ruby'], verts=6),
            cyl_at(0.30, 0.18, 0.20, 0.16, 0.40, m['ruby'], verts=6,
                   rot=(0.35, 0.25, 0.4)),
            cyl_at(-0.28, 0.20, 0.13, 0.13, 0.26, m['ruby'], verts=6,
                   rot=(0.0, 0.0, 0.3))]


def sapphire(m):
    """Blue corundum in its barrel habit: a six-sided double spindle."""
    def spindle(r, h):
        return ring(6, r, 0.0) + [(0, 0, h), (0, 0, -h)]
    return [hull(spindle(0.30, 0.62), m['sapphire'], loc=(0, 0, 0.5),
                 rot=(0.45, 0.20, 0.3)),
            hull(spindle(0.16, 0.34), m['sapphire'], loc=(0.30, 0.20, 0.2),
                 rot=(math.pi / 2, 0.0, -0.7))]


def diamond(m):
    """A raw diamond: the octahedron it grows as, before anyone cuts it."""
    # Tipped well over, so the camera sees four faces at four angles to the
    # light. Square on, an octahedron is two pale triangles and nothing else.
    return [hull(octa(0.52), m['diamond'], loc=(0, 0, 0.5),
                 rot=(0.62, 0.38, 0.45)),
            hull(octa(0.22), m['diamond'], loc=(0.40, 0.22, 0.2),
                 rot=(0.7, 0.2, 1.1))]


def crystal_assortment(m):
    """The five random crystals grown out of one lump of slag - the icon of
    the recipe that grows them and of the technology that hands it over.
    Magnetite is not on it: it has a recipe of its own.

    One specimen, not five items on a tray. The first version stood each
    crystal's own icon on a basalt slab, and it read as a shop display: five
    loose things and a plate. Rooted in the slag they grow from and leaning
    out of it, they are one thing that grew, and the slag says out of what.

    Tall at the back and short at the front, so that none of them hides
    another. The camera looks in from the +x, -y corner.
    """
    import random
    rnd = random.Random(23)
    A, B, C = 0.62, 0.50, 0.24          # the lump's half-extents
    bpy.ops.mesh.primitive_ico_sphere_add(subdivisions=3, radius=1.0)
    lump = jittered(bpy.context.object, rnd, 0.06)
    lump.scale = (A, B, C)
    lump.data.materials.append(m['slag'])
    out = [lump]

    def root(x, y, sink):
        # The top of the lump over (x, y), less `sink`, so a crystal starts
        # inside the slag instead of standing on it.
        q = max(0.0, 1.0 - (x / A) ** 2 - (y / B) ** 2)
        return (x, y, C * math.sqrt(q) - sink)

    def grown(pts, material, x, y, tilt, towards, sink=0.05):
        # Every habit below is built from z = 0 upwards, so this leans it
        # `tilt` radians towards the compass angle `towards` about its root.
        return hull(pts, material, loc=root(x, y, sink),
                    rot=(0.0, tilt, math.radians(towards)))

    def column(r, h):
        return ring(6, r, 0.0) + ring(6, r, h)

    def barrel(r, h):
        # Tapering all the way up from its widest point. A straight prism
        # with a point on it is a pencil, which is what the first try was.
        return (ring(6, r * 0.80, 0.0) + ring(6, r, h * 0.40)
                + ring(6, r * 0.45, h * 0.85, phase=0.05) + [(0, 0, h)])

    def roofed(w, d, h, roof):
        return [(sx * w, sy * d, z) for sx in (-1, 1) for sy in (-1, 1)
                for z in (0.0, h)] + [(sx * w * 0.55, 0.0, h + roof)
                                      for sx in (-1, 1)]

    # The sapphire is the tallest thing and stands at the back, the ruby
    # columns fan out to the left of it and the diamond sits to its right.
    out.append(grown(barrel(0.19, 1.00), m['sapphire'], -0.04, 0.18,
                     0.10, 110))
    for x, y, r, h, tilt, towards in ((-0.28, 0.02, 0.12, 0.70, 0.45, 165),
                                      (-0.16, 0.26, 0.10, 0.52, 0.32, 125),
                                      (-0.42, -0.10, 0.08, 0.34, 0.80, 200)):
        out.append(grown(column(r, h), m['ruby'], x, y, tilt, towards))
    out.append(hull(octa(0.23), m['diamond'], loc=root(0.30, 0.16, -0.12),
                    rot=(0.62, 0.38, 0.45)))
    # The short ones in front: olivine nearest the camera, pyrite beside it.
    for w, d, h, roof, x, y, tilt, towards in (
            (0.13, 0.10, 0.22, 0.10, 0.28, -0.20, 0.45, -50),
            (0.09, 0.07, 0.14, 0.07, 0.10, -0.32, 0.55, -95)):
        out.append(grown(roofed(w, d, h, roof), m['olivine'], x, y,
                         tilt, towards))
    for s, x, y, rot in ((0.24, -0.16, -0.24, (0.30, 0.20, 0.50)),
                         (0.15, -0.36, -0.22, (0.55, 0.10, -0.30))):
        cx, cy, cz = root(x, y, 0.0)
        out.append(box(s, s, s, (cx, cy, cz + s * 0.15), rot=rot,
                       m=m['pyrite']))
    return out


def basalt_columns(m):
    """Columnar basalt still standing in its lava - the picture of casting.

    Lava that cools slowly cracks into six-sided columns, which makes that
    the one shape that says "this rock was a melt". Stepped down towards the
    camera like a causeway, so every flat top catches the light, with the
    front of the cluster in a pool of lava that has not set yet.
    """
    import random
    rnd = random.Random(17)
    R = 0.115                           # a column's corner radius
    d = math.sqrt(3) * R * 1.05         # centre to centre, with a joint
    a1 = (d * math.cos(math.radians(30)), d * math.sin(math.radians(30)))
    a2 = (0.0, d)
    out = []
    for q in range(-2, 3):
        for r in range(-2, 3):
            if max(abs(q), abs(r), abs(q + r)) > 2:
                continue
            x = q * a1[0] + r * a2[0]
            y = q * a1[1] + r * a2[1]
            h = max(0.12, 0.42 - 0.55 * x + 0.75 * y + rnd.random() * 0.10)
            # A touch of turn and size on each, so the joints between them
            # are uneven the way a real cooling pattern's are. A perfect
            # honeycomb reads as something laid, not something that cracked.
            rr, ph = R * (0.95 + rnd.random() * 0.06), rnd.random() * 0.10
            out.append(hull(ring(6, rr, 0.0, ph) + ring(6, rr, h, ph),
                            m['basalt'], loc=(x, y, 0.0)))
    # The pool is lobed rather than round and carries a crust. A round
    # orange disc read as a plate, the columns standing on cheese.
    pool = cyl_at(0.16, -0.16, 0.015, 0.54, 0.03, m['pool'], verts=48)
    for v in pool.data.vertices:
        a = math.atan2(v.co.y, v.co.x)
        f = 1.0 + 0.14 * math.sin(3 * a + 0.7) + 0.08 * math.sin(5 * a + 2.1)
        v.co.x *= f
        v.co.y *= f
    out.append(pool)
    for x, y, s in ((0.52, -0.30, 0.10), (0.30, -0.54, 0.08),
                    (0.60, -0.02, 0.07), (0.08, -0.60, 0.06),
                    (0.44, -0.50, 0.05)):
        pts = [(x + s * math.cos(a) * (0.7 + rnd.random() * 0.5),
                y + s * math.sin(a) * (0.7 + rnd.random() * 0.5), z)
               for a in (k * 2 * math.pi / 6 for k in range(6))
               for z in (0.025, 0.045)]
        out.append(hull(pts, m['basalt']))
    return out


def crystal_circuit_board(m):
    """A sapphire board with gold traces and a ruby at its heart.

    Deep blue and gold on purpose: vanilla's three circuits are a green, a
    red and a blue board with black chips, and this must not read as a
    fourth of them.
    """
    W, T = 0.96, 0.05
    out = [box(W, W * 0.78, T, (0, 0, T / 2), m=m['board'])]
    top = T + 0.006
    for y in (-0.24, -0.08, 0.08, 0.24):
        out.append(box(0.70, 0.028, 0.012, (0.06, y, top), m=m['gold']))
    for x in (-0.30, 0.30):
        out.append(box(0.028, 0.56, 0.012, (x, 0, top), m=m['gold']))
    # Contact fingers along one edge, so it reads as a board that plugs in.
    for k in range(7):
        out.append(box(0.07, 0.06, 0.014,
                       (-0.30 + 0.10 * k, -W * 0.39 + 0.03, top), m=m['gold']))
    out.append(cyl_at(0, 0, top + 0.06, 0.13, 0.12, m['ruby'], verts=6))
    for x, y in ((-0.30, 0.22), (0.30, 0.22)):
        out.append(box(0.11, 0.11, 0.08, (x, y, top + 0.04), rot=(0, 0, 0.4),
                       m=m['pyrite']))
    return out


def limestone(m):
    """Precipitated limestone, pressed into cream blocks."""
    import random
    rnd = random.Random(5)
    out = []
    for s, loc, rot in ((0.52, (-0.12, 0.00, 0.20), (0, 0, 0.25)),
                        (0.40, (0.32, 0.12, 0.16), (0.1, 0.05, -0.5)),
                        (0.32, (0.02, 0.38, 0.13), (0, 0.1, 0.9))):
        o = box(s, s * 0.8, s * 0.7, loc, rot=rot, m=m['limestone'])
        out.append(jittered(o, rnd, 0.10))
    return out


def quicklime(m):
    """Burnt lime straight from the kiln: a heap of white lumps."""
    import random
    rnd = random.Random(3)
    out = []
    for layer, (count, rad, z) in enumerate(((9, 0.40, 0.08), (6, 0.24, 0.20),
                                             (3, 0.10, 0.32), (1, 0.0, 0.42))):
        for k in range(count):
            a = 2 * math.pi * (k + rnd.random() * 0.4) / count + layer
            r = 0.10 + rnd.random() * 0.05
            bpy.ops.mesh.primitive_ico_sphere_add(
                subdivisions=1, radius=r,
                location=(rad * math.cos(a), rad * math.sin(a), z))
            o = jittered(bpy.context.object, rnd, 0.22)
            o.data.materials.append(m['lime'])
            out.append(o)
    return out


def slaked_lime(m):
    """Slaked lime, a smooth heap of powder in a shallow pan.

    Powder where quicklime is lumps. The two are one water apart and sit
    next to each other in every build, so the pan and the smooth heap are
    what tell them apart.
    """
    out = [cyl_at(0, 0, 0.04, 0.48, 0.08, m['steel'], verts=32),
           fr.cone_at(0, 0, 0.07, 0.42, 0.03, 0.56, m['lime'], verts=40)]
    return out


def lime_mortar(m):
    """A bucket of grey mortar with the trowel still in it."""
    out = [fr.cone_at(0, 0, 0.0, 0.30, 0.38, 0.56, m['iron'], verts=32),
           fr.torus_at((0, 0, 0.56), 0.38, 0.022, m['steel']),
           cyl_at(0, 0, 0.53, 0.36, 0.04, m['paste'], verts=32)]
    # The trowel: a steel blade driven into the mortar, a wooden handle up.
    out.append(box(0.30, 0.02, 0.20, (0.08, 0.02, 0.62), rot=(0, 0.35, 0.5),
                   m=m['steel']))
    out.append(cyl_at(0.20, 0.08, 0.86, 0.035, 0.26, m['wood'], verts=10,
                      rot=(0.0, 0.35, 0.5)))
    return out


# ------------------------------------------------------------ laser line


def quartz_lens(m):
    """A cast lens in a steel ring, stood on edge.

    On edge because a lens lying flat under this camera is a pale disc, and
    a pale disc is the glass item's colour on a coin. Tipped up towards the
    lens, the ring gives it an outline and the bulge catches the light.
    """
    up = (math.radians(62), 0.0, 0.25)
    bpy.ops.mesh.primitive_uv_sphere_add(segments=40, ring_count=20,
                                         radius=0.40, location=(0, 0, 0.5),
                                         rotation=up)
    lens = bpy.context.object
    lens.scale = (1.0, 1.0, 0.26)
    lens.data.materials.append(m['quartz'])
    return [lens,
            fr.torus_at((0, 0, 0.5), 0.41, 0.045, m['steel'], rot=up),
            box(0.36, 0.26, 0.10, (0, 0.10, 0.05), m=m['dark'])]


def silicon_wafer(m):
    """A round wafer with its grid of dies, and a second one under it."""
    out = []
    for dx, dy, z in ((-0.12, 0.10, 0.02), (0.06, -0.05, 0.07)):
        out.append(cyl_at(dx, dy, z, 0.46, 0.025, m['silicon'], verts=48))
    # The dies. Set on the upper wafer only, in a grid clipped to its circle:
    # a plain disc is a coin, and the grid is what says chip.
    top = 0.07 + 0.0125 + 0.004
    for i in range(-3, 4):
        for j in range(-3, 4):
            x, y = 0.06 + i * 0.115, -0.05 + j * 0.115
            if (x - 0.06) ** 2 + (y + 0.05) ** 2 < 0.37 ** 2:
                out.append(box(0.095, 0.095, 0.008, (x, y, top),
                               m=m['die']))
    return out


def sapphire_substrate(m):
    """Three blue substrate plates standing in a rack.

    Standing, because three plates stacked flat would be the glass item
    again in blue - the glass is exactly that, three sheets on a pile.
    """
    out = [box(0.86, 0.34, 0.10, (0, 0, 0.05), m=m['steel'])]
    for k, x in enumerate((-0.26, 0.0, 0.26)):
        out.append(box(0.05, 0.62, 0.62, (x, 0.0, 0.40),
                       rot=(0, math.radians(8 * (k - 1)), 0),
                       m=m['sapphire']))
    return out


# ------------------------------------------------------------ magma line


def magma_cell(m):
    """The magma reactor's fuel: a cartridge of melt, standing on end.

    Built from what it is made of, so the icon says it: olivine-green
    refractory caps, a black magnetite coil round the middle with copper
    showing on it, a window with the melt glowing behind it, and a pyrite
    igniter on top. Standing, because lying down it is a rolling pin.

    A dark body and one wide coil. A bright steel body with two thin coils
    came out as a stack of white discs at 64 px, and the window between the
    coils was too small to find.
    """
    H, R = 0.86, 0.26
    out = [cyl_at(0, 0, H / 2, R, H, m['dark'], verts=32)]
    for z in (0.08, H - 0.08):
        out.append(cyl_at(0, 0, z, R + 0.05, 0.16, m['olivine_brick'],
                          verts=32))
    out.append(cyl_at(0, 0, 0.30, R + 0.04, 0.16, m['magnetite'], verts=32))
    for z in (0.25, 0.35):
        out.append(fr.torus_at((0, 0, z), R + 0.045, 0.012, m['copper'],
                               segments=32))
    # The window, facing the camera, above the coil.
    out.append(box(0.06, 0.24, 0.20, (R - 0.01, -0.09, 0.55),
                   rot=(0, 0, -0.35), m=m['melt']))
    out.append(cyl_at(0, 0, H + 0.04, 0.09, 0.08, m['pyrite'], verts=16))
    return out


# ------------------------------------------------------------ chip line


def cassiterite(m):
    """Tin oxide: stubby square prisms capped with low pyramids, brown-black
    and glassy.

    Square where magnetite is octahedral and brown where it is black, so the
    two dark crystals do not read as one on a belt.
    """
    def prism(w, h, cap):
        return [(sx * w, sy * w, z) for sx in (-1, 1) for sy in (-1, 1)
                for z in (0.0, h)] + [(0, 0, h + cap)]
    out = []
    for w, h, cap, loc, rot in (
            (0.15, 0.44, 0.24, (0.00, 0.00, 0.0), (0.10, 0.05, 0.30)),
            (0.11, 0.30, 0.18, (0.30, 0.10, 0.0), (0.45, 0.10, 1.00)),
            (0.10, 0.26, 0.16, (-0.28, 0.16, 0.0), (-0.40, 0.20, 2.10)),
            (0.09, 0.18, 0.13, (0.06, -0.30, 0.0), (0.20, 0.50, 0.60))):
        out.append(hull(prism(w, h, cap), m['cassiterite'], loc=loc, rot=rot))
    return out


def tin_plate(m):
    """Three plates of tin on a pile, the way vanilla draws its plates.

    Bright and a little blue next to iron's grey: tin is the whitest metal
    the player handles.
    """
    out = []
    for k, (dx, dy, a) in enumerate(((0.0, 0.0, 0.10), (0.05, -0.04, -0.12),
                                     (-0.04, 0.05, 0.28))):
        out.append(box(0.78, 0.50, 0.07, (dx, dy, 0.035 + 0.075 * k),
                       rot=(0, 0, a), m=m['tin']))
    return out


def laser_source(m):
    """The lithography machine's light source, the part it burns through.

    The same housing that stands beside the source vessel on the machine:
    graphite, with the ruby glowing through a ring of slots, and the tin
    nozzle on top. Standing, so the red ring faces the camera.
    """
    H, R = 0.82, 0.25
    out = [cyl_at(0, 0, H / 2, R, H, m['graphite'], verts=32)]
    for z in (0.06, H - 0.06):
        out.append(cyl_at(0, 0, z, R + 0.025, 0.08, m['steel'], verts=32))
    out.append(cyl_at(0, 0, 0.44, R + 0.006, 0.38, m['laser_ruby'],
                      verts=32))
    for k in range(8):
        a = 2 * math.pi * (k + 0.5) / 8
        out.append(box(0.06, 0.04, 0.40,
                       ((R + 0.012) * math.cos(a), (R + 0.012) * math.sin(a),
                        0.44), rot=(0, 0, a), m=m['steel']))
    out.append(cyl_at(0, 0, H + 0.08, 0.08, 0.16, m['tin'], verts=20))
    out.append(fr.cone_at(0, 0, H + 0.16, 0.08, 0.025, 0.08, m['tin'],
                          verts=20))
    return out


def microchip(m):
    """A black chip package with pins down all four sides and its die
    showing in the middle.

    Black epoxy and silver legs: vanilla's circuits are boards, green, red
    and blue, and this has to read as the thing that sits on one. The die
    window wears the wafer's colour, which is where the chip came from.
    """
    W, T = 0.62, 0.09
    out = [box(W, W, T, (0, 0, 0.06 + T / 2), m=m['epoxy'])]
    out.append(box(0.30, 0.30, 0.012, (0, 0, 0.06 + T + 0.004),
                   m=m['die']))
    n = 7
    for k in range(n):
        t = -W / 2 + W * (k + 0.5) / n
        for sx, sy, rot in ((0, -1, 0), (0, 1, 0), (-1, 0, 1), (1, 0, 1)):
            x = t if sx == 0 else sx * (W / 2 + 0.06)
            y = t if sy == 0 else sy * (W / 2 + 0.06)
            out.append(box(0.045, 0.14, 0.03, (x, y, 0.07),
                           rot=(0, 0, rot * math.pi / 2), m=m['pin']))
    # The pin-one dot, so the package has a way round.
    out.append(cyl_at(-W / 2 + 0.09, -W / 2 + 0.09, 0.06 + T + 0.002, 0.03,
                      0.006, m['pin'], verts=16))
    return out


PARTS = {
    'cassiterite': cassiterite,
    'tin-plate': tin_plate,
    'laser-source': laser_source,
    'microchip': microchip,
    'magma-cell': magma_cell,
    'quartz-lens': quartz_lens,
    'silicon-wafer': silicon_wafer,
    'sapphire-substrate': sapphire_substrate,
    'lava-slag': lava_slag,
    'pyrite': pyrite,
    'magnetite': magnetite,
    'olivine': olivine,
    'ruby': ruby,
    'sapphire': sapphire,
    'diamond': diamond,
    'crystal-assortment': crystal_assortment,
    'basalt-columns': basalt_columns,
    'crystal-circuit-board': crystal_circuit_board,
    'limestone': limestone,
    'quicklime': quicklime,
    'slaked-lime': slaked_lime,
    'lime-mortar': lime_mortar,
    'straw': straw,
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
    # Lava lying open, lit much lower than the machines' lava: a whole floor
    # of it at their strength clips to a flat yellow.
    m['pool'] = mat("pool", (0.090, 0.030, 0.010), 0.30, 0.0,
                    emit=(1.00, 0.22, 0.02), emit_str=1.0)
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
    # Dry gold, kept dark for the same reason as everything else here: the
    # icon sun turns a straw-coloured swatch into white.
    m['straw'] = mat("straw", (0.380, 0.260, 0.070), 0.70, 0.0)
    m['ear'] = mat("ear", (0.330, 0.200, 0.050), 0.75, 0.0)
    m['twine'] = mat("twine", (0.110, 0.055, 0.020), 0.85, 0.0)

    def gem(name, base, rough, transmission, ior, emit=None, emit_str=0.0,
            coat=0.15, specular=0.5):
        # A light coat only. Under the icon's two hard suns a full clear coat
        # lights every face up white, and a red or black crystal comes out
        # pink or grey.
        g = mat(name, base, rough, 0.0, emit=emit, emit_str=emit_str)
        b = g.node_tree.nodes['Principled BSDF']
        b.inputs['Transmission Weight'].default_value = transmission
        b.inputs['IOR'].default_value = ior
        b.inputs['Coat Weight'].default_value = coat
        b.inputs['Coat Roughness'].default_value = 0.03
        b.inputs['Specular IOR Level'].default_value = specular
        return g

    # Rust-brown and a little glassy: a melt that set, not a broken rock.
    m['slag'] = mat("slag", (0.130, 0.068, 0.034), 0.55, 0.15, wear=0.85)
    m['pyrite'] = mat("pyrite", (0.500, 0.370, 0.110), 0.26, 1.0, wear=0.30)
    m['gold'] = mat("gold", (0.620, 0.430, 0.110), 0.22, 1.0)
    # Black with a metal sheen, and rough enough that the sheen stays a sheen:
    # polished, a metal mirrors the white floor under it and comes out steel.
    m['magnetite'] = mat("magnetite", (0.040, 0.040, 0.045), 0.55, 0.60)
    m['olivine'] = gem("olivine", (0.130, 0.240, 0.020), 0.10, 0.55, 1.65)
    # Low specular on the dark gems. The technology pass stands its subject
    # on a shadow catcher, and a catcher is only invisible to the camera: in
    # a reflection it is a white floor in full sun. Every upright face of a
    # glossy crystal mirrors it, which turned the ruby pink, the sapphire
    # lavender. Seen through a clear crystal the same
    # floor does it again, so these two are opaque as well.
    # And darker, with the other two channels at nothing: under the icon
    # light the main channel clips, and whatever is left in the others is
    # what the colour turns into.
    m['ruby'] = gem("ruby", (0.150, 0.000, 0.004), 0.10, 0.0, 1.76,
                    emit=(0.70, 0.01, 0.04), emit_str=0.16,
                    coat=0.0, specular=0.10)
    m['sapphire'] = gem("sapphire", (0.000, 0.014, 0.160), 0.10, 0.0, 1.76,
                        emit=(0.05, 0.12, 0.70), emit_str=0.10,
                        coat=0.0, specular=0.12)
    m['diamond'] = gem("diamond", (0.500, 0.560, 0.640), 0.02, 0.45, 2.42,
                       emit=(0.70, 0.80, 1.00), emit_str=0.08)
    # The board's substrate is sapphire, so it wears the sapphire's blue,
    # taken darker so the gold on it is what catches the eye.
    m['board'] = mat("board", (0.018, 0.030, 0.110), 0.30, 0.0)
    # Cream, not grey. Vanilla stone is grey-brown and round; limestone has
    # to be the pale thing on the belt beside it.
    m['limestone'] = mat("limestone", (0.360, 0.320, 0.230), 0.90, 0.0,
                         wear=0.40)
    m['lime'] = mat("lime", (0.420, 0.420, 0.400), 0.95, 0.0)
    m['paste'] = mat("paste", (0.190, 0.185, 0.175), 0.80, 0.0)
    m['wood'] = mat("wood", (0.220, 0.110, 0.045), 0.70, 0.0)
    # Fused quartz: clear, with the faintest cold tint so it is not the
    # glass item's green.
    m['quartz'] = mat("quartz", (0.78, 0.84, 0.88), 0.03, 0.0)
    _q = m['quartz'].node_tree.nodes['Principled BSDF']
    _q.inputs['Transmission Weight'].default_value = 0.95
    _q.inputs['IOR'].default_value = 1.46
    # Polished silicon is a dark blue-grey mirror; the dies are a shade
    # lighter and warmer, which is the interference colour a patterned wafer
    # shows.
    m['silicon'] = mat("silicon", (0.090, 0.100, 0.150), 0.22, 0.75)
    m['die'] = mat("die", (0.240, 0.180, 0.330), 0.30, 0.60)
    m['olivine_brick'] = mat("olivine_brick", (0.095, 0.150, 0.035), 0.85,
                             0.0, wear=0.45)
    m['melt'] = mat("melt", (0.300, 0.030, 0.200), 0.30, 0.0,
                    emit=(1.00, 0.16, 0.68), emit_str=1.20)
    # Brown-black and glassy, the adamantine lustre cassiterite is known by;
    # opaque and low in specular for the same reason as the ruby.
    # The first cut at twice this and specular 0.25 came back milk-chocolate:
    # every face mirrored the white floor of the shadow catcher.
    m['cassiterite'] = gem("cassiterite", (0.034, 0.015, 0.007), 0.20, 0.0,
                           2.00, coat=0.0, specular=0.10)
    # Tin, kept under white: the icon sun blows a pale metal out.
    m['tin'] = mat("tin", (0.420, 0.430, 0.450), 0.38, 1.0)
    m['graphite'] = mat("graphite", (0.080, 0.086, 0.098), 0.48, 0.55,
                        wear=0.55)
    m['laser_ruby'] = mat("laser_ruby", (0.200, 0.004, 0.010), 0.30, 0.0,
                          emit=(1.00, 0.030, 0.050), emit_str=1.10)
    m['epoxy'] = mat("epoxy", (0.022, 0.022, 0.025), 0.55, 0.0)
    m['pin'] = mat("pin", (0.520, 0.520, 0.500), 0.25, 1.0)
    objs = PARTS[PART](m)
    sit_on_ground(objs)
    return objs, []


fr.run(build, frame_tiles=3)
