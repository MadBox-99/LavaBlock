"""Lithography machine - Factorio 2x8 entity, rendered at 64 px/tile.

  render_all.sh lithography_machine.py lithography-machine <scratch> 24

The camera, materials, primitives and render loop live in factorio_render.

An EUV scanner, laid out the way the real ones are: the light source at one
end, the scanner in the middle and the wafer stage at the other. Facing
north it reads from the back of the sprite to the front:

  - the source, at the north end: a steel vacuum vessel with a tin droplet
    generator standing on top of it and the laser source - the part that
    wears out and is fed in as an item - upright beside it, its ruby window
    glowing red. The laser fires into the vessel and turns the tin to the
    plasma whose light does the printing;
  - the scanner, clean-room grey with a blue band: a tall optics tower and a
    lower cabinet in front of it, stepped down so a rotated machine does not
    stand its tallest part over the wafer;
  - the wafer stage, at the south end, open and low: a black granite block
    with a chuck on rails scanning a wafer side to side under the exposure
    line.

Nothing stands over the stage. The real projection optics hang over the
wafer, and at this camera they would be a box laid across the one moving
part the sprite has; the light is shown instead as a line on the wafer
itself, with nothing above it.

FOUR facings. There are no fluid connections, but the two ends are not
alike - the source is not the stage seen from behind - so south is its own
picture.

The glow is the working light, drawn additive only while the machine runs:
the plasma window, the laser's ruby window, the exposure line and the
throat of the exposure port. Each is modelled twice, a dark glass that the
entity sheet shows and the glow just proud of it in fr.TINT.

Axis convention, as in magma_turbine.py: modelled +Y renders at the top of
the sprite, which is north.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             MATS, mat, Slide)

HALF_X, HALF_Y = 1.0, 4.0
DECK = 0.12                      # top of the skid

# Where each section starts and ends, south to north.
STAGE_S, STAGE_N = -3.90, -1.75
CAB_S, CAB_N = -1.75, -0.55      # the low cabinet in front of the tower
TOWER_S, TOWER_N = -0.55, 2.05
SRC_S, SRC_N = 2.15, 3.92

CAB_TOP = 1.12
TOWER_TOP = 1.55
GRANITE_TOP = 0.46

STAGE_Y = -2.78                  # the wafer's centre line
WAFER_R = 0.36
SCAN = 0.27                      # chuck travel each way; under WAFER_R, so
                                 # the exposure line never runs off the wafer

VESSEL_X, VESSEL_Y, VESSEL_Z, VESSEL_R = -0.30, 3.02, 1.42, 0.58
LASER_X, LASER_R = 0.64, 0.22


def sphere(loc, r, m, scale=(1, 1, 1)):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=40, ring_count=20,
                                         radius=r, location=loc)
    o = bpy.context.object
    o.scale = scale
    o.data.materials.append(m)
    return o


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    # Clean-room grey. Light, so it carries no wear: the shader's grime is a
    # switch, not a dial, and on a light colour it turns a panel into a
    # patchwork of dark blots (docs/blender-renders.md, "Materials"). Kept
    # well under white for the same reason the ochres are dull: this sun is
    # hard, and a whole cabinet of bright paint blows out.
    # The first cut at 0.40 came back as a white pill with no shading on it.
    m['panel'] = mat("panel", (0.250, 0.255, 0.262), 0.50, 0.10)
    m['seam'] = mat("seam", (0.070, 0.074, 0.082), 0.60, 0.20)
    m['band'] = mat("band", (0.012, 0.075, 0.300), 0.40, 0.20)
    # Black and unweathered: with wear the grime ramp turned it into brown
    # marble.
    m['granite'] = mat("granite", (0.030, 0.030, 0.034), 0.28, 0.0)
    m['rail'] = mat("rail", (0.420, 0.410, 0.390), 0.24, 1.0)
    m['chuck'] = mat("chuck", (0.110, 0.110, 0.120), 0.40, 0.80)
    # Polished silicon and its dies, the colours the wafer item wears.
    m['silicon'] = mat("silicon", (0.090, 0.100, 0.150), 0.22, 0.75)
    m['die'] = mat("die", (0.240, 0.180, 0.330), 0.30, 0.60)
    m['vessel'] = mat("vessel", (0.360, 0.350, 0.340), 0.30, 1.0, wear=0.35)
    m['tin'] = mat("tin", (0.520, 0.520, 0.500), 0.28, 1.0)
    m['copper'] = mat("copper", (0.620, 0.300, 0.110), 0.30, 1.0, wear=0.45)
    m['laser'] = mat("laser", (0.080, 0.086, 0.098), 0.48, 0.55, wear=0.55)
    m['glass'] = mat("glass", (0.030, 0.020, 0.035), 0.12, 0.0)
    m['screen'] = mat("screen", (0.020, 0.080, 0.060), 0.30, 0.2,
                      emit=(0.30, 1.00, 0.60), emit_str=1.2)
    m['lamp'] = mat("lamp", (0.030, 0.200, 0.040), 0.30, 0.0,
                    emit=(0.20, 1.00, 0.25), emit_str=1.0)
    m['amber'] = mat("amber", (0.200, 0.120, 0.010), 0.30, 0.0)
    m['redlamp'] = mat("redlamp", (0.200, 0.010, 0.010), 0.30, 0.0)
    # The tin plasma, lit. Blue-violet, not the magma plasma's pink: this is
    # not the reactor's fluid and must not read as a pipe of it.
    m['euv'] = mat("euv", (0.120, 0.060, 0.300), 0.30, 0.0,
                   emit=(0.52, 0.30, 1.00), emit_str=1.25)
    # The ruby window, lit - the same red the laser cutter's rod glows.
    m['ruby'] = mat("ruby", (0.200, 0.004, 0.010), 0.30, 0.0,
                    emit=(1.00, 0.030, 0.050), emit_str=1.10)

    static, moving = [], []
    add = static.append

    def glow(o):
        """A part of the working light: in fr.TINT, so it is left out of the
        entity sheet and becomes the whole of the glow sheet."""
        fr.TINT.append(o)
        static.append(o)

    # --- skid ---------------------------------------------------------------
    add(box(1.94, 7.94, DECK, (0, 0, DECK / 2), m=m['dark']))
    for sy in (-1, 1):
        for sx in (-1, 1):
            add(cyl_at(sx * 0.86, sy * 3.86, DECK + 0.03, 0.06, 0.06,
                       m['steel'], verts=6))

    # --- the wafer stage, south end ------------------------------------------
    # A granite block - a real stage stands on one, for the stiffness - with
    # two rails across it and the chuck riding on them.
    gy = (STAGE_S + STAGE_N) / 2
    add(box(1.78, STAGE_N - STAGE_S, GRANITE_TOP - DECK,
            (0, gy, (GRANITE_TOP + DECK) / 2), m=m['granite']))
    for ry in (STAGE_Y - 0.44, STAGE_Y + 0.44):
        add(box(1.62, 0.07, 0.045, (0, ry, GRANITE_TOP + 0.022),
                m=m['rail']))
    # Two wafer pods at the front corners, lower than the chuck, so they
    # stand in front of the stage without covering it.
    for sx in (-1, 1):
        add(box(0.42, 0.30, 0.26, (sx * 0.62, STAGE_S + 0.20,
                                   GRANITE_TOP + 0.13), m=m['panel']))
        add(box(0.30, 0.02, 0.12, (sx * 0.62, STAGE_S + 0.04,
                                   GRANITE_TOP + 0.13), m=m['seam']))

    # The chuck and its wafer, scanning side to side. Across the sprite, not
    # in and out of it: an X offset survives the projection whole.
    cz = GRANITE_TOP + 0.045
    chuck = [box(0.84, 1.06, 0.09, (0, STAGE_Y, cz + 0.045), m=m['chuck']),
             cyl_at(0, STAGE_Y, cz + 0.10, WAFER_R, 0.02, m['silicon'],
                    verts=48)]
    top = cz + 0.11 + 0.003
    for i in range(-3, 4):
        for j in range(-3, 4):
            x, y = i * 0.095, j * 0.095
            if x * x + y * y < (WAFER_R - 0.06) ** 2:
                chuck.append(box(0.078, 0.078, 0.006,
                                 (x, STAGE_Y + y, top), m=m['die']))
    moving.append(Slide(chuck, axis='X', amplitude=SCAN))

    # The exposure line: the light where it lands, fixed while the wafer
    # runs under it. The only thing above the stage, and it is light.
    glow(box(0.03, 0.44, 0.006, (0, STAGE_Y, top + 0.008), m=m['euv']))

    # --- the low cabinet ------------------------------------------------------
    cy = (CAB_S + CAB_N) / 2
    add(box(1.86, CAB_N - CAB_S, CAB_TOP - DECK,
            (0, cy, (CAB_TOP + DECK) / 2), m=m['panel']))
    add(box(1.88, CAB_N - CAB_S + 0.02, 0.09, (0, cy, 0.86), m=m['band']))
    # The exposure port the stage runs up to, low on the front face, with
    # its throat glowing while the machine prints.
    add(box(1.10, 0.04, 0.18, (0, CAB_S - 0.005, GRANITE_TOP + 0.14),
            m=m['glass']))
    glow(box(1.02, 0.02, 0.10, (0, CAB_S - 0.03, GRANITE_TOP + 0.14),
             m=m['euv']))
    # Operator screen and a stack light on the front corner.
    add(box(0.52, 0.03, 0.22, (-0.48, CAB_S - 0.005, CAB_TOP - 0.36),
            m=m['screen']))
    add(cyl_at(0.74, CAB_S + 0.22, CAB_TOP + 0.05, 0.05, 0.10, m['dark'],
               verts=12))
    for k, lm in enumerate((m['redlamp'], m['amber'], m['lamp'])):
        add(cyl_at(0.74, CAB_S + 0.22, CAB_TOP + 0.14 + 0.075 * k, 0.045,
                   0.07, lm, verts=12))

    # --- the optics tower -----------------------------------------------------
    ty = (TOWER_S + TOWER_N) / 2
    add(box(1.86, TOWER_N - TOWER_S, TOWER_TOP - DECK,
            (0, ty, (TOWER_TOP + DECK) / 2), m=m['panel']))
    add(box(1.88, TOWER_N - TOWER_S + 0.02, 0.09, (0, ty, 0.86),
            m=m['band']))
    # A rounded roof over the optics. Its curve spans X, so it shows facing
    # north and south; turned east or west it is simply the tower's top.
    # Turned about X, the cylinder's local Y is world Z, so scaling it
    # flattens the roof to a low vault 0.30 high.
    roof = cyl_at(0, ty, TOWER_TOP, 0.84, TOWER_N - TOWER_S - 0.20,
                  m['panel'], verts=40, rot=(math.pi / 2, 0, 0))
    roof.scale = (1.0, 0.30 / 0.84, 1.0)
    add(roof)
    # Seams across the vault, so it reads as panels over the optics and not
    # as one smooth pill.
    for k in range(1, 4):
        y = TOWER_S + 0.10 + (TOWER_N - TOWER_S - 0.20) * k / 4
        rib = cyl_at(0, y, TOWER_TOP, 0.85, 0.04, m['seam'], verts=40,
                     rot=(math.pi / 2, 0, 0))
        rib.scale = (1.0, 0.31 / 0.85, 1.0)
        add(rib)

    # Panel seams down both long sides, so the cabinet reads as panels and
    # not as a block whichever side faces the camera.
    for sx in (-1, 1):
        x = sx * 0.935
        for y in (CAB_S + 0.40, CAB_S + 0.80):
            add(box(0.015, 0.025, CAB_TOP - DECK - 0.10,
                    (x, y, (CAB_TOP + DECK) / 2), m=m['seam']))
        for k in range(1, 5):
            y = TOWER_S + (TOWER_N - TOWER_S) * k / 5
            add(box(0.015, 0.025, TOWER_TOP - DECK - 0.10,
                    (x, y, (TOWER_TOP + DECK) / 2), m=m['seam']))
        # Low intake louvres.
        for k in range(4):
            add(box(0.015, 0.36, 0.035,
                    (x, TOWER_S + 0.55, 0.28 + 0.07 * k), m=m['seam']))

    # --- the source, north end ------------------------------------------------
    sy = (SRC_S + SRC_N) / 2
    add(box(1.86, SRC_N - SRC_S, 0.36, (0, sy, DECK + 0.18), m=m['iron']))
    plinth = DECK + 0.36
    # The vacuum vessel, on a ring.
    add(cyl_at(VESSEL_X, VESSEL_Y, plinth + 0.18, 0.30, 0.36, m['steel'],
               verts=32))
    add(sphere((VESSEL_X, VESSEL_Y, VESSEL_Z), VESSEL_R, m['vessel']))
    add(fr.torus_at((VESSEL_X, VESSEL_Y, VESSEL_Z), VESSEL_R + 0.005, 0.035,
                    m['steel'], segments=48))
    # Plasma windows on all four sides, half way up: whichever way the
    # machine faces, one of them looks at the camera.
    for a in range(4):
        h = math.pi / 2 * a
        n = (math.sin(h) * math.sqrt(0.5), -math.cos(h) * math.sqrt(0.5),
             math.sqrt(0.5))
        tilt = (math.radians(45), 0, h)
        for r, lift, mm, fn in ((0.20, 0.00, m['steel'], add),
                                (0.155, 0.012, m['glass'], add),
                                (0.135, 0.024, m['euv'], glow)):
            d = VESSEL_R + lift
            fn(cyl_at(VESSEL_X + n[0] * d, VESSEL_Y + n[1] * d,
                      VESSEL_Z + n[2] * d, r, 0.03, mm, verts=32, rot=tilt))
    # The light goes on into the tower through a short beam duct.
    add(cyl_at(VESSEL_X, (TOWER_N + VESSEL_Y - VESSEL_R) / 2 + 0.05,
               VESSEL_Z - 0.10, 0.13, VESSEL_Y - VESSEL_R - TOWER_N + 0.20,
               m['vessel'], verts=24, rot=(math.pi / 2, 0, 0)))
    add(cyl_at(VESSEL_X, TOWER_N + 0.05, VESSEL_Z - 0.10, 0.18, 0.06,
               m['steel'], verts=24, rot=(math.pi / 2, 0, 0)))
    # The tin droplet generator on top: a column of tin with its heater
    # band, feeding the droplets down into the vessel.
    gz = VESSEL_Z + VESSEL_R - 0.04
    add(cyl_at(VESSEL_X, VESSEL_Y, gz + 0.22, 0.11, 0.44, m['tin'],
               verts=24))
    add(cyl_at(VESSEL_X, VESSEL_Y, gz + 0.18, 0.13, 0.08, m['copper'],
               verts=24))
    add(cyl_at(VESSEL_X, VESSEL_Y, gz + 0.46, 0.14, 0.05, m['steel'],
               verts=24))

    # The laser source, upright on the east side: the part that wears out.
    # A dark housing with the ruby showing through a ring of slots - all the
    # way round, so the red is there in every facing - and a beam tube
    # across into the vessel.
    lz0, lz1 = plinth, plinth + 1.30
    wz, wh = (lz0 + lz1) / 2 + 0.04, 0.62
    add(cyl_at(LASER_X, VESSEL_Y, (lz0 + lz1) / 2, LASER_R, lz1 - lz0,
               m['laser'], verts=28))
    add(cyl_at(LASER_X, VESSEL_Y, lz1 + 0.03, LASER_R + 0.02, 0.06,
               m['steel'], verts=28))
    for z in (lz0 + 0.10, lz1 - 0.12):
        add(cyl_at(LASER_X, VESSEL_Y, z, LASER_R + 0.015, 0.05, m['steel'],
                   verts=28))
    add(cyl_at(LASER_X, VESSEL_Y, wz, LASER_R + 0.004, wh, m['glass'],
               verts=28))
    glow(cyl_at(LASER_X, VESSEL_Y, wz, LASER_R + 0.010, wh - 0.04,
                m['ruby'], verts=28))
    # The slats between the slots. In the glow sheet they are holdouts, so
    # they cut the red ring into windows there too.
    for k in range(8):
        a = 2 * math.pi * (k + 0.5) / 8
        add(box(0.05, 0.035, wh + 0.02,
                (LASER_X + (LASER_R + 0.015) * math.cos(a),
                 VESSEL_Y + (LASER_R + 0.015) * math.sin(a), wz),
                rot=(0, 0, a), m=m['steel']))
    add(cyl_at((LASER_X + VESSEL_X + VESSEL_R) / 2 - 0.02, VESSEL_Y,
               VESSEL_Z, 0.06, LASER_X - VESSEL_X - VESSEL_R + 0.10,
               m['steel'], verts=16, rot=(0, math.pi / 2, 0)))
    return static, moving


fr.run(build, frame_tiles=12)
