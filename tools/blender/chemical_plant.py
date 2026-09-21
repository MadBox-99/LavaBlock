"""Industrialised chemical plant - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python chemical_plant.py -- \
          --pass entity|shadow|tint|icon --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A reactor drum lying across the front, two fractionating columns standing
behind it, and the drive and pipework to tie them together. The horizontal
mass against the two verticals is what makes it read at a glance; three
upright vessels crowded together just read as a lump.

It is the same building from all four sides, which the sprite it replaces was
not: that one was four different plants, each at a camera angle of its own, so
turning the machine rebuilt it.

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

# --- the reactor drum, lying across the front --------------------------
# -Y is towards the camera, so the low horizontal mass goes in front and the
# tall things go behind it. The other way round and the columns hide the drum.
DRUM_Y = -0.70
DRUM_R = 0.34
DRUM_HALF = 0.80                    # half its length along X
DRUM_Z = 0.62

# --- the two columns, standing behind it -------------------------------
# Tall and thin. The first pass had them short and fat with a conical cap and
# they read as two bollards; a fractionating column is slender, hooped along
# its length and flat on top, and that is what carries the silhouette.
COLUMNS = [
    # (x, y, radius, base z, top z) - different heights, so the silhouette
    # is not a matched pair
    (-0.72, 0.46, 0.21, 0.22, 2.36),
    (0.70, 0.46, 0.18, 0.22, 1.94),
]

FAN_BLADES = 6
FAN_SPIN = 360 / FAN_BLADES
FAN_X = -0.32                       # on a pedestal on top of the drum
FAN_Z = DRUM_Z + DRUM_R + 0.36
FAN_LEN, FAN_CHORD, FAN_THK = 0.26, 0.11, 0.022
FAN_PITCH = math.radians(24)
FAN_BOTTOM = (FAN_Z - (FAN_LEN / 2) * math.sin(FAN_PITCH)
              - (FAN_THK / 2) * math.cos(FAN_PITCH) - 0.012)
PEDESTAL_TOP = DRUM_Z + DRUM_R + 0.24
assert FAN_BOTTOM > PEDESTAL_TOP, "drum fan fouls its own pedestal"

EXT_BLADES = 4
EXT_SPIN = 360 / EXT_BLADES

PUMP_X, PUMP_Y = -1.04, 0.04        # left edge, midway, clear of both ports
PUMP_STROKE = 0.10
PUMP_BODY_TOP = 0.62
ROD_Z, ROD_LEN = 0.72, 0.44
assert ROD_Z - ROD_LEN / 2 + PUMP_STROKE < PUMP_BODY_TOP, "pump rod lifts out"

# Ports sit on the tile edges at x = +-1, which is where a deepcopied chemical
# plant puts them: two inputs north, two outputs south.
PORTS = [(-1.0, -1.0), (1.0, -1.0), (-1.0, 1.0), (1.0, 1.0)]
PORT_HALF_X, PORT_HALF_Y = 0.17, 0.22


def clear_of_ports(x, y, rx, ry):
    """True if a footprint clears every port box, so a vessel planted near a
    corner cannot quietly grow through the pipe stub in front of it."""
    for px, py in PORTS:
        if (abs(x - px) < rx + PORT_HALF_X
                and abs(y - py * 1.05) < ry + PORT_HALF_Y):
            return False
    return True


for cx, cy, cr, _, _ in COLUMNS:
    assert clear_of_ports(cx, cy, cr, cr), "column fouls a pipe stub"
assert clear_of_ports(PUMP_X, PUMP_Y, 0.22, 0.20), "pump fouls a pipe stub"
assert clear_of_ports(1.04, -0.04, 0.22, 0.20), "cabinet fouls a pipe stub"
# The drum spans most of the front; check it passes under both columns.
for cx, cy, cr, _, _ in COLUMNS:
    assert abs(cy - DRUM_Y) > cr + DRUM_R or abs(cx) > DRUM_HALF + cr, \
        "reactor drum fouls a column"


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.042, 0.042, 0.039), 0.80, 0.20, wear=0.55)
    # Lighter than the mod's `iron`: three large vessels in the usual dark
    # grey turned the whole machine into one silhouette with no shapes in it.
    m['shell'] = mat("shell", (0.455, 0.440, 0.405), 0.40, 1.0, wear=0.70)
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

    # --- skid base --------------------------------------------------------
    static.append(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    static.append(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            static.append(cyl_at(sx * 1.26, sy * 1.26, 0.23, 0.075, 0.08,
                                 m['steel'], verts=6))

    # `y` is the shell's own surface at the window. The dark recess goes
    # behind it and the liquid pane in front of it, never inside: in the tint
    # pass every non-tinted object is a holdout, so a pane sunk into the shell
    # has all but its rim cut away and renders as a thin ring. PROUD is how
    # far in front the pane sits - enough to clear the shell's curvature
    # across the width of the window, and no more.
    PROUD = 0.022

    def porthole(cx, cy, shell_r, z, r, az):
        """A round window in a vertical shell, `az` radians round from +X.

        Round, because a rectangular pane wrapped on a curved shell reads as a
        collar rather than as glass. Spread several of them around a vessel:
        a window only on the camera-facing side vanishes the moment the
        machine is rotated, and the recipe colour vanishes with it.
        """
        ux, uy = math.cos(az), math.sin(az)
        axis = (math.pi / 2, 0, az + math.pi / 2)
        static.append(cyl_at(cx + ux * (shell_r - 0.05),
                             cy + uy * (shell_r - 0.05), z,
                             r + 0.035, 0.12, m['dark'], verts=18, rot=axis))
        lq = cyl_at(cx + ux * (shell_r + PROUD), cy + uy * (shell_r + PROUD),
                    z, r, 0.03, m['liquid'], verts=18, rot=axis)
        static.append(lq)
        fr.TINT.append(lq)

    def sight_glass(x, y, z, w, h):
        """A rectangular window in the drum's front flank."""
        static.append(box(w + 0.045, 0.12, h + 0.045, (x, y + 0.05, z),
                          m=m['dark']))
        lq = box(w, 0.03, h, (x, y - PROUD, z), m=m['liquid'])
        static.append(lq)
        fr.TINT.append(lq)

    def deck_glass(x, y, z, w, d):
        """A window in the *top* of a vessel. The camera looks down at 45
        degrees, so this one is the only window that cannot be rotated out of
        sight - whichever way the machine faces, the recipe colour shows."""
        static.append(box(w + 0.045, d + 0.045, 0.12, (x, y, z - 0.05),
                          m=m['dark']))
        lq = box(w, d, 0.03, (x, y, z + PROUD), m=m['liquid'])
        static.append(lq)
        fr.TINT.append(lq)

    # --- reactor drum ------------------------------------------------------
    along_x = (0, math.pi / 2, 0)
    static.append(cyl_at(0, DRUM_Y, DRUM_Z, DRUM_R, DRUM_HALF * 2,
                         m['shell'], verts=32, rot=along_x))
    for sx in (-1, 1):
        static.append(cone_at(0, 0, 0, DRUM_R, DRUM_R * 0.5, 0.16,
                              m['shell']))
        cap = bpy.context.object
        cap.rotation_euler = (0, sx * math.pi / 2, 0)
        cap.location = (sx * (DRUM_HALF + 0.08), DRUM_Y, DRUM_Z)
        static.append(cyl_at(sx * 0.52, DRUM_Y, 0.28, 0.14, 0.34,
                             m['dark'], verts=12))       # saddle
    for sx in (-1, 1):
        static.append(torus_at((sx * 0.46, DRUM_Y, DRUM_Z), DRUM_R + 0.014,
                               0.030, m['yellow'], rot=(0, math.pi / 2, 0)))
    sight_glass(0.06, DRUM_Y - DRUM_R, DRUM_Z + 0.02, 0.50, 0.26)
    deck_glass(0.06, DRUM_Y, DRUM_Z + DRUM_R, 0.40, 0.26)

    # Drive on a pedestal on top of the drum: a motor and its cooling fan,
    # the one part of the plant that obviously turns under power.
    static.append(box(0.34, 0.30, 0.24,
                      (FAN_X, DRUM_Y, DRUM_Z + DRUM_R + 0.12), m=m['iron']))
    static.append(cyl_at(FAN_X, DRUM_Y, PEDESTAL_TOP + 0.06, 0.15, 0.12,
                         m['steel'], verts=20))
    fan = [cyl_at(FAN_X, DRUM_Y, FAN_Z, 0.06, 0.09, m['dark'], verts=12)]
    for i in range(FAN_BLADES):
        a = 2 * math.pi * i / FAN_BLADES
        b = box(FAN_LEN, FAN_CHORD, FAN_THK,
                (FAN_X + 0.13 * math.cos(a), DRUM_Y + 0.13 * math.sin(a),
                 FAN_Z), rot=(0, 0, a), m=m['iron'])
        b.rotation_euler[1] = FAN_PITCH
        fan.append(b)
    spin.append(Spin(fan, pivot=(FAN_X, DRUM_Y, 0), degrees=FAN_SPIN))

    # A short relief stack at the other end, so the drum is not symmetrical.
    static.append(cyl_at(0.44, DRUM_Y, DRUM_Z + DRUM_R + 0.20, 0.075, 0.42,
                         m['steel'], verts=14))
    static.append(cyl_at(0.44, DRUM_Y, DRUM_Z + DRUM_R + 0.44, 0.11, 0.07,
                         m['dark'], verts=14))

    # --- fractionating columns --------------------------------------------
    for ci, (cx, cy, cr, cz0, cz1) in enumerate(COLUMNS):
        h = cz1 - cz0
        static.append(cyl_at(cx, cy, (cz0 + cz1) / 2, cr, h,
                             m['shell'], verts=28))
        static.append(cyl_at(cx, cy, cz0 - 0.04, cr + 0.07, 0.12,
                             m['dark'], verts=28))
        # Flat head with a vent off the top, not a cone: a pointed cap is what
        # made these look like bollards.
        static.append(cyl_at(cx, cy, cz1 + 0.035, cr + 0.035, 0.07,
                             m['steel'], verts=28))
        static.append(cyl_at(cx, cy, cz1 + 0.17, 0.05, 0.20, m['steel'],
                             verts=12))
        # Five hoops rather than three: a tall vessel needs enough repeats
        # along it to give the eye a sense of its height.
        for k, f in enumerate((0.12, 0.30, 0.48, 0.66, 0.84)):
            static.append(torus_at(
                (cx, cy, cz0 + h * f), cr + 0.012, 0.024,
                m['yellow'] if k % 2 == 1 else m['dark']))
        # A riser running up the outside, offset so it breaks the outline.
        rax, ray = cx + (cr + 0.055), cy + 0.03
        static.append(cyl_at(rax, ray, cz0 + h * 0.52, 0.042, h * 0.86,
                             m['steel'], verts=10))
        # A walkway ring on the tall column only, for scale.
        if ci == 0:
            static.append(torus_at((cx, cy, cz0 + h * 0.60), cr + 0.13, 0.022,
                                   m['steel']))
        # Three gauge glasses, spaced round the shell and up its height, so
        # one of them always faces the camera whichever way the machine is
        # turned - and they read as level gauges on successive trays.
        for k, (az, f) in enumerate(((-0.5, 0.20), (2.6, 0.42), (1.1, 0.64))):
            porthole(cx, cy, cr, cz0 + h * f, cr * 0.44, az)

    # An extractor on top of the tall column, turning the other way from the
    # drum fan so the two do not read as one drive shaft.
    tx, ty, tr, _, tz1 = COLUMNS[0]
    ext_z = tz1 + 0.07 + 0.22
    static.append(cyl_at(tx, ty, tz1 + 0.07 + 0.09, tr * 0.6, 0.09,
                         m['dark'], verts=16))
    ext = [cyl_at(tx, ty, ext_z, 0.05, 0.08, m['dark'], verts=12)]
    for i in range(EXT_BLADES):
        a = 2 * math.pi * i / EXT_BLADES
        b = box(0.22, 0.09, 0.02,
                (tx + 0.11 * math.cos(a), ty + 0.11 * math.sin(a), ext_z),
                rot=(0, 0, a), m=m['iron'])
        b.rotation_euler[1] = math.radians(22)
        ext.append(b)
    spin.append(Spin(ext, pivot=(tx, ty, 0), degrees=-EXT_SPIN))

    # --- feed ram: nothing else on the machine goes up and down ------------
    static.append(box(0.38, 0.34, 0.50, (PUMP_X, PUMP_Y, 0.37), m=m['iron']))
    static.append(box(0.28, 0.24, 0.08, (PUMP_X, PUMP_Y, PUMP_BODY_TOP),
                      m=m['dark']))
    ram = [cyl_at(PUMP_X, PUMP_Y, ROD_Z, 0.05, ROD_LEN, m['steel'], verts=14)]
    ram.append(cyl_at(PUMP_X, PUMP_Y, ROD_Z + ROD_LEN / 2 + 0.04, 0.12, 0.09,
                      m['yellow'], verts=16))
    spin.append(Slide(ram, axis='Z', amplitude=PUMP_STROKE))

    # --- control cabinet ---------------------------------------------------
    static.append(box(0.40, 0.34, 0.54, (1.04, -0.04, 0.39), m=m['iron']))
    static.append(box(0.24, 0.04, 0.14, (1.04, -0.22, 0.54), m=m['panel']))
    static.append(cyl_at(1.04, -0.04, 0.68, 0.055, 0.10, m['steel'], verts=10))

    # --- pipework tying the vessels together -------------------------------
    for cx, cy, cr, cz0, _ in COLUMNS:
        static.append(bar((cx, cy - cr, cz0 + 0.16),
                          (cx * 0.55, DRUM_Y + DRUM_R, DRUM_Z + 0.08),
                          0.080, m['iron']))
    # Overhead run from the tall column down onto the drum's drive end.
    static.append(bar((COLUMNS[0][0], COLUMNS[0][1] - COLUMNS[0][2], 1.74),
                      (FAN_X - 0.14, DRUM_Y, DRUM_Z + DRUM_R + 0.14),
                      0.070, m['iron']))

    # --- fluid ports: two in at the north edge, two out at the south -------
    # Modelled stubs, not pipe_covers: a one-tile cover sprite cannot meet a
    # stub that reaches past that tile. See docs/blender-renders.md.
    for px, py in PORTS:
        static.append(box(0.34, 0.44, 0.40, (px, py * 1.05, 0.36),
                          m=m['iron']))
        static.append(cyl_at(px, py * 1.30, 0.36, 0.165, 0.70, m['steel'],
                             verts=24, rot=(math.pi / 2, 0, 0)))
        static.append(cyl_at(px, py * 1.46, 0.36, 0.215, 0.10, m['dark'],
                             verts=24, rot=(math.pi / 2, 0, 0)))

    return static, spin


# Both fans turn by a symmetry of their own blade count and the ram closes on
# its own sine, so every group is back where it started on the last frame.
fr.run(build)
