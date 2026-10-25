"""Isostatic Press - Factorio 4x4 entity, rendered at 64 px/tile.

  render_all.sh isostatic_press.py isostatic-press <scratch> 16

The camera, materials, primitives and render loop live in factorio_render.

A hot isostatic press: a furnace inside a pressure vessel, filled with
argon at a thousand atmospheres and heated past 1300 degrees, so that a
powder or a porous part is squeezed equally from every side until it is
solid. What the player sees is what a real one looks like from outside -
the vessel never opens while it works.

Its signature is the frame. A HIP vessel cannot hold its own end closures
against that pressure; a wire-wound yoke does, a loop standing round the
vessel with a column on either side and a round-backed yoke over the top.
The loop stands across X, so the arch over the top has its shape on screen
(docs/blender-renders.md, "A curve in a plane of constant X has no shape").
The vessel does not move, so the yoke over it covers nothing that works.

Facing north it reads from the back of the sprite to the front:

  - three argon bottles in a row at the back right, grey with the green
    shoulder argon is marked with, on a header that runs east to the gas
    port;
  - the vessel in its frame, left of centre and a little north;
  - the argon compressor at the front right: a yellow crankcase with a
    cylinder lying out to each side, the crossheads sliding in open
    guides between them, and its motor in front;
  - the cooling-water chiller in the front left corner, its fan lying flat
    on top, piped to the foot of the vessel;
  - the control cabinet low at the front, between the two.

Two kinds of motion. The compressor's crossheads slide in and out in
their guides, half a stroke apart; they lie flat and are seen from above,
so nothing stands over them in any facing. And the chiller's fan turns
lying flat. Six blades, closing on 60 degrees.

The port, Blender +Y being north and Factorio counting Y southwards: the
argon comes in on the north edge at the back right, {1.5, -1.5}.

FOUR facings: the bottles, the compressor and the port sit on named sides.
No glow sheet: the furnace is inside the vessel, and a real press shows no
light.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from mathutils import Vector                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             torus_at, MATS, mat, Spin, Slide)

DECK_TOP = 0.21
PIPE_Z = 0.37                    # the stub axis the arc furnace uses

# --- the vessel and its frame ----------------------------------------------
VX, VY = -0.50, 0.20
VR = 0.60
VT = 1.70                        # top of the vessel, under the closure
CLOSE_T = VT + 0.10              # top of the closure, where the yoke bears
COL_W = 0.26                     # column width across X
COL_X = VR + 0.08 + COL_W / 2    # column centre, out from the vessel axis
FRAME_D = 0.80                   # depth of the frame along Y
ARCH_R = COL_X + COL_W / 2       # outer radius of the yoke over the top
WIRE_D = 0.56                    # the wound band, narrower than the cheeks

# --- argon bottles ---------------------------------------------------------
BOTTLE_R = 0.12
BOTTLE_X = (0.62, 0.90, 1.18)
BOTTLE_Y = 1.55
BOTTLE_TOP = 1.35
PORT_X = 1.5

# --- compressor ------------------------------------------------------------
CX, CY = 1.22, -0.78             # crankcase centre
CRANK_W, CRANK_D, CRANK_H = 0.40, 0.55, 0.42
GUIDE_L = 0.22                   # open guide between crankcase and cylinder
CYL_R, CYL_L = 0.16, 0.28
CYL_Z = DECK_TOP + 0.24
STROKE = 0.08
DY = CY + 0.40                   # the common discharge line, behind it

# --- chiller ---------------------------------------------------------------
HX, HY = -1.025, -1.40
HW, HD, HH = 0.75, 0.70, 0.40
FAN_R = 0.27
FAN_Z = DECK_TOP + HH + 0.08


def lie_x(x, y, z, r, length, material, verts=24):
    """A cylinder lying along X."""
    return cyl_at(x, y, z, r, length, material, verts=verts,
                  rot=(0, math.pi / 2, 0))


def lie_y(x, y, z, r, length, material, verts=24):
    """A cylinder lying along Y."""
    return cyl_at(x, y, z, r, length, material, verts=verts,
                  rot=(math.pi / 2, 0, 0))


def tube(p1, p2, r, material, verts=12):
    """A round pipe between two points. Not bar(), which is square: the
    pipes on these models are round all the way."""
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


def half_cyl(x, y, z, r, depth, material, verts=48):
    """A half cylinder lying along Y, flat face down at z - the yoke."""
    bpy.ops.mesh.primitive_cylinder_add(vertices=verts, radius=r, depth=depth,
                                        location=(x, y, z),
                                        rotation=(math.pi / 2, 0, 0))
    o = bpy.context.object
    o.data.materials.append(material)
    # Cut away the half under z with a box.
    bpy.ops.mesh.primitive_cube_add(size=1, location=(x, y, z - r))
    cutter = bpy.context.object
    cutter.scale = (2 * r + 0.2, depth + 0.2, 2 * r)
    mod = o.modifiers.new("cut", 'BOOLEAN')
    mod.operation = 'DIFFERENCE'
    mod.object = cutter
    bpy.context.view_layer.objects.active = o
    bpy.ops.object.modifier_apply(modifier=mod.name)
    mesh = cutter.data
    bpy.data.objects.remove(cutter, do_unlink=True)
    bpy.data.meshes.remove(mesh)
    return o


def ball(x, y, z, r, material):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=r, location=(x, y, z),
                                         segments=20, ring_count=10)
    o = bpy.context.object
    o.data.materials.append(material)
    return o


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.050, 0.048, 0.046), 0.80, 0.20, wear=0.55)
    # The frame: blue-grey like the arc furnace's water-cooled shell, and
    # the wire wound round it nearly black, so the band reads as a band.
    m['frame'] = mat("frame", (0.160, 0.190, 0.230), 0.50, 0.80, wear=0.75)
    m['wire'] = mat("wire", (0.035, 0.037, 0.040), 0.62, 0.70)
    # The vessel is the lightest thing on the machine: bare forged steel,
    # rough and only half metallic - fully metallic it mirrors the dark sky
    # and the shade of the yoke, and came out a black barrel.
    m['vessel'] = mat("vessel", (0.440, 0.420, 0.385), 0.48, 0.65,
                      wear=0.60)
    # Argon's marking: a grey bottle with a dark green shoulder.
    m['bottle'] = mat("bottle", (0.210, 0.210, 0.200), 0.45, 0.6, wear=0.50)
    m['shoulder'] = mat("shoulder", (0.030, 0.140, 0.060), 0.45, 0.3)
    m['brass'] = mat("brass", (0.520, 0.380, 0.120), 0.30, 1.0)
    m['screen'] = mat("screen", (0.010, 0.030, 0.035), 0.20, 0.0,
                      emit=(0.20, 0.75, 0.70), emit_str=0.35)

    static, moving = [], []
    add = static.append

    # --- plinth -----------------------------------------------------------
    add(box(3.92, 3.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(3.74, 3.74, 0.09, (0, 0, 0.165), m=m['deck']))

    # --- the vessel -------------------------------------------------------
    # A forged cylinder in a jacket of wound wire; the darker hoops are the
    # jacket's seams, and they are what make a grey drum read as a pressure
    # vessel rather than a tank.
    add(cyl_at(VX, VY, DECK_TOP + 0.04, VR + 0.08, 0.08, m['dark'],
               verts=48))
    add(cyl_at(VX, VY, (DECK_TOP + VT) / 2, VR, VT - DECK_TOP, m['vessel'],
               verts=48))
    for i in range(3):
        z = DECK_TOP + 0.25 + i * (VT - DECK_TOP - 0.45) / 2
        add(torus_at((VX, VY, z), VR + 0.004, 0.018, m['dark'], segments=48))
    # The top closure, the plug the yoke holds down, and the power and
    # thermocouple feedthroughs on the part of it the yoke leaves in view.
    add(cyl_at(VX, VY, VT + 0.05, VR + 0.05, 0.10, m['steel'], verts=48))
    for sx in (-1, 1):
        add(cyl_at(VX + sx * 0.32, VY - 0.48, VT + 0.13, 0.05, 0.06,
                   m['brass'], verts=12))

    # --- the frame --------------------------------------------------------
    # Two columns, then the yoke over the top bearing on the closure. The
    # yoke under the vessel is below the deck and is not modelled.
    for sx in (-1, 1):
        x = VX + sx * COL_X
        add(box(COL_W, FRAME_D, CLOSE_T - DECK_TOP,
                (x, VY, (DECK_TOP + CLOSE_T) / 2), m=m['frame']))
        # The wound band down the outer face of each column.
        add(box(0.03, WIRE_D, CLOSE_T - DECK_TOP,
                (x + sx * (COL_W / 2 + 0.015), VY, (DECK_TOP + CLOSE_T) / 2),
                m=m['wire']))
        # A foot plate, so the column stands on something.
        add(box(COL_W + 0.14, FRAME_D + 0.14, 0.06,
                (x, VY, DECK_TOP + 0.03), m=m['dark']))
    add(half_cyl(VX, VY, CLOSE_T, ARCH_R, FRAME_D, m['frame']))
    add(half_cyl(VX, VY, CLOSE_T, ARCH_R + 0.03, WIRE_D, m['wire']))
    # The beam the arch springs from, across both columns, and the cheek
    # plates on its front face that clamp the wire package.
    add(box(2 * ARCH_R, FRAME_D, 0.08, (VX, VY, CLOSE_T + 0.04),
            m=m['frame']))
    for k in range(3):
        a = math.pi * (k + 1) / 4
        add(cyl_at(VX + (ARCH_R - 0.16) * math.cos(a),
                   VY - FRAME_D / 2 - 0.01,
                   CLOSE_T + (ARCH_R - 0.16) * math.sin(a), 0.045, 0.04,
                   m['steel'], verts=12, rot=(math.pi / 2, 0, 0)))

    # --- argon bottles, back right ---------------------------------------
    for x in BOTTLE_X:
        add(cyl_at(x, BOTTLE_Y, (DECK_TOP + BOTTLE_TOP) / 2, BOTTLE_R,
                   BOTTLE_TOP - DECK_TOP, m['bottle'], verts=24))
        sh = ball(x, BOTTLE_Y, BOTTLE_TOP, BOTTLE_R, m['shoulder'])
        sh.scale = (1, 1, 0.75)
        add(sh)
        add(cyl_at(x, BOTTLE_Y, BOTTLE_TOP + 0.12, 0.035, 0.08, m['brass'],
                   verts=12))
        # The pigtail from each valve down to the header.
        add(tube((x, BOTTLE_Y - 0.03, BOTTLE_TOP + 0.13),
                 (x, BOTTLE_Y - 0.30, PIPE_Z + 0.04), 0.022, m['steel']))
    # The restraint bar the bottles are chained to.
    add(box(BOTTLE_X[-1] - BOTTLE_X[0] + 0.40, 0.05, 0.05,
            ((BOTTLE_X[0] + BOTTLE_X[-1]) / 2, BOTTLE_Y - BOTTLE_R - 0.03,
             0.95), m=m['steel']))
    for x in (BOTTLE_X[0] - 0.20, BOTTLE_X[-1] + 0.20):
        add(box(0.05, 0.05, 0.80, (x, BOTTLE_Y - BOTTLE_R - 0.03, 0.60),
                m=m['steel']))
    # Header along the front of the rack, east to the port, then north
    # out of the edge.
    hy = BOTTLE_Y - 0.30
    add(lie_x((BOTTLE_X[0] + PORT_X) / 2, hy, PIPE_Z, 0.08,
              PORT_X - BOTTLE_X[0], m['steel'], verts=16))
    add(ball(PORT_X, hy, PIPE_Z, 0.15, m['steel']))
    add(lie_y(PORT_X, (hy + 1.90) / 2, PIPE_Z, 0.14, 1.90 - hy, m['steel']))
    add(lie_y(PORT_X, 1.96, PIPE_Z, 0.19, 0.10, m['dark']))
    # A regulator on the header, so it reads as gas plumbing.
    add(box(0.16, 0.16, 0.18, (PORT_X - 0.22, hy, PIPE_Z + 0.06),
            m=m['dark']))
    add(cyl_at(PORT_X - 0.22, hy, PIPE_Z + 0.20, 0.07, 0.03, m['yellow'],
               verts=16))

    # --- compressor, front right -----------------------------------------
    add(box(CRANK_W, CRANK_D, CRANK_H, (CX, CY, DECK_TOP + CRANK_H / 2),
            m=m['yellow']))
    add(box(CRANK_W + 0.06, CRANK_D + 0.06, 0.04,
            (CX, CY, DECK_TOP + CRANK_H + 0.02), m=m['dark']))
    # The motor in front of the crankcase, its shaft into the crank.
    add(lie_y(CX, CY - CRANK_D / 2 - 0.20, DECK_TOP + 0.20, 0.17, 0.34,
              m['iron'], verts=24))
    add(lie_y(CX, CY - CRANK_D / 2 - 0.39, DECK_TOP + 0.20, 0.12, 0.04,
              m['dark'], verts=24))
    for sx in (-1, 1):
        gx = CX + sx * (CRANK_W / 2 + GUIDE_L / 2)
        # The open guide: a floor and two side rails, nothing over the top.
        add(box(GUIDE_L, 0.26, 0.04, (gx, CY, CYL_Z - 0.10), m=m['dark']))
        for sy in (-1, 1):
            add(box(GUIDE_L, 0.03, 0.12, (gx, CY + sy * 0.12, CYL_Z - 0.03),
                    m=m['steel']))
        # The cylinder, finned, lying out beyond the guide.
        cx = CX + sx * (CRANK_W / 2 + GUIDE_L + CYL_L / 2)
        add(lie_x(cx, CY, CYL_Z, CYL_R, CYL_L, m['iron'], verts=24))
        for k in range(4):
            add(lie_x(cx - CYL_L / 2 + 0.05 + k * (CYL_L - 0.10) / 3, CY,
                      CYL_Z, CYL_R + 0.03, 0.025, m['steel'], verts=24))
        hx = cx + sx * (CYL_L / 2 + 0.03)
        add(lie_x(hx, CY, CYL_Z, CYL_R + 0.02, 0.06, m['dark'], verts=24))
        # The crosshead and its piston rod - the part that moves.
        group = [box(0.10, 0.18, 0.12,
                     (CX + sx * (CRANK_W / 2 + 0.07), CY, CYL_Z),
                     m=m['steel']),
                 lie_x(CX + sx * (CRANK_W / 2 + 0.07 + GUIDE_L / 2), CY,
                       CYL_Z, 0.03, GUIDE_L, m['vessel'], verts=12)]
        moving.append(Slide(group, axis='X', amplitude=STROKE,
                            phase=0.0 if sx > 0 else 0.5))
        # Discharge: north off the cylinder head into the common line.
        add(lie_y(hx, (CY + DY) / 2, PIPE_Z, 0.05, DY - CY, m['steel'],
                  verts=16))

    # The common discharge line, west behind the compressor to the foot of
    # the vessel.
    west, east = VX + 0.25, CX + CRANK_W / 2 + GUIDE_L + CYL_L + 0.03
    add(lie_x((west + east) / 2, DY, PIPE_Z, 0.06, east - west, m['steel'],
              verts=16))
    for x in (west, CX - (CRANK_W / 2 + GUIDE_L + CYL_L + 0.03), east):
        add(ball(x, DY, PIPE_Z, 0.075, m['steel']))

    # --- chiller, front left ---------------------------------------------
    add(box(HW, HD, HH, (HX, HY, DECK_TOP + HH / 2), m=m['iron']))
    # Louvres down the front, so the box reads as a cooler.
    for k in range(5):
        add(box(HW - 0.14, 0.02, 0.03,
                (HX, HY - HD / 2 - 0.01, DECK_TOP + 0.08 + k * 0.07),
                rot=(0.5, 0, 0), m=m['dark']))
    fx, fy = HX, HY
    add(torus_at((fx, fy, FAN_Z + 0.02), FAN_R + 0.03, 0.035, m['steel'],
                 segments=32))
    add(cyl_at(fx, fy, FAN_Z - 0.06, FAN_R + 0.02, 0.06, m['dark'],
               verts=32))
    fan = [cyl_at(fx, fy, FAN_Z + 0.02, 0.07, 0.06, m['steel'], verts=16)]
    for i in range(6):
        a = 2 * math.pi * i / 6
        fan.append(box(FAN_R - 0.06, 0.09, 0.02,
                       (fx + (FAN_R / 2 + 0.02) * math.cos(a),
                        fy + (FAN_R / 2 + 0.02) * math.sin(a),
                        FAN_Z + 0.02),
                       rot=(0.35, 0, a), m=m['dark']))
    moving.append(Spin(fan, pivot=(fx, fy, 0), axis='Z', degrees=60))
    # Supply and return to the foot of the vessel, each ending where it
    # meets the vessel's skin.
    for k, x in enumerate((VX - 0.30, VX - 0.15)):
        z = PIPE_Z - 0.04 + 0.10 * k
        y0 = HY + HD / 2
        y1 = VY - math.sqrt(VR ** 2 - (x - VX) ** 2) + 0.03
        add(lie_y(x, (y0 + y1) / 2, z, 0.045, y1 - y0, m['steel'],
                  verts=16))

    # --- control cabinet, front middle -----------------------------------
    kx, ky = -0.30, -1.62
    add(box(0.56, 0.28, 0.66, (kx, ky, DECK_TOP + 0.33), m=m['dark']))
    add(box(0.56, 0.02, 0.06, (kx, ky - 0.15, DECK_TOP + 0.58),
            m=m['yellow']))
    add(box(0.30, 0.02, 0.16, (kx - 0.06, ky - 0.15, DECK_TOP + 0.40),
            m=m['screen']))
    for k in range(3):
        add(cyl_at(kx + 0.16, ky - 0.16, DECK_TOP + 0.44 - 0.07 * k, 0.025,
                   0.02, m['yellow'], verts=10, rot=(math.pi / 2, 0, 0)))

    return static, moving


fr.run(build, frame_tiles=8)
