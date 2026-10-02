"""Train factory - Factorio 6x12 entity, rendered at 64 px/tile.

  render_all.sh train_factory.py train-factory <scratch> 24

The camera, materials, primitives and render loop live in factorio_render.

A rail yard with a shop at the back. Facing north it reads from the back of
the sprite to the front:

  - the erecting shop, at the north end: brick walls under a sawtooth roof,
    its skylights facing east, and a big door the track runs into. The
    foundry inside glows through the door - that is what the lava is for -
    and the lava comes in through a port on each side wall;
  - the assembly bay in front of it, open to the sky: the track down the
    middle with the vehicle being built on it, and four welding robots,
    two on each side, working along its flanks;
  - parts staged at the front corners: wheelsets, and a pile of beams.

Nothing stands over the vehicle. A real erecting shop has an overhead crane
on a gantry the full length of the bay, and at this camera it would be a
bar laid across the one thing the sprite is about; the robots work from the
sides instead, and their arms are the only thing that reaches over it.

The vehicle is the recipe-tinted layer: grey in its own sheet and coloured
by the recipe in game, so the same bay builds a red locomotive, a rust cargo
wagon or a steel-blue fluid wagon. It is drawn only while the factory works,
so an idle factory has an empty track. The icon is not tinted, so there it
is a red locomotive.

FOUR facings: the lava ports are on the side walls of the shop, at the
north end only, so no facing is another one seen from behind.

Axis convention, as in magma_turbine.py: modelled +Y renders at the top of
the sprite, which is north, and Factorio counts Y southwards. The lava
ports at prototype {+-2.5, -4.5} are modelled at y = +4.5.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
from mathutils import Vector                                  # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             MATS, mat, Swing)

HALF_X, HALF_Y = 3.0, 6.0
DECK = 0.10

HALL_S, HALL_N = 3.30, 5.96
# The shop stands in from the side edges, so the lava ports have the last
# tile of each flank to stand out into. Built out to the edge, the stubs
# were buried in the brick.
HALL_HALF_X = 2.70
WALL_TOP = 1.60
ROOF_TOP = 2.30
PORT_Y, PORT_Z = 4.5, 0.45

RAIL_X = 0.50                    # half the gauge
RAIL_TOP = DECK + 0.13

# The vehicle on the track, south to north: body, then the cab.
VEH_S, CAB_S, VEH_N = -3.40, 1.55, 2.60
VEH_HALF_W = 0.64
FRAME_Z = 0.60                   # top of the underframe
BODY_TOP = 1.45

# The four robots: (x, y, phase). Two a side, staggered so the two flanks
# are not mirror images, and phased so they never all swing together.
ROBOTS = ((-1.80, -2.25, 0.00), (-1.80, 0.55, 0.50),
          (1.80, -1.05, 0.25), (1.80, 1.65, 0.75))
SWING_DEG = 24


def pipe(p1, p2, r, m, verts=20):
    """A round member from p1 to p2, at any angle."""
    d = Vector(p2) - Vector(p1)
    mid = (Vector(p1) + Vector(p2)) / 2
    rot = Vector((0, 0, 1)).rotation_difference(d).to_euler()
    return cyl_at(mid.x, mid.y, mid.z, r, d.length, m, verts=verts,
                  rot=tuple(rot))


def ball(p, r, m):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=20, ring_count=10,
                                         radius=r, location=p)
    o = bpy.context.object
    o.data.materials.append(m)
    return o


def hull(pts, m):
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
    o.data.materials.append(m)
    return o


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    # Darker than the turbine's plinth: a whole yard of slab lying flat in
    # the sun came back near white at that colour.
    m['concrete'] = mat("concrete", (0.170, 0.165, 0.158), 0.92, 0.0,
                        wear=0.50)
    m['brick'] = mat("brick", (0.300, 0.115, 0.065), 0.85, 0.0, wear=0.60)
    # Painted sheet, not bare metal: as a weathered metal the roof came back
    # speckled like granite.
    m['roof'] = mat("roof", (0.150, 0.160, 0.170), 0.60, 0.30)
    m['rib'] = mat("rib", (0.075, 0.080, 0.088), 0.60, 0.30)
    m['skylight'] = mat("skylight", (0.030, 0.050, 0.075), 0.10, 0.0)
    m['pit'] = mat("pit", (0.012, 0.012, 0.012), 0.90, 0.0)
    # The foundry inside the shop, seen through the door: dim, so a whole
    # doorway of it does not clip to a flat yellow.
    m['forge'] = mat("forge", (0.090, 0.030, 0.010), 0.75, 0.0,
                     emit=(1.00, 0.24, 0.02), emit_str=0.55)
    m['sleeper'] = mat("sleeper", (0.120, 0.090, 0.065), 0.85, 0.0,
                       wear=0.60)
    m['rail'] = mat("rail", (0.420, 0.410, 0.390), 0.28, 1.0, wear=0.40)
    m['line'] = mat("line", (0.520, 0.380, 0.040), 0.70, 0.0)
    m['wheel'] = mat("wheel", (0.160, 0.150, 0.140), 0.40, 1.0, wear=0.60)
    m['screen'] = mat("screen", (0.020, 0.080, 0.060), 0.30, 0.2,
                      emit=(0.30, 1.00, 0.60), emit_str=1.2)
    m['torch'] = mat("torch", (0.300, 0.300, 0.320), 0.30, 1.0)
    # The vehicle. Light grey in its own sheet so the recipe tint can colour
    # it; the icon is not tinted, so there it is locomotive red.
    m['paint'] = mat("paint",
                     (0.620, 0.620, 0.600) if fr.PASS == 'tint'
                     else (0.330, 0.050, 0.035),
                     0.45, 0.20)
    m['window'] = mat("window", (0.030, 0.040, 0.055), 0.10, 0.0)

    static, moving = [], []
    add = static.append

    def vehicle(o):
        """A part of the vehicle: the recipe-tinted layer."""
        fr.TINT.append(o)
        static.append(o)

    # --- the slab -----------------------------------------------------------
    add(box(5.96, 11.96, DECK, (0, 0, DECK / 2), m=m['concrete']))
    # Safety lines down both sides of the bay, out past the robots.
    for sx in (-1, 1):
        add(box(0.07, HALL_S + HALF_Y - 0.20, 0.006,
                (sx * 2.38, (HALL_S - HALF_Y) / 2, DECK + 0.003),
                m=m['line']))

    # --- the track ----------------------------------------------------------
    # Sleepers side by side down the line, then the two rails over them,
    # from the south edge into the shop door.
    ty0, ty1 = -HALF_Y + 0.05, HALL_S
    n = int((ty1 - ty0) / 0.42)
    for k in range(n):
        y = ty0 + 0.21 + 0.42 * k
        add(box(1.62, 0.18, 0.06, (0, y, DECK + 0.03), m=m['sleeper']))
    for sx in (-1, 1):
        add(box(0.08, ty1 - ty0, 0.07, (sx * RAIL_X, (ty0 + ty1) / 2,
                                        DECK + 0.095), m=m['rail']))

    # --- the vehicle (recipe-tinted) -----------------------------------------
    # Two bogies on the rails, the underframe on them, a long body with a
    # rounded roof, and the cab at the north end with its windows.
    for by in (VEH_S + 1.00, CAB_S - 0.30):
        vehicle(box(1.08, 1.30, 0.20, (0, by, RAIL_TOP + 0.20),
                    m=m['dark']))
        for wy in (by - 0.40, by + 0.40):
            for sx in (-1, 1):
                vehicle(cyl_at(sx * RAIL_X, wy, RAIL_TOP + 0.17, 0.17, 0.08,
                               m['wheel'], verts=20,
                               rot=(0, math.pi / 2, 0)))
    vehicle(box(VEH_HALF_W * 2 + 0.06, VEH_N - VEH_S, 0.14,
                (0, (VEH_S + VEH_N) / 2, FRAME_Z - 0.07), m=m['dark']))
    vehicle(box(VEH_HALF_W * 2, CAB_S - VEH_S, BODY_TOP - FRAME_Z,
                (0, (VEH_S + CAB_S) / 2, (BODY_TOP + FRAME_Z) / 2),
                m=m['paint']))
    roof = cyl_at(0, (VEH_S + CAB_S) / 2, BODY_TOP, VEH_HALF_W,
                  CAB_S - VEH_S, m['paint'], verts=32,
                  rot=(math.pi / 2, 0, 0))
    roof.scale = (1.0, 0.22 / VEH_HALF_W, 1.0)
    vehicle(roof)
    cab_top = BODY_TOP + 0.34
    vehicle(box(VEH_HALF_W * 2, VEH_N - CAB_S, cab_top - FRAME_Z,
                (0, (CAB_S + VEH_N) / 2, (cab_top + FRAME_Z) / 2),
                m=m['paint']))
    vehicle(box(VEH_HALF_W * 2 + 0.06, VEH_N - CAB_S + 0.06, 0.06,
                (0, (CAB_S + VEH_N) / 2, cab_top + 0.03), m=m['dark']))
    for sx in (-1, 1):
        vehicle(box(0.02, 0.62, 0.30,
                    (sx * (VEH_HALF_W + 0.005), (CAB_S + VEH_N) / 2,
                     cab_top - 0.26), m=m['window']))
        # Grilles down the body sides, so the long flank is not one slab.
        for k in range(5):
            y = VEH_S + 0.55 + k * 0.95
            vehicle(box(0.02, 0.55, 0.30,
                        (sx * (VEH_HALF_W + 0.005), y, BODY_TOP - 0.36),
                        m=m['dark']))
    vehicle(box(1.00, 0.02, 0.30, (0, VEH_S - 0.005, BODY_TOP - 0.30),
                m=m['window']))

    # --- the erecting shop, north end ----------------------------------------
    hy = (HALL_S + HALL_N) / 2
    hd = HALL_N - HALL_S
    add(box(HALL_HALF_X * 2, hd, WALL_TOP - DECK,
            (0, hy, (WALL_TOP + DECK) / 2), m=m['brick']))
    # Sawtooth roof: three teeth across the shop, each a slope rising to a
    # glazed face that looks east. The teeth run north-south, so their
    # zigzag is the shop's outline seen from the yard.
    tw = HALL_HALF_X * 2 / 3
    for i in range(3):
        x0 = -HALL_HALF_X + i * tw
        x1 = x0 + tw
        add(hull([(x0, HALL_S, WALL_TOP), (x0, HALL_N, WALL_TOP),
                  (x1, HALL_S, WALL_TOP), (x1, HALL_N, WALL_TOP),
                  (x1 - 0.02, HALL_S, ROOF_TOP),
                  (x1 - 0.02, HALL_N, ROOF_TOP)], m['roof']))
        # Corrugation: ribs down the slope, so the sheet reads as roofing.
        for k in range(9):
            y = HALL_S + 0.15 + (hd - 0.30) * k / 8
            add(hull([(x0, y - 0.02, WALL_TOP + 0.005),
                      (x0, y + 0.02, WALL_TOP + 0.005),
                      (x1 - 0.02, y - 0.02, ROOF_TOP + 0.005),
                      (x1 - 0.02, y + 0.02, ROOF_TOP + 0.005),
                      (x0, y, WALL_TOP + 0.03),
                      (x1 - 0.02, y, ROOF_TOP + 0.03)], m['rib']))
        add(box(0.02, hd - 0.20, ROOF_TOP - WALL_TOP - 0.14,
                (x1 + 0.005 - 0.02, hy, (ROOF_TOP + WALL_TOP) / 2 - 0.02),
                m=m['skylight']))
    # A steel band along the eaves of the front wall.
    add(box(HALL_HALF_X * 2 + 0.04, 0.10, 0.16,
            (0, HALL_S - 0.02, WALL_TOP - 0.06),
            m=m['steel']))
    # The door, with the foundry glowing at the back of the dark.
    DW, DH = 1.90, 1.36
    add(box(DW, 0.04, DH, (0, HALL_S - 0.01, DECK + DH / 2), m=m['pit']))
    add(box(DW - 0.30, 0.02, 0.30, (0, HALL_S - 0.035, DECK + DH - 0.40),
            m=m['forge']))
    for sx in (-1, 1):
        add(box(0.16, 0.14, DH + 0.06, (sx * (DW / 2 + 0.08), HALL_S - 0.04,
                                        DECK + (DH + 0.06) / 2),
                m=m['steel']))
    add(box(DW + 0.32, 0.14, 0.14, (0, HALL_S - 0.04, DECK + DH + 0.10),
            m=m['steel']))
    # Windows along the front wall either side of the door.
    for sx in (-1, 1):
        for k in range(2):
            add(box(0.46, 0.02, 0.40, (sx * (1.55 + 0.70 * k), HALL_S - 0.01,
                                       DECK + 0.95), m=m['skylight']))

    # The lava ports, one on each side wall: a short round stub out to the
    # edge tile with a flange on the end, at the height of the pipe it meets.
    for sx in (-1, 1):
        add(cyl_at(sx * 2.81, PORT_Y, PORT_Z, 0.18, 0.26, m['iron'],
                   verts=24, rot=(0, math.pi / 2, 0)))
        add(cyl_at(sx * 2.94, PORT_Y, PORT_Z, 0.26, 0.08, m['dark'],
                   verts=24, rot=(0, math.pi / 2, 0)))
        add(cyl_at(sx * (HALL_HALF_X + 0.02), PORT_Y, PORT_Z, 0.24, 0.05,
                   m['dark'], verts=24, rot=(0, math.pi / 2, 0)))

    # --- parts staged at the front corners -----------------------------------
    # Wheelsets: two wheels on an axle, two to a stack, axles across the
    # sprite so both wheels show.
    for sx in (-1, 1):
        for k, wy in enumerate((-5.35, -4.60)):
            cx = sx * 2.20
            add(cyl_at(cx, wy, DECK + 0.22, 0.035, 0.80, m['steel'],
                       verts=12, rot=(0, math.pi / 2, 0)))
            for wx in (-0.30, 0.30):
                add(cyl_at(cx + wx, wy, DECK + 0.22, 0.21, 0.07, m['wheel'],
                           verts=24, rot=(0, math.pi / 2, 0)))
    # A pile of beams on the east side, and a control desk on the west.
    for k in range(3):
        add(box(0.30, 1.30, 0.09, (2.62, -3.10, DECK + 0.05 + 0.10 * k),
                rot=(0, 0, 0.04 * (k - 1)), m=m['steel']))
    add(box(0.46, 0.70, 0.62, (-2.62, -3.20, DECK + 0.31), m=m['dark']))
    add(box(0.03, 0.46, 0.24, (-2.38, -3.20, DECK + 0.48),
            rot=(0, -0.35, 0), m=m['screen']))

    # --- the robots (animated) ------------------------------------------------
    # A pedestal on the slab, and the arm turning on it: a turret, an upper
    # arm leaning in, a forearm reaching over the vehicle's flank and a torch
    # pointed down at it. The whole arm swings about the pedestal, so the
    # torch runs along the flank, not into it.
    for rx, ry, phase in ROBOTS:
        sx = -1 if rx < 0 else 1
        add(cyl_at(rx, ry, DECK + 0.10, 0.30, 0.20, m['dark'], verts=24))
        sh = Vector((rx, ry, 0.78))
        el = Vector((rx - sx * 0.22, ry, 1.78))
        wr = Vector((sx * 0.98, ry, 1.42))
        tip = Vector((sx * 0.86, ry, 1.18))
        arm = [cyl_at(rx, ry, DECK + 0.36, 0.24, 0.32, m['yellow'],
                      verts=24),
               ball(sh, 0.15, m['yellow']),
               pipe(sh, el, 0.10, m['yellow']),
               ball(el, 0.12, m['dark']),
               pipe(el, wr, 0.075, m['yellow']),
               ball(wr, 0.08, m['dark']),
               pipe(wr, tip, 0.035, m['torch'], verts=12)]
        moving.append(Swing(arm, pivot=(rx, ry, 0.0), axis_vec=(0, 0, 1),
                            degrees=SWING_DEG, phase=phase))
    return static, moving


# Seventeen tiles of frame: twelve along the long axis, the shop's roof
# standing over two tiles high at the north end, and its shadow beyond that.
fr.run(build, frame_tiles=17)
