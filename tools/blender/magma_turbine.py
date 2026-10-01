"""Magma turbine - Factorio 3x15 entity, rendered at 64 px/tile.

  render_all.sh magma_turbine.py magma-turbine <scratch> 16

The camera, materials, primitives and render loop live in factorio_render.

A fusion generator underneath, fifteen tiles long: magma plasma in at the
south end, 250 MW and hot molten salt out of the north end. So the machine
reads from one end to the other the way a power station's turbine set does -
plasma head, high pressure casing, a big low pressure casing over its
condenser, the generator and its exciter - and the colour changes with it:
scorched ochre where the plasma is, bare steel through the turbine, the
generator in green paint.

FOUR facings, not two. A generator prototype asks for two animations because
its ends are the same; this one's are not - plasma goes in at one and salt
comes out of the other - so south is not north seen from behind, and the
fusion generator it is built on asks for all four.

Everything that moves is on top or on the flank, and turns about a vertical
axis or slides up and down: a flyball governor on the hot end, three cooling
fans lying on the generator's back and two valve stems on the high pressure
casing. Those are the motions that survive every facing - a wheel turning
about the shaft would be seen edge-on in two of the four, and the shaft
coupling, which is the obvious thing to spin, sits in a trough between two
casings taller than it and cannot be seen from 45 degrees at all.

The plasma glow is not in the entity sheet. It is the working light, drawn
additive and only while the turbine runs, so each glowing part is modelled
twice: a dark sight glass that the entity sheet shows, and the glow itself
just proud of it in fr.TINT, which becomes the working-light sheet.

Axis convention, as in geo_thermal_turbine.py: modelled +Y renders at the
top of the sprite, which is north, and Factorio counts Y southwards. The
plasma inlets at prototype {+-1, 7} are modelled at y = -7.2.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
from mathutils import Vector                                  # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at,         # noqa: E402
                             box, bar, torus_at, MATS, mat, Spin,
                             Slide)

HALF_X, HALF_Y = 1.5, 7.5
DECK = 0.20                      # top of the concrete plinth
SHAFT_Z = 1.05                   # the centre line every casing is on

# Where each section starts and ends, south to north.
HEAD_S, HEAD_N = -7.30, -5.40
HP_S, HP_N = -5.40, -3.00
CONE_N = -2.40
LP_N = 1.20
GEN_S, GEN_N = 1.90, 5.70
EXC_N = 6.60

HP_R, LP_R, GEN_R, EXC_R = 0.62, 1.05, 0.85, 0.45
PORT_Z = 0.55                    # height of every fluid port on the ends

FAN_N = 6
FAN_R = 0.34
FAN_SPIN = 360 / FAN_N           # a turn the blades are symmetric under
FAN_Y = (2.65, 3.80, 4.95)

GOV_X, GOV_Y = 1.02, -3.55       # the flyball governor, east flank
GOV_Z = 1.72                     # height of the balls' hinge


def disc(x, y, z, r, thick, m, verts=32):
    """A cylinder whose axis runs north-south: a flange, a band, a port."""
    return cyl_at(x, y, z, r, thick, m, verts=verts, rot=(math.pi / 2, 0, 0))


def barrel(y0, y1, r, m, x=0.0, z=SHAFT_Z, verts=36):
    """A length of casing between two points on the north-south axis."""
    return cyl_at(x, (y0 + y1) / 2, z, r, y1 - y0, m, verts=verts,
                  rot=(math.pi / 2, 0, 0))


def taper(y0, y1, r0, r1, m, verts=36):
    """A cone along +Y, r0 at the south end and r1 at the north."""
    bpy.ops.mesh.primitive_cone_add(vertices=verts, radius1=r0, radius2=r1,
                                    depth=y1 - y0,
                                    location=(0, (y0 + y1) / 2, SHAFT_Z),
                                    rotation=(-math.pi / 2, 0, 0))
    o = bpy.context.object
    o.data.materials.append(m)
    return o


def pipe(p1, p2, r, m, verts=24):
    """A round pipe from p1 to p2, at any angle.

    Not `bar`: that is a square section, and a square run of pipe reads as
    a length of angle iron. Every pipe on this machine is one of these.
    """
    d = Vector(p2) - Vector(p1)
    mid = (Vector(p1) + Vector(p2)) / 2
    rot = Vector((0, 0, 1)).rotation_difference(d).to_euler()
    return cyl_at(mid.x, mid.y, mid.z, r, d.length, m, verts=verts,
                  rot=tuple(rot))


def knuckle(p, r, m):
    """A ball where a pipe meets something, so the joint is rounded over
    rather than a cut end butting into a flat face."""
    bpy.ops.mesh.primitive_uv_sphere_add(segments=24, ring_count=12,
                                         radius=r, location=p)
    o = bpy.context.object
    o.data.materials.append(m)
    return o


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['scorch'] = mat("scorch", (0.235, 0.150, 0.085), 0.60, 1.0, wear=0.90)
    m['concrete'] = mat("concrete", (0.300, 0.292, 0.275), 0.92, 0.0,
                        wear=0.50)
    # Generator green, muted: the paint power stations have always put on
    # their generators, and the one colour on the machine that says "this
    # end is electrical" before the copper does.
    m['paint'] = mat("paint", (0.105, 0.160, 0.110), 0.55, 0.20, wear=0.55)
    m['copper'] = mat("copper", (0.620, 0.300, 0.110), 0.30, 1.0, wear=0.45)
    m['brass'] = mat("brass", (0.520, 0.380, 0.115), 0.34, 1.0, wear=0.55)
    m['ceramic'] = mat("ceramic", (0.420, 0.300, 0.200), 0.25, 0.0)
    # A sight glass with nothing lit behind it: dark and glossy, so the idle
    # turbine still shows where the glow will be.
    m['glass'] = mat("glass", (0.030, 0.020, 0.030), 0.12, 0.0)
    # The plasma, lit. Kept under the 1.5 at which this view transform clips
    # to white, because the violet is the whole point.
    # It is drawn additive over the entity sheet, which lifts it again, so
    # the colour is kept saturated here: at the fluid icon's pale pink it came
    # out lavender over the scorched iron.
    m['plasma'] = mat("plasma", (0.300, 0.030, 0.200), 0.30, 0.0,
                      emit=(1.00, 0.16, 0.68), emit_str=1.20)

    static, moving = [], []
    add = static.append

    def glow(o):
        """A part of the working light: in fr.TINT, so it is left out of the
        entity sheet and becomes the whole of the glow sheet."""
        fr.TINT.append(o)
        add(o)

    # --- plinth -----------------------------------------------------------
    add(box(2.90, 14.90, DECK, (0, 0, DECK / 2), m=m['concrete']))
    for y in (-6.35, -4.85, -3.35, 1.55, 3.00, 4.60, 6.15):
        add(box(1.30, 0.42, 0.10, (0, y, DECK + 0.05), m=m['steel']))

    # --- plasma head: the two inlets, south ---------------------------------
    hy = (HEAD_S + HEAD_N) / 2
    add(box(2.50, HEAD_N - HEAD_S, 1.16, (0, hy, DECK + 0.58),
            m=m['scorch']))
    # A dark rim round its top, not a lid: a flat plate of grey iron over the
    # whole head read as a block of concrete sitting on the plinth.
    add(box(2.58, HEAD_N - HEAD_S + 0.08, 0.08, (0, hy, DECK + 1.14),
            m=m['dark']))
    add(box(2.30, HEAD_N - HEAD_S - 0.20, 0.10, (0, hy, DECK + 1.17),
            m=m['scorch']))
    bpy.ops.mesh.primitive_uv_sphere_add(segments=32, ring_count=16,
                                         radius=0.72,
                                         location=(0, hy + 0.10, DECK + 1.20))
    dome = bpy.context.object
    dome.scale = (1.0, 1.0, 0.62)
    dome.data.materials.append(m['scorch'])
    add(dome)
    # Four slots round the dome, so a working turbine shows its plasma from
    # every side rather than only from the south.
    for k in range(4):
        a = math.pi / 4 + k * math.pi / 2
        sx, sy = 0.60 * math.cos(a), hy + 0.10 + 0.60 * math.sin(a)
        add(box(0.07, 0.30, 0.20, (sx, sy, DECK + 1.32),
                rot=(0, 0, a), m=m['glass']))
        glow(box(0.05, 0.26, 0.17, (sx * 1.035, hy + 0.10 + (sy - hy - 0.10)
                                    * 1.035, DECK + 1.32),
                 rot=(0, 0, a), m=m['plasma']))
    for sx in (-1, 1):
        # The inlets, where the reactor's plasma arrives: a nozzle each,
        # its throat glowing while the turbine runs.
        add(disc(sx * 1.0, -7.28, PORT_Z, 0.30, 0.30, m['iron'], verts=24))
        add(disc(sx * 1.0, -7.42, PORT_Z, 0.37, 0.08, m['dark'], verts=24))
        add(disc(sx * 1.0, -7.465, PORT_Z, 0.27, 0.012, m['glass'],
                 verts=24))
        glow(disc(sx * 1.0, -7.478, PORT_Z, 0.25, 0.012, m['plasma'],
                  verts=24))
    # The head's sight window, facing south - the camera side in the
    # vertical sheet and the one thing that says "hot" from far away.
    add(box(0.74, 0.03, 0.34, (0, HEAD_S - 0.005, DECK + 0.84),
            m=m['iron']))
    add(box(0.62, 0.02, 0.24, (0, HEAD_S - 0.02, DECK + 0.84),
            m=m['glass']))
    glow(box(0.58, 0.02, 0.20, (0, HEAD_S - 0.035, DECK + 0.84),
             m=m['plasma']))

    # --- high pressure casing ---------------------------------------------
    add(barrel(HP_S, HP_N, HP_R, m['scorch']))
    for y in (-5.15, -4.35, -3.30):
        add(disc(0, y, SHAFT_Z, HP_R + 0.05, 0.07, m['iron'], verts=36))
    # Sight glasses along its back, one to each bay between the bands.
    for y in (-4.75, -3.82):
        add(cyl_at(0, y, SHAFT_Z + HP_R - 0.01, 0.12, 0.06, m['iron'],
                   verts=16))
        add(cyl_at(0, y, SHAFT_Z + HP_R + 0.025, 0.09, 0.012, m['glass'],
                   verts=16))
        glow(cyl_at(0, y, SHAFT_Z + HP_R + 0.035, 0.08, 0.012, m['plasma'],
                    verts=16))
    # Valve chests on the shoulders, fed from the head. Their stems ride up
    # and down, half a stroke apart, which is the turbine taking its load.
    for i, sx in enumerate((-1, 1)):
        vx, vy = sx * 0.62, -4.55
        add(box(0.34, 0.52, 0.36, (vx, vy, SHAFT_Z + 0.52), m=m['steel']))
        feed0 = (sx * 0.95, HEAD_N + 0.05, DECK + 1.05)
        feed1 = (vx, vy - 0.24, SHAFT_Z + 0.52)
        add(pipe(feed0, feed1, 0.065, m['scorch'], verts=16))
        add(knuckle(feed0, 0.085, m['scorch']))
        add(knuckle(feed1, 0.085, m['scorch']))
        add(cyl_at(vx, vy, SHAFT_Z + 0.76, 0.10, 0.12, m['iron'], verts=12))
        stem = [cyl_at(vx, vy, SHAFT_Z + 0.98, 0.04, 0.34, m['steel'],
                       verts=10),
                box(0.26, 0.10, 0.06, (vx, vy, SHAFT_Z + 1.14),
                    m=m['iron'])]
        moving.append(Slide(stem, axis='Z', amplitude=0.06, phase=i / 2))

    # --- low pressure casing over its condenser -----------------------------
    add(taper(HP_N, CONE_N, HP_R, LP_R, m['steel']))
    add(barrel(CONE_N, LP_N, LP_R, m['steel'], verts=48))
    # The bolted horizontal joint, running along both sides at the shaft
    # line: the detail that makes a drum read as a turbine casing.
    add(box(2.30, LP_N - CONE_N - 0.10, 0.08,
            (0, (CONE_N + LP_N) / 2, SHAFT_Z), m=m['iron']))
    for y in (-2.20, -1.05, 0.25, 1.05):
        add(disc(0, y, SHAFT_Z, LP_R + 0.05, 0.08, m['iron'], verts=48))
    # Bolt heads along the joint, and a hatch on each flank. The casing is
    # the biggest thing on the machine, and bare it was a grey drum.
    for sx in (-1, 1):
        for k in range(9):
            y = CONE_N + 0.25 + k * (LP_N - CONE_N - 0.50) / 8
            add(box(0.07, 0.07, 0.06, (sx * 1.13, y, SHAFT_Z + 0.07),
                    m=m['dark']))
        add(box(0.10, 0.62, 0.46, (sx * (LP_R - 0.02), -1.65, SHAFT_Z - 0.38),
                m=m['iron']))
    ly = (CONE_N + LP_N) / 2
    add(box(2.70, LP_N - CONE_N + 0.30, 0.56, (0, ly, DECK + 0.28),
            m=m['dark']))

    # --- the shaft between the turbine and the generator ---------------------
    add(barrel(LP_N, GEN_S, 0.16, m['steel'], verts=24))
    add(disc(0, (LP_N + GEN_S) / 2, SHAFT_Z, 0.36, 0.14, m['iron'],
             verts=24))
    add(box(0.80, 0.30, SHAFT_Z - DECK - 0.10,
            (0, LP_N + 0.20, DECK + (SHAFT_Z - DECK - 0.10) / 2),
            m=m['iron']))

    # --- generator ---------------------------------------------------------
    add(barrel(GEN_S, GEN_N, GEN_R, m['paint'], verts=40))
    # Cooling ribs, spaced unevenly so the barrel does not read as a ruler.
    for y in (2.05, 2.55, 3.35, 4.25, 5.05, 5.55):
        add(disc(0, y, SHAFT_Z, GEN_R + 0.05, 0.06, m['iron'], verts=40))
    # The air cooler on its back, and the fans lying in it. A camera looking
    # down at 45 degrees sees the top of a machine whichever way it faces,
    # so fans lying flat are the one moving part no facing can hide.
    cy = (FAN_Y[0] + FAN_Y[-1]) / 2
    top = SHAFT_Z + GEN_R + 0.10
    add(box(1.10, FAN_Y[-1] - FAN_Y[0] + 0.95, 0.30, (0, cy, top - 0.15),
            m=m['paint']))
    for fy in FAN_Y:
        add(torus_at((0, fy, top + 0.02), FAN_R + 0.06, 0.04, m['dark'],
                     segments=24))
        add(cyl_at(0, fy, top - 0.02, FAN_R + 0.03, 0.02, m['dark'],
                   verts=24))
        fan = []
        for k in range(FAN_N):
            a = 2 * math.pi * k / FAN_N
            fan.append(box(FAN_R * 1.85, 0.13, 0.035, (0, fy, top + 0.03),
                           rot=(0.25, 0, a), m=m['steel']))
        fan.append(cyl_at(0, fy, top + 0.03, 0.08, 0.10, m['iron'],
                          verts=12))
        moving.append(Spin(fan, pivot=(0, fy, top + 0.03), axis='Z',
                           degrees=FAN_SPIN))
    # Terminal box on the east flank, with three bushings on it - the
    # clearest single cue that this end makes electricity.
    add(box(0.40, 0.90, 0.46, (1.14, 2.75, 1.00), m=m['dark']))
    for k, y in enumerate((2.47, 2.75, 3.03)):
        add(cyl_at(1.14, y, 1.34, 0.055, 0.22, m['ceramic'], verts=10))
        add(bar((1.14, y, 1.44), (1.36, y, 1.44), 0.05, m['copper']))

    # --- exciter -----------------------------------------------------------
    add(barrel(GEN_N, EXC_N, EXC_R, m['steel'], verts=28))
    add(disc(0, EXC_N + 0.02, SHAFT_Z, EXC_R + 0.04, 0.06, m['dark'],
             verts=28))
    add(disc(0, GEN_N + 0.05, SHAFT_Z, GEN_R * 0.7, 0.10, m['iron'],
             verts=36))

    # --- the salt returns and the north end ---------------------------------
    # Hot salt drains out of the condenser and runs up both flanks to the
    # two outlets at the north end - dead straight, at the height and on the
    # line of the outlet it ends in. It used to run lower and further out and
    # step across to the outlet through a square elbow, which was the one
    # angular thing on a machine made of drums.
    for sx in (-1, 1):
        px = sx * 1.0
        add(barrel(LP_N, 7.10, 0.13, m['iron'], x=px, z=PORT_Z, verts=24))
        for y in (LP_N + 0.20, 6.92):
            add(disc(px, y, PORT_Z, 0.17, 0.06, m['dark'], verts=24))
        for y in (2.30, 4.05, 5.80):
            add(box(0.26, 0.14, PORT_Z - 0.13 - DECK,
                    (px, y, DECK + (PORT_Z - 0.13 - DECK) / 2),
                    m=m['steel']))
        add(disc(sx * 1.0, 7.22, PORT_Z, 0.18, 0.26, m['iron'], verts=24))
        add(disc(sx * 1.0, 7.40, PORT_Z, 0.26, 0.08, m['dark'], verts=24))
    # The plasma passes on through the north end to the next turbine.
    add(disc(0, 7.18, PORT_Z, 0.24, 0.34, m['scorch'], verts=24))
    add(disc(0, 7.40, PORT_Z, 0.31, 0.08, m['dark'], verts=24))
    add(torus_at((0, 7.02, PORT_Z), 0.25, 0.035, m['glass'],
                 rot=(math.pi / 2, 0, 0), segments=24))
    glow(torus_at((0, 7.02, PORT_Z), 0.25, 0.040, m['plasma'],
                  rot=(math.pi / 2, 0, 0), segments=24))
    add(box(0.60, 0.50, PORT_Z, (0, 6.90, DECK + PORT_Z / 2 - 0.05),
            m=m['iron']))

    # --- flyball governor on the hot end's east flank ----------------------
    add(box(0.34, 0.34, GOV_Z - DECK - 0.30,
            (GOV_X, GOV_Y, DECK + (GOV_Z - DECK - 0.30) / 2), m=m['iron']))
    add(pipe((GOV_X - 0.14, GOV_Y, GOV_Z - 0.40),
             (HP_R - 0.05, GOV_Y, SHAFT_Z + 0.10), 0.035, m['steel'],
             verts=12))
    gov = [cyl_at(GOV_X, GOV_Y, GOV_Z - 0.05, 0.035, 0.60, m['steel'],
                  verts=10),
           cyl_at(GOV_X, GOV_Y, GOV_Z + 0.25, 0.07, 0.06, m['brass'],
                  verts=12)]
    for sx in (-1, 1):
        ball = (GOV_X + sx * 0.24, GOV_Y, GOV_Z - 0.18)
        gov.append(bar((GOV_X, GOV_Y, GOV_Z + 0.22), ball, 0.03, m['steel']))
        bpy.ops.mesh.primitive_uv_sphere_add(segments=16, ring_count=10,
                                             radius=0.075, location=ball)
        b = bpy.context.object
        b.data.materials.append(m['yellow'])
        gov.append(b)
    moving.append(Spin(gov, pivot=(GOV_X, GOV_Y, GOV_Z), axis='Z',
                       degrees=180))

    return static, moving


# Twenty tiles of frame: the machine is fifteen tiles on its long axis and
# stands over two tiles high, and the same square frame has to hold it in
# all four facings.
fr.run(build, frame_tiles=20)
