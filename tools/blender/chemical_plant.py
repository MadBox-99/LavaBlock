"""Industrialised chemical plant - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python chemical_plant.py -- \
          --pass entity|shadow|tint|icon --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A miniature refinery on a 3x3 skid: six vessels of different heights and
girths, a spherical accumulator, a pipe rack threading between them, a railed
walkway across the back, ladders, valve wheels and a big elbow dropping to the
front deck.

The density is the point. The sprite this replaces was four entirely
different buildings - one per facing, each at a camera angle of its own - so
turning the machine rebuilt it; but it was a *crowded* picture, and a tidy
model with three vessels on it read as a step backwards however correct it
was. So: the same building from all four sides, and as much plant crammed onto
the skid as 192 pixels will carry.

Like the vanilla chemical plant, the liquid in the sight glasses is its own
sheet and is drawn as a working visualisation, so Factorio multiplies it by
the recipe colour and the windows show whatever is actually being made.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             bar, torus_at, cone_at, MATS, mat, Spin, Slide)

# --- footprint bookkeeping ---------------------------------------------
# Ports sit on the tile edges at x = +-1, which is where a deepcopied chemical
# plant puts them: two inputs north, two outputs south. Their stubs own the
# four corners of the deck, so everything else lives in the central cross.
PORTS = [(-1.0, -1.0), (1.0, -1.0), (-1.0, 1.0), (1.0, 1.0)]
PORT_HALF_X, PORT_HALF_Y = 0.17, 0.22


def clear_of_ports(x, y, rx, ry=None):
    ry = rx if ry is None else ry
    for px, py in PORTS:
        if (abs(x - px) < rx + PORT_HALF_X
                and abs(y - py * 1.05) < ry + PORT_HALF_Y):
            return False
    return True


# --- the vessels -------------------------------------------------------
# (x, y, radius, top z, hoops, kind). -Y is towards the camera, so the tall
# slender things stand at the back and the low fat ones come forward.
#   'column' - hooped tower with a flat head
#   'domed'  - tower with a rounded cap
#   'tank'   - short and fat
BASE_Z = 0.22
TOWERS = [
    (-0.58, 0.62, 0.19, 2.42, 6, 'column'),
    (-0.08, 0.90, 0.145, 1.92, 5, 'domed'),
    (0.52, 0.66, 0.205, 2.18, 6, 'domed'),
    (1.02, 0.18, 0.25, 1.46, 3, 'tank'),
    (-0.52, -0.52, 0.16, 1.12, 3, 'column'),
]
for _x, _y, _r, _t, _h, _k in TOWERS:
    assert clear_of_ports(_x, _y, _r), \
        "tower fouls a pipe stub at %s" % ((_x, _y),)

SPHERE = (-1.02, -0.14, 0.29)           # x, y, radius
SPHERE_Z = 0.88
assert clear_of_ports(SPHERE[0], SPHERE[1], SPHERE[2]), "sphere fouls a stub"

DRUM_X, DRUM_Y = 0.06, -0.86
DRUM_R, DRUM_HALF, DRUM_Z = 0.27, 0.60, 0.60
assert clear_of_ports(DRUM_X, DRUM_Y, DRUM_HALF + 0.10, DRUM_R), \
    "reactor drum fouls a pipe stub"

# --- moving parts ------------------------------------------------------
FAN_BLADES = 6
FAN_SPIN = 360 / FAN_BLADES
FAN_X, FAN_Y = DRUM_X - 0.30, DRUM_Y
FAN_Z = DRUM_Z + DRUM_R + 0.34
FAN_LEN, FAN_CHORD, FAN_THK = 0.24, 0.10, 0.022
FAN_PITCH = math.radians(24)
FAN_BOTTOM = (FAN_Z - (FAN_LEN / 2) * math.sin(FAN_PITCH)
              - (FAN_THK / 2) * math.cos(FAN_PITCH) - 0.012)
PEDESTAL_TOP = DRUM_Z + DRUM_R + 0.22
assert FAN_BOTTOM > PEDESTAL_TOP, "drum fan fouls its own pedestal"

EXT_BLADES = 4
EXT_SPIN = 360 / EXT_BLADES

PUMP_X, PUMP_Y = -1.04, 0.36
PUMP_STROKE = 0.10
PUMP_BODY_TOP = 0.58
ROD_Z, ROD_LEN = 0.68, 0.42
assert ROD_Z - ROD_LEN / 2 + PUMP_STROKE < PUMP_BODY_TOP, "pump rod lifts out"
assert clear_of_ports(PUMP_X, PUMP_Y, 0.20), "pump fouls a pipe stub"

WALK_Z = 1.16                           # railed walkway across the back
RAIL_H = 0.20


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.055, 0.055, 0.052), 0.80, 0.20, wear=0.55)
    # Pale, because the plant this is modelled on is a pale machine. Three
    # vessels in the mod's usual dark grey turned the whole skid into one
    # silhouette with no shapes inside it; six would have been worse.
    m['shell'] = mat("shell", (0.585, 0.575, 0.540), 0.38, 1.0, wear=0.62)
    m['shell2'] = mat("shell2", (0.455, 0.460, 0.450), 0.44, 1.0, wear=0.68)
    m['kerb'] = mat("kerb", (0.375, 0.370, 0.348), 0.54, 0.6, wear=0.62)
    m['panel'] = mat("panel", (0.020, 0.080, 0.060), 0.30, 0.2,
                     emit=(0.30, 1.00, 0.60), emit_str=1.6)
    # The liquid. Near-neutral in its own sheet, because Factorio multiplies
    # that sheet by the recipe colour and leftover hue would fight the tint.
    # The icon is not tinted, so there it gets to look like a chemical.
    m['liquid'] = mat("liquid",
                      (0.780, 0.780, 0.765) if fr.PASS == 'tint'
                      else (0.180, 0.520, 0.420),
                      0.26, 0.0)

    static, spin = [], []
    add = static.append

    # `y` is the shell's own surface at the window. The dark recess goes
    # behind it and the liquid pane in front of it, never inside: in the tint
    # pass every non-tinted object is a holdout, so a pane sunk into the shell
    # has all but its rim cut away and renders as a thin ring.
    PROUD = 0.022

    def porthole(cx, cy, shell_r, z, r, az):
        """A round window in a vertical shell, `az` radians round from +X.
        Spread several around: a window only on the camera-facing side
        vanishes the moment the machine is rotated, and the recipe colour
        goes with it."""
        ux, uy = math.cos(az), math.sin(az)
        axis = (math.pi / 2, 0, az + math.pi / 2)
        add(cyl_at(cx + ux * (shell_r - 0.05), cy + uy * (shell_r - 0.05), z,
                   r + 0.032, 0.12, m['dark'], verts=18, rot=axis))
        lq = cyl_at(cx + ux * (shell_r + PROUD), cy + uy * (shell_r + PROUD),
                    z, r, 0.03, m['liquid'], verts=18, rot=axis)
        add(lq)
        fr.TINT.append(lq)

    def sight_glass(x, y, z, w, h):
        """A rectangular window in the drum's front flank."""
        add(box(w + 0.045, 0.12, h + 0.045, (x, y + 0.05, z), m=m['dark']))
        lq = box(w, 0.03, h, (x, y - PROUD, z), m=m['liquid'])
        add(lq)
        fr.TINT.append(lq)

    def deck_glass(x, y, z, w, d):
        """A window in the *top* of a vessel. The camera looks down at 45
        degrees, so this one cannot be rotated out of sight - whichever way
        the machine faces, the recipe colour shows."""
        add(box(w + 0.045, d + 0.045, 0.12, (x, y, z - 0.05), m=m['dark']))
        lq = box(w, d, 0.03, (x, y, z + PROUD), m=m['liquid'])
        add(lq)
        fr.TINT.append(lq)

    def ladder(x, y, r, z0, z1, az):
        """Two stringers and a set of rungs up the side of a vessel. Almost
        invisible on its own; together with the railings it is what stops the
        towers reading as bare pipes."""
        ux, uy = math.cos(az), math.sin(az)
        px, py = -uy, ux
        for s in (-1, 1):
            add(cyl_at(x + ux * (r + 0.05) + px * s * 0.055,
                       y + uy * (r + 0.05) + py * s * 0.055,
                       (z0 + z1) / 2, 0.016, z1 - z0, m['steel'], verts=6))
        n = max(2, int((z1 - z0) / 0.13))
        for i in range(n):
            z = z0 + (z1 - z0) * (i + 0.5) / n
            add(box(0.11, 0.022, 0.016,
                    (x + ux * (r + 0.05), y + uy * (r + 0.05), z),
                    rot=(0, 0, az + math.pi / 2), m=m['steel']))

    def railing(pts, z, h=RAIL_H):
        """Ochre handrail along a polyline: posts, a top rail and a knee rail.
        The gold lines are most of what makes the reference read as a plant
        rather than as a pile of tanks."""
        # Thin. A handrail is a hairline at 64 px a tile; at the thickness
        # a pipe wants, it reads as a gold bar laid across the machine.
        for x, y in pts:
            add(box(0.024, 0.024, h, (x, y, z + h / 2), m=m['yellow']))
        for a, b in zip(pts, pts[1:]):
            for f in (1.0, 0.56):
                add(bar((a[0], a[1], z + h * f), (b[0], b[1], z + h * f),
                        0.017, m['yellow']))

    def valve(x, y, z, az, r=0.075):
        """A stub with a handwheel. Small, but a handwheel is unmistakably
        process plant."""
        ux, uy = math.cos(az), math.sin(az)
        add(cyl_at(x, y, z, 0.045, 0.16, m['steel'], verts=8,
                   rot=(math.pi / 2, 0, az + math.pi / 2)))
        add(torus_at((x + ux * 0.11, y + uy * 0.11, z), r, 0.018, m['yellow'],
                     rot=(math.pi / 2, 0, az + math.pi / 2)))

    def bend(x, y, ztop, zbend, r, az, run, thick, mt, segs=5):
        """A pipe dropping vertically, turning through a quarter circle and
        running out along `az`. The big elbow on the reference is the one
        piece of silhouette that is not a cylinder, so it is worth the
        segments."""
        ux, uy = math.cos(az), math.sin(az)
        add(cyl_at(x, y, (ztop + zbend) / 2, thick / 2, ztop - zbend,
                   mt, verts=10))
        pts = []
        for i in range(segs + 1):
            t = (math.pi / 2) * i / segs
            pts.append((x + ux * r * (1 - math.cos(t)),
                        y + uy * r * (1 - math.cos(t)),
                        zbend - r * math.sin(t)))
        for a, b in zip(pts, pts[1:]):
            add(bar(a, b, thick, mt))
        ex, ey, ez = pts[-1]
        add(bar((ex, ey, ez), (ex + ux * run, ey + uy * run, ez), thick, mt))

    # --- skid base --------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))
    # A raised kerb round the deck, the way the reference frames its base.
    for sx, sy, w, d in ((0, -1, 2.72, 0.14), (0, 1, 2.72, 0.14),
                         (-1, 0, 0.14, 2.44), (1, 0, 0.14, 2.44)):
        add(box(w, d, 0.10, (sx * 1.29, sy * 1.29, 0.24), m=m['kerb']))
    for i in range(7):                                  # studs along the kerb
        t = -1.10 + i * 0.367
        for sy in (-1, 1):
            add(cyl_at(t, sy * 1.29, 0.30, 0.030, 0.05, m['steel'], verts=6))
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(cyl_at(sx * 1.27, sy * 1.27, 0.23, 0.072, 0.09,
                       m['steel'], verts=6))

    # --- the towers -------------------------------------------------------
    for ti, (tx, ty, tr, top, hoops, kind) in enumerate(TOWERS):
        h = top - BASE_Z
        shell = m['shell'] if ti % 2 == 0 else m['shell2']
        add(cyl_at(tx, ty, (BASE_Z + top) / 2, tr, h, shell, verts=26))
        add(cyl_at(tx, ty, BASE_Z - 0.03, tr + 0.07, 0.13, m['dark'],
                   verts=26))
        if h > 1.6:
            add(cone_at(tx, ty, BASE_Z + 0.04, tr + 0.13, tr + 0.005,
                        h * 0.22, shell))
        if kind == 'domed':
            add(cone_at(tx, ty, top, tr, tr * 0.30, tr * 0.85, shell))
            head = top + tr * 0.85
        elif kind == 'tank':
            add(cone_at(tx, ty, top, tr, tr * 0.55, 0.14, shell))
            add(cyl_at(tx, ty, top + 0.18, tr * 0.55, 0.06, m['dark'],
                       verts=20))
            head = top + 0.21
        else:
            add(cyl_at(tx, ty, top + 0.035, tr + 0.035, 0.07, m['steel'],
                       verts=26))
            head = top + 0.07
        # Hoops. The count varies with the vessel, which is most of what
        # tells the eye that these are five different vessels and not one
        # cylinder stamped out five times.
        for k in range(hoops):
            f = (k + 0.6) / hoops
            add(torus_at((tx, ty, BASE_Z + h * f), tr + 0.012, 0.022,
                         m['yellow'] if k % 2 else m['dark']))
        # A riser up the outside, offset to break the outline.
        add(cyl_at(tx + (tr + 0.05), ty + 0.02, BASE_Z + h * 0.5, 0.036,
                   h * 0.9, m['steel'], verts=8))
        if h > 1.2:
            ladder(tx, ty, tr, BASE_Z + 0.10, min(head, WALK_Z + 0.5),
                   math.radians(200))
        # Vent off the head.
        add(cyl_at(tx, ty, head + 0.09, 0.038, 0.18, m['steel'], verts=8))

    # Gauge glasses spread round the two big towers and the tank, at three
    # azimuths, so one always faces the camera whichever way the machine is
    # turned - and they read as level gauges on successive trays.
    for (tx, ty, tr, top, _h, _k), azs in (
            (TOWERS[0], (-0.6, 2.4)), (TOWERS[2], (-1.1, 1.9)),
            (TOWERS[3], (-0.9,))):
        for j, az in enumerate(azs):
            f = 0.28 + 0.26 * j
            porthole(tx, ty, tr, BASE_Z + (top - BASE_Z) * f, tr * 0.42, az)

    # --- the spherical accumulator ----------------------------------------
    sx, sy, sr = SPHERE
    bpy.ops.mesh.primitive_uv_sphere_add(radius=sr, segments=24, ring_count=12,
                                         location=(sx, sy, SPHERE_Z))
    sph = bpy.context.object
    sph.data.materials.append(m['shell'])
    add(sph)
    add(torus_at((sx, sy, SPHERE_Z), sr + 0.012, 0.024, m['yellow']))
    for i in range(4):                                   # its legs
        a = math.pi / 4 + i * math.pi / 2
        add(cyl_at(sx + sr * 0.66 * math.cos(a), sy + sr * 0.66 * math.sin(a),
                   (BASE_Z + SPHERE_Z) / 2, 0.038, SPHERE_Z - BASE_Z,
                   m['steel'], verts=8))

    # --- reactor drum across the front ------------------------------------
    along_x = (0, math.pi / 2, 0)
    add(cyl_at(DRUM_X, DRUM_Y, DRUM_Z, DRUM_R, DRUM_HALF * 2, m['shell'],
               verts=30, rot=along_x))
    for s in (-1, 1):
        cap = cone_at(0, 0, 0, DRUM_R, DRUM_R * 0.5, 0.14, m['shell'])
        cap.rotation_euler = (0, s * math.pi / 2, 0)
        cap.location = (DRUM_X + s * (DRUM_HALF + 0.07), DRUM_Y, DRUM_Z)
        add(cap)
        add(box(0.16, 0.30, DRUM_Z - BASE_Z,
                (DRUM_X + s * 0.40, DRUM_Y, (BASE_Z + DRUM_Z) / 2),
                m=m['dark']))                              # saddle
        add(torus_at((DRUM_X + s * 0.40, DRUM_Y, DRUM_Z), DRUM_R + 0.014,
                     0.026, m['yellow'], rot=along_x))
    sight_glass(DRUM_X + 0.04, DRUM_Y - DRUM_R, DRUM_Z + 0.02, 0.46, 0.24)
    deck_glass(DRUM_X + 0.22, DRUM_Y, DRUM_Z + DRUM_R, 0.30, 0.24)

    # Drive on a pedestal on the drum: a motor and its cooling fan.
    add(box(0.32, 0.28, 0.22, (FAN_X, FAN_Y, DRUM_Z + DRUM_R + 0.11),
            m=m['iron']))
    add(cyl_at(FAN_X, FAN_Y, PEDESTAL_TOP + 0.06, 0.14, 0.12, m['steel'],
               verts=20))
    fan = [cyl_at(FAN_X, FAN_Y, FAN_Z, 0.055, 0.09, m['dark'], verts=12)]
    for i in range(FAN_BLADES):
        a = 2 * math.pi * i / FAN_BLADES
        b = box(FAN_LEN, FAN_CHORD, FAN_THK,
                (FAN_X + 0.12 * math.cos(a), FAN_Y + 0.12 * math.sin(a),
                 FAN_Z), rot=(0, 0, a), m=m['iron'])
        b.rotation_euler[1] = FAN_PITCH
        fan.append(b)
    spin.append(Spin(fan, pivot=(FAN_X, FAN_Y, 0), degrees=FAN_SPIN))

    # An extractor on the tallest tower, turning the other way, so the two do
    # not read as one drive shaft.
    tx, ty, tr, ttop = TOWERS[0][0], TOWERS[0][1], TOWERS[0][2], TOWERS[0][3]
    ext_z = ttop + 0.07 + 0.20
    add(cyl_at(tx, ty, ttop + 0.07 + 0.08, tr * 0.62, 0.08, m['dark'],
               verts=16))
    ext = [cyl_at(tx, ty, ext_z, 0.045, 0.07, m['dark'], verts=12)]
    for i in range(EXT_BLADES):
        a = 2 * math.pi * i / EXT_BLADES
        b = box(0.20, 0.085, 0.02,
                (tx + 0.10 * math.cos(a), ty + 0.10 * math.sin(a), ext_z),
                rot=(0, 0, a), m=m['iron'])
        b.rotation_euler[1] = math.radians(22)
        ext.append(b)
    spin.append(Spin(ext, pivot=(tx, ty, 0), degrees=-EXT_SPIN))

    # --- circular galleries round the two big towers -----------------------
    # A straight walkway across the back was the first thing tried here and it
    # laid a solid horizontal slab across the middle of the machine, cutting
    # the silhouette in half. The reference hangs round galleries off its
    # stacks instead, which reads as plant without blocking anything.
    #
    # These are not checked against the port stubs: they overhang the deck
    # corners in plan, but they sit at 1.1 to 1.4 tiles up and the stubs top
    # out below 0.6, so nothing actually meets.
    def gallery(gx, gy, gr, gz, posts=6):
        add(cyl_at(gx, gy, gz, gr + 0.17, 0.035, m['kerb'], verts=24))
        add(torus_at((gx, gy, gz + 0.19), gr + 0.17, 0.016, m['yellow']))
        add(torus_at((gx, gy, gz + 0.10), gr + 0.17, 0.013, m['yellow']))
        for i in range(posts):
            a = 2 * math.pi * i / posts
            add(box(0.022, 0.022, 0.20,
                    (gx + (gr + 0.17) * math.cos(a),
                     gy + (gr + 0.17) * math.sin(a), gz + 0.10),
                    rot=(0, 0, a), m=m['yellow']))
        # Three brackets under it, so it does not float.
        for i in range(3):
            a = 2 * math.pi * i / 3 - 0.4
            add(bar((gx + gr * math.cos(a), gy + gr * math.sin(a), gz - 0.22),
                    (gx + (gr + 0.16) * math.cos(a),
                     gy + (gr + 0.16) * math.sin(a), gz - 0.015),
                    0.025, m['steel']))

    gallery(TOWERS[0][0], TOWERS[0][1], TOWERS[0][2], 1.42)
    gallery(TOWERS[2][0], TOWERS[2][1], TOWERS[2][2], 1.08)

    # --- pipe rack threading between the vessels ---------------------------
    for i, pz in enumerate((0.58, 0.72, 0.86)):
        add(cyl_at(0.02, -0.28, pz, 0.045 + 0.008 * i, 2.30, m['steel'],
                   verts=10, rot=(0, math.pi / 2, 0)))
    for px in (-0.86, 0.86):                             # trestles
        add(box(0.07, 0.07, 0.74, (px, -0.28, BASE_Z + 0.37), m=m['iron']))
        add(box(0.30, 0.07, 0.06, (px, -0.28, 0.94), m=m['iron']))
    valve(-0.30, -0.28, 0.86, math.radians(-90))
    valve(0.46, -0.28, 0.72, math.radians(-90))

    # The big elbow: down off the tall tower's head and out across the deck.
    bend(TOWERS[2][0] + TOWERS[2][2] + 0.14, TOWERS[2][1] - 0.06, 1.92, 0.62,
         0.28, math.radians(-78), 0.46, 0.085, m['steel'])
    # Short runs tying the sphere and the small tower into the rack.
    add(bar((sx + sr * 0.8, sy, 0.72), (-0.52, -0.28, 0.72), 0.070,
            m['iron']))
    add(bar((TOWERS[4][0], TOWERS[4][1] - TOWERS[4][2], 0.86),
            (DRUM_X - 0.30, DRUM_Y + DRUM_R, DRUM_Z + 0.10), 0.065,
            m['iron']))

    # --- feed ram: nothing else on the machine goes up and down ------------
    add(box(0.34, 0.30, 0.46, (PUMP_X, PUMP_Y, 0.35), m=m['iron']))
    add(box(0.26, 0.22, 0.07, (PUMP_X, PUMP_Y, PUMP_BODY_TOP), m=m['dark']))
    ram = [cyl_at(PUMP_X, PUMP_Y, ROD_Z, 0.045, ROD_LEN, m['steel'],
                  verts=14)]
    ram.append(cyl_at(PUMP_X, PUMP_Y, ROD_Z + ROD_LEN / 2 + 0.04, 0.11, 0.08,
                      m['yellow'], verts=16))
    spin.append(Slide(ram, axis='Z', amplitude=PUMP_STROKE))

    # --- control cabinet ---------------------------------------------------
    add(box(0.36, 0.30, 0.48, (1.04, -0.42, 0.36), m=m['iron']))
    add(box(0.22, 0.04, 0.13, (1.04, -0.58, 0.48), m=m['panel']))
    add(cyl_at(1.04, -0.42, 0.63, 0.05, 0.09, m['steel'], verts=10))

    # --- fluid ports -------------------------------------------------------
    # Modelled stubs, not pipe_covers: a one-tile cover sprite cannot meet a
    # stub that reaches past that tile. See docs/blender-renders.md.
    for px, py in PORTS:
        add(box(0.34, 0.44, 0.40, (px, py * 1.05, 0.36), m=m['iron']))
        add(cyl_at(px, py * 1.30, 0.36, 0.165, 0.70, m['steel'], verts=24,
                   rot=(math.pi / 2, 0, 0)))
        add(cyl_at(px, py * 1.46, 0.36, 0.215, 0.10, m['dark'], verts=24,
                   rot=(math.pi / 2, 0, 0)))

    return static, spin


# Both fans turn by a symmetry of their own blade count and the ram closes on
# its own sine, so every group is back where it started on the last frame.
fr.run(build)
