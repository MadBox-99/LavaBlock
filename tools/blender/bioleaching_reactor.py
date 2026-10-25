"""Bioleaching Reactor - Factorio 5x5 entity, rendered at 64 px/tile.

  render_all.sh bioleaching_reactor.py bioleaching-reactor <scratch> 16

The camera, materials, primitives and render loop live in factorio_render.

A bioleaching plant of the BIOX kind: open stirred tanks in which bacteria
that live on sulfur and iron eat the sulfide ore out from round the metal,
blown with air from below so they can breathe. Two tanks in cascade, the
slurry overflowing from the first into the second.

Nothing stands over the tanks. Real ones often hang their agitator from a
bridge across the top, and a bridge over the working part is the one thing
the models in this mod never carry, so these are stirred by side-entry
mixers through the tank wall, which real tanks also use.

Facing north it reads from the back of the sprite to the front:

  - the inoculation vessel between the tanks at the back, its sight glass
    green with the culture, piped to the rim of each tank;
  - the two tanks side by side across X (docs/blender-renders.md, "Depth
    separates badly"), the launder between their rims, and a side-entry
    mixer low on the back of each, in the outer corner;
  - the aeration blower at the front, its fan lying flat, with an air
    header to the foot of each tank;
  - the water feed coming in on the west flank and the acid leaving on the
    east, and the control cabinet in the front left corner.

The liquor is the recipe-tinted sheet, as the bio garden's pulp is: a
lobed surface and its froth turning by one lobe over the sheet, near-grey
in the tint pass so the recipe supplies the colour - green for nickel,
pale for zinc, rust red for the pyrite's iron. An idle reactor shows the
dark settled slurry under it. The two tanks turn opposite ways.

The ports, Blender +Y being north and Factorio counting Y southwards: the
water in on the west flank at {-2, 1}, the acid out on the east at {2, 1}.

FOUR facings: the ports and the blower sit on named sides.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from mathutils import Vector                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             torus_at, MATS, mat, Spin)

DECK_TOP = 0.21
PIPE_Z = 0.37

# --- the tanks -------------------------------------------------------------
TANK_X = 1.15                    # each tank's centre, either side
TANK_Y = 0.40
TANK_R = 1.00
WALL = 0.08
TANK_TOP = 1.20
LIQ = 0.82                       # the liquor, well down from the rim
LOBES = 6

# --- the inoculation vessel -----------------------------------------------
CUL_X, CUL_Y = 0.0, 1.85
CUL_R = 0.30
CUL_TOP = 1.55

# --- the blower ------------------------------------------------------------
BX, BY = 0.0, -1.55
BW, BD, BH = 0.90, 0.60, 0.45
FAN_R = 0.25
FAN_Z = DECK_TOP + BH + 0.08


def lie_x(x, y, z, r, length, material, verts=24):
    return cyl_at(x, y, z, r, length, material, verts=verts,
                  rot=(0, math.pi / 2, 0))


def lie_y(x, y, z, r, length, material, verts=24):
    return cyl_at(x, y, z, r, length, material, verts=verts,
                  rot=(math.pi / 2, 0, 0))


def ball(x, y, z, r, material):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=r, location=(x, y, z),
                                         segments=20, ring_count=10)
    o = bpy.context.object
    o.data.materials.append(material)
    return o


def tube(p1, p2, r, material, verts=12):
    """A round pipe between two points."""
    d = [b - a for a, b in zip(p1, p2)]
    length = math.sqrt(sum(c * c for c in d))
    mid = [(a + b) / 2 for a, b in zip(p1, p2)]
    bpy.ops.mesh.primitive_cylinder_add(vertices=verts, radius=r,
                                        depth=length, location=mid)
    o = bpy.context.object
    o.rotation_mode = 'QUATERNION'
    o.rotation_quaternion = Vector(d).to_track_quat('Z', 'Y')
    o.data.materials.append(material)
    return o


def shell(x, y, z0, z1, r_out, r_in, material, verts=56):
    """An open-topped tank wall: a cylinder with its bore cut out."""
    o = cyl_at(x, y, (z0 + z1) / 2, r_out, z1 - z0, material, verts=verts)
    cutter = cyl_at(x, y, (z0 + z1) / 2 + 0.05, r_in, z1 - z0 + 0.12,
                    material, verts=verts)
    mod = o.modifiers.new("bore", 'BOOLEAN')
    mod.operation = 'DIFFERENCE'
    mod.object = cutter
    bpy.context.view_layer.objects.active = o
    bpy.ops.object.modifier_apply(modifier=mod.name)
    mesh = cutter.data
    bpy.data.objects.remove(cutter, do_unlink=True)
    bpy.data.meshes.remove(mesh)
    return o


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.050, 0.048, 0.046), 0.80, 0.20, wear=0.55)
    # Sage green on the tanks: Gleba's own kind of colour, muted, so the
    # liquor in them is the brightest thing on the machine.
    m['paint'] = mat("paint", (0.150, 0.200, 0.140), 0.55, 0.30, wear=0.70)
    m['lining'] = mat("lining", (0.030, 0.034, 0.030), 0.70, 0.0)
    # What an idle tank shows: dark settled slurry.
    m['slurry'] = mat("slurry", (0.060, 0.050, 0.035), 0.60, 0.0)
    # The liquor and its froth. Near-grey in the tint sheet so the recipe
    # colours it; kept well under white, because a disc this size facing
    # the sun takes any pale grey to white before the tint multiplies it
    # (the bio garden's pool did exactly that). Rust red in the icon, which
    # is not tinted: the ferric liquor of the pyrite recipe.
    tint = fr.PASS == 'tint'
    # And matte, with next to no specular: glossy, the whole surface caught
    # the sun's reflection at this camera and came out a grey glare with
    # the colour showing only in the rim's shadow.
    m['liquor'] = mat("liquor", (0.360, 0.360, 0.352) if tint
                      else (0.240, 0.090, 0.030), 0.60, 0.0)
    m['froth'] = mat("froth", (0.520, 0.520, 0.508) if tint
                     else (0.420, 0.300, 0.180), 0.80, 0.0)
    for name in ('liquor', 'froth'):
        m[name].node_tree.nodes['Principled BSDF'].inputs[
            'Specular IOR Level'].default_value = 0.08
    m['culture'] = mat("culture", (0.030, 0.140, 0.040), 0.25, 0.0,
                       emit=(0.25, 0.85, 0.30), emit_str=0.40)
    m['screen'] = mat("screen", (0.010, 0.030, 0.035), 0.20, 0.0,
                      emit=(0.20, 0.75, 0.70), emit_str=0.35)

    static, moving = [], []
    add = static.append

    # --- plinth -----------------------------------------------------------
    add(box(4.92, 4.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(4.74, 4.74, 0.09, (0, 0, 0.165), m=m['deck']))

    # --- the two tanks ----------------------------------------------------
    for k, sx in enumerate((-1, 1)):
        tx = sx * TANK_X
        add(cyl_at(tx, TANK_Y, DECK_TOP + 0.04, TANK_R + 0.06, 0.08,
                   m['dark'], verts=56))
        add(shell(tx, TANK_Y, DECK_TOP, TANK_TOP, TANK_R, TANK_R - WALL,
                  m['paint']))
        # A dark lining inside, so the far wall the camera looks down onto
        # reads as the inside of a tank and not more of its outside. Five
        # hundredths thick: at two, the bevel finish() puts on both edges
        # met in the middle and the mesh closed over the top of the tank.
        add(shell(tx, TANK_Y, LIQ - 0.10, TANK_TOP - 0.01,
                  TANK_R - WALL + 0.001, TANK_R - WALL - 0.05, m['lining']))
        # Stiffening hoops round the outside, and a rim.
        for z in (0.48, 0.86):
            add(torus_at((tx, TANK_Y, z), TANK_R + 0.005, 0.025, m['dark'],
                         segments=56))
        add(torus_at((tx, TANK_Y, TANK_TOP), TANK_R - WALL / 2, 0.05,
                     m['steel'], segments=56))
        # The settled slurry an idle tank shows.
        add(cyl_at(tx, TANK_Y, LIQ - 0.04, TANK_R - WALL - 0.04, 0.04,
                   m['slurry'], verts=56))
        # The liquor: a lobed surface with its froth, turning one lobe over
        # the sheet. Tint layer and its group only.
        swirl = [cyl_at(tx, TANK_Y, LIQ, TANK_R - WALL - 0.05, 0.03,
                        m['liquor'], verts=56)]
        # Froth in drifts, small bubbles strung along a spiral arm per lobe:
        # big round spots read as polka dots, not as foam.
        for i in range(LOBES):
            a = 2 * math.pi * i / LOBES
            for r, size in ((0.22, 0.05), (0.36, 0.07), (0.48, 0.06),
                            (0.60, 0.08), (0.70, 0.05), (0.78, 0.04)):
                swirl.append(cyl_at(tx + r * math.cos(a + 1.3 * r),
                                    TANK_Y + r * math.sin(a + 1.3 * r),
                                    LIQ + 0.02, size, 0.03, m['froth'],
                                    verts=12))
        for o in swirl:
            fr.TINT.append(o)
        moving.append(Spin(swirl, pivot=(tx, TANK_Y, 0), axis='Z',
                           degrees=(360 / LOBES) * (1 if k else -1)))
        # The side-entry mixer, low on the wall in the back outer corner,
        # where the plinth has room for it: the stuffing box where the
        # shaft goes in, a gearbox, and the motor pointing away from the
        # tank.
        a = math.radians(90 + 45 * -sx)
        ca, sa = math.cos(a), math.sin(a)

        def at(r):
            return (tx + r * ca, TANK_Y + r * sa, DECK_TOP + 0.30)
        add(cyl_at(*at(TANK_R + 0.05), 0.09, 0.10, m['steel'], verts=16,
                   rot=(0, math.pi / 2, a)))
        add(box(0.30, 0.30, 0.30, at(TANK_R + 0.25), rot=(0, 0, a),
                m=m['yellow']))
        add(cyl_at(*at(TANK_R + 0.55), 0.15, 0.30, m['iron'], verts=24,
                   rot=(0, math.pi / 2, a)))

    # The launder the first tank overflows into the second by.
    add(box(2 * (TANK_X - TANK_R) + 0.30, 0.20, 0.10,
            (0, TANK_Y, TANK_TOP - 0.02), m=m['steel']))
    add(box(2 * (TANK_X - TANK_R) + 0.30, 0.14, 0.02,
            (0, TANK_Y, TANK_TOP + 0.035), m=m['slurry']))

    # --- inoculation vessel, back centre ---------------------------------
    add(cyl_at(CUL_X, CUL_Y, (DECK_TOP + CUL_TOP) / 2, CUL_R,
               CUL_TOP - DECK_TOP, m['steel'], verts=32))
    sp = ball(CUL_X, CUL_Y, CUL_TOP, CUL_R, m['steel'])
    sp.scale = (1, 1, 0.45)
    add(sp)
    # The sight glass, on the side facing the camera.
    add(box(0.16, 0.04, 0.60, (CUL_X, CUL_Y - CUL_R + 0.01,
                               (DECK_TOP + CUL_TOP) / 2 + 0.05), m=m['dark']))
    add(box(0.11, 0.02, 0.54, (CUL_X, CUL_Y - CUL_R - 0.015,
                               (DECK_TOP + CUL_TOP) / 2 + 0.05),
            m=m['culture']))
    # Dosing lines from its shoulder to the back of each tank's rim. They
    # stop at the rim and nothing reaches over the liquor.
    for sx in (-1, 1):
        cx, cy = sx * TANK_X, TANK_Y
        dx, dy = CUL_X - cx, CUL_Y - cy
        n = math.hypot(dx, dy)
        rim = (cx + TANK_R * dx / n, cy + TANK_R * dy / n, TANK_TOP + 0.06)
        add(tube((CUL_X + sx * 0.18, CUL_Y - 0.10, CUL_TOP - 0.02), rim, 0.035,
                 m['steel']))

    # --- aeration blower, front centre ------------------------------------
    add(box(BW, BD, BH, (BX, BY, DECK_TOP + BH / 2), m=m['iron']))
    add(torus_at((BX, BY, FAN_Z + 0.02), FAN_R + 0.03, 0.035, m['steel'],
                 segments=32))
    add(cyl_at(BX, BY, FAN_Z - 0.06, FAN_R + 0.02, 0.06, m['dark'],
               verts=32))
    fan = [cyl_at(BX, BY, FAN_Z + 0.02, 0.07, 0.06, m['steel'], verts=16)]
    for i in range(6):
        a = 2 * math.pi * i / 6
        fan.append(box(FAN_R - 0.06, 0.09, 0.02,
                       (BX + (FAN_R / 2 + 0.02) * math.cos(a),
                        BY + (FAN_R / 2 + 0.02) * math.sin(a),
                        FAN_Z + 0.02),
                       rot=(0.35, 0, a), m=m['dark']))
    moving.append(Spin(fan, pivot=(BX, BY, 0), axis='Z', degrees=60))
    # Air headers out of each end of the blower to the foot of each tank.
    for sx in (-1, 1):
        x0 = BX + sx * BW / 2
        add(lie_x((x0 + sx * TANK_X) / 2, BY, PIPE_Z, 0.06,
                  TANK_X - BW / 2, m['steel'], verts=16))
        add(ball(sx * TANK_X, BY, PIPE_Z, 0.075, m['steel']))
        y1 = TANK_Y - TANK_R + 0.02
        add(lie_y(sx * TANK_X, (BY + y1) / 2, PIPE_Z, 0.06, y1 - BY,
                  m['steel'], verts=16))

    # --- the two ports ----------------------------------------------------
    # Water in on the west at {-2, 1}, acid out on the east at {2, 1}: a
    # stub out of the edge, a bend, and a run north into the tank's wall.
    for sx in (-1, 1):
        y = -1.0
        bend = sx * 1.72
        add(lie_x(sx * (2.40 + 1.72) / 2, y, PIPE_Z, 0.14, 2.40 - 1.72,
                  m['steel']))
        add(lie_x(sx * 2.46, y, PIPE_Z, 0.19, 0.10, m['dark']))
        add(ball(bend, y, PIPE_Z, 0.15, m['steel']))
        wall_y = TANK_Y - math.sqrt(TANK_R ** 2 - (bend - sx * TANK_X) ** 2)
        add(lie_y(bend, (y + wall_y) / 2, PIPE_Z, 0.11, wall_y - y + 0.04,
                  m['steel']))
        # A valve on each run, so it reads as a feed and not a strut.
        add(box(0.24, 0.20, 0.26, (sx * 2.10, y, PIPE_Z + 0.02),
                m=m['dark']))
        add(cyl_at(sx * 2.10, y, PIPE_Z + 0.20, 0.10, 0.03, m['yellow'],
                   verts=16))

    # --- control cabinet, front left --------------------------------------
    kx, ky = -1.70, -1.95
    add(box(0.60, 0.34, 0.70, (kx, ky, DECK_TOP + 0.35), m=m['dark']))
    add(box(0.60, 0.02, 0.06, (kx, ky - 0.18, DECK_TOP + 0.62),
            m=m['yellow']))
    add(box(0.30, 0.02, 0.16, (kx - 0.08, ky - 0.18, DECK_TOP + 0.42),
            m=m['screen']))

    return static, moving


fr.run(build, frame_tiles=8)
