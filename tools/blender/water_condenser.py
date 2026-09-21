"""Water condenser - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python water_condenser.py -- \
          --pass entity|shadow --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

An air-cooled steam condenser: steam enters the two finned cooling columns at
the back, a fan pulls air through them, and the condensate collects in the tank
at the front right. Light steel with teal trim and a lit sight glass, so it
reads as the water machine next to the air compressor's dark blue-grey and the
centrifuge's orange.

Deliberately a different silhouette from the air compressor even though both
have a fan: standing disc-finned columns instead of a lying receiver drum, and
a square fan shroud instead of a round drum with a ring guard.

Four things move, at three rates and on two axes: the big intake fan, a small
extractor on top of each cooling column turning the other way, and a drive
wheel standing upright in the gap between the columns. One turning part on a
machine this size reads as a still picture with a detail stuck to it; several,
at different speeds, read as running plant.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at,         # noqa: E402
                             box, MATS, mat, Spin, Slide)


def ring(into, loc, major, minor, material, rot=(0, 0, 0), segments=28):
    """A torus, for a wheel rim the eye reads as spoked rather than solid."""
    bpy.ops.mesh.primitive_torus_add(location=loc, rotation=rot,
                                     major_radius=major, minor_radius=minor,
                                     major_segments=segments, minor_segments=8)
    o = bpy.context.object
    o.data.materials.append(material)
    into.append(o)
    return o

BLADES = 6           # fan blade count; the spin angle must be a multiple of
SPIN = 360 / BLADES  # 360/BLADES for the loop to close
FX, FY = -0.70, -0.66   # fan axis; off-centre, so run() has to be told about it
                        # or the blades orbit the machine instead of spinning

# Blade geometry, kept as constants because the guard has to clear the sweep.
# The pitch tilts the blade about its own Y, so the tip rises by
# (len/2)*sin(pitch); add half the thickness and the bevel for the true top.
BLADE_LEN, BLADE_CHORD, BLADE_THK = 0.48, 0.24, 0.035
PITCH = math.radians(24)
FAN_Z = 0.76
BLADE_TOP = FAN_Z + (BLADE_LEN / 2) * math.sin(PITCH) \
    + (BLADE_THK / 2) * math.cos(PITCH) + 0.012        # ~0.886
GUARD_Z = 0.98                                          # bars clear it by ~4 px

# Column extractors: small, quick, and turning against the main fan. Six thin
# blades, not four fat ones - at 47 px across, four blades on a visible hub
# read as the slot in a screw head rather than as a fan.
EXT_BLADES = 6
EXT_SPIN = 360 / EXT_BLADES
EXT_LEN, EXT_CHORD, EXT_THK = 0.30, 0.13, 0.025
EXT_PITCH = math.radians(22)
EXT_Z = 1.66
EXT_R = 0.17                                            # blade root radius
CAP_TOP = 1.51                                          # column cap, below it
EXT_BOTTOM = (EXT_Z - (EXT_LEN / 2) * math.sin(EXT_PITCH)
              - (EXT_THK / 2) * math.cos(EXT_PITCH) - 0.012)
assert EXT_BOTTOM > CAP_TOP, "extractor blades foul the column cap"

# Condensate pump, standing on the column header. A turning wheel here was
# decoration with no job on a condenser; a ram going up and down is what
# actually shifts condensate, and it gives the machine a motion that is not
# simply a third fan.
PX, PY = 0.0, 0.30
PUMP_STROKE = 0.13                   # amplitude, so the ram travels 0.26
PUMP_BODY_TOP = 1.18
ROD_Z, ROD_LEN = 1.26, 0.64          # at rest
# The rod must never lift clear of its cylinder, or at the top of the stroke
# it hangs in the air with a gap underneath.
assert ROD_Z - ROD_LEN / 2 + PUMP_STROKE < PUMP_BODY_TOP, "pump rod lifts out"
# The pump stands in the same depth band as the fin stacks, so what matters is
# not how far forward it is but whether it fits the gap between them.
PUMP_R = 0.19                        # widest part, the gland
FIN_GAP = 0.74 - 0.52                # fins reach this close to the centre line
assert PUMP_R < FIN_GAP, "pump fouls the cooling fins"


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    # Lighter and cooler than the compressor's shell: this is the water route.
    # Not fully metallic: with only a dim world behind it, a metal=1 vertical
    # face has nothing to reflect and goes near black. Dropping metalness lets
    # the base colour carry the side faces, which is most of this silhouette.
    m['shell'] = mat("shell", (0.300, 0.340, 0.355), 0.42, 0.80, wear=0.55)
    # Muted on purpose. A saturated teal at this size stops reading as painted
    # trim and turns into a flat coloured blob that swallows the detail.
    m['trim'] = mat("trim", (0.040, 0.115, 0.125), 0.40, 0.5, wear=0.25)
    m['water'] = mat("water", (0.020, 0.100, 0.140), 0.20, 0.0,
                     emit=(0.15, 0.62, 1.00), emit_str=2.2)
    m['lamp'] = mat("lamp", (0.030, 0.070, 0.080), 0.30, 0.2,
                    emit=(0.30, 0.85, 1.00), emit_str=2.4)
    static, spin = [], []

    # --- skid base ------------------------------------------------------
    static.append(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    static.append(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['iron']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            static.append(cyl_at(sx * 1.24, sy * 1.24, 0.23, 0.075, 0.08,
                                 m['steel'], verts=6))
    # Teal trim along the front edge instead of the compressor's hazard kerb -
    # the two machines should not share a signature detail.
    for i in range(5):
        static.append(box(0.44, 0.09, 0.07, (-1.10 + i * 0.55, -1.36, 0.21),
                          m=m['trim']))

    # --- cooling columns across the back ---------------------------------
    # Round, not boxed. Next to the compressor a slab-sided machine reads as a
    # crate: the base-game look comes from big curved masses catching the key
    # light. Disc fins on a standing column give that and still say "cooler",
    # and they are nothing like the compressor's lying receiver drum.
    static.append(box(2.56, 0.92, 0.36, (0, 0.88, 0.43), m=m['shell']))
    static.append(box(2.50, 0.05, 0.08, (0, 0.41, 0.52), m=m['trim']))
    for cx in (-0.74, 0.74):
        static.append(cyl_at(cx, 0.88, 1.00, 0.18, 0.92, m['iron'], verts=20))
        # 7 discs, 8 px apart at 64 px/tile. Any denser and they moire.
        for i in range(7):
            static.append(cyl_at(cx, 0.88, 0.68 + i * 0.125, 0.52, 0.05,
                                 m['steel'], verts=32))
        # Wide cap, so the extractor above it has a deck to sit on rather than
        # appearing to hover over the end of the column.
        static.append(cyl_at(cx, 0.88, 1.47, 0.40, 0.08, m['steel'], verts=24))

    # --- fan unit, front left: square shroud on a plinth -----------------
    static.append(box(1.34, 1.34, 0.40, (FX, FY, 0.40), m=m['shell']))
    for sx, sy in ((1, 0), (-1, 0), (0, 1), (0, -1)):        # shroud frame
        static.append(box(1.46 if sy else 0.13, 1.46 if sx else 0.13, 0.40,
                          (FX + sx * 0.665, FY + sy * 0.665, 0.80),
                          m=m['dark']))
    # Top flange as a FRAME, not a plate: a slab here covers the fan entirely
    # and the machine loses the only thing that moves.
    for sx, sy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        static.append(box(1.48 if sy else 0.12, 1.48 if sx else 0.12, 0.05,
                          (FX + sx * 0.68, FY + sy * 0.68, 1.02), m=m['trim']))
    # Guard bars sit above the blade sweep. A bar crossing the blades mid-air
    # reads as broken geometry, which is exactly how the compressor went wrong.
    for i in range(2):
        static.append(box(1.44, 0.07, 0.048, (FX, FY, GUARD_Z),
                          rot=(0, 0, math.pi * i / 2), m=m['dark']))
    static.append(cyl_at(FX, FY, 0.58, 0.20, 0.16, m['dark'], verts=24))
    # Duct tying the fan housing to the column header, so the two masses read
    # as one machine rather than two crates sharing a pallet.
    static.append(box(0.50, 0.46, 0.30, (FX, 0.20, 0.45), m=m['shell']))

    # --- intake fan (animated) -------------------------------------------
    fan = [cyl_at(FX, FY, FAN_Z, 0.16, 0.20, m['steel'], verts=24)]
    for i in range(BLADES):
        a = 2 * math.pi * i / BLADES
        b = box(BLADE_LEN, BLADE_CHORD, BLADE_THK,
                (FX + 0.32 * math.cos(a), FY + 0.32 * math.sin(a), FAN_Z),
                rot=(0, 0, a), m=m['steel'])
        b.rotation_euler[1] = PITCH               # pitch, so the blades bite
        fan.append(b)
    spin.append(Spin(fan, pivot=(FX, FY, 0), degrees=SPIN))

    # --- column extractors (animated) ------------------------------------
    # Opposite sense to each other and to the intake fan. Two identical fans
    # turning in step look like one mechanism duplicated; counter-rotating
    # them makes the machine look assembled rather than copy-pasted.
    for cx, sense in ((-0.74, 1), (0.74, -1)):
        ext = [cyl_at(cx, 0.88, EXT_Z, 0.075, 0.12, m['dark'], verts=12)]
        for i in range(EXT_BLADES):
            a = 2 * math.pi * i / EXT_BLADES
            # Darker than the cap below them, or the blades blow out into one
            # white lump against the light steel deck.
            b = box(EXT_LEN, EXT_CHORD, EXT_THK,
                    (cx + EXT_R * math.cos(a), 0.88 + EXT_R * math.sin(a),
                     EXT_Z), rot=(0, 0, a), m=m['iron'])
            b.rotation_euler[1] = EXT_PITCH
            ext.append(b)
        spin.append(Spin(ext, pivot=(cx, 0.88, 0), degrees=sense * EXT_SPIN))

    # --- condensate pump (animated, reciprocating) ------------------------
    # The one part that does not turn. A Slide eases at both ends of its
    # stroke, so it reads as a crank driving it rather than a part sliding at
    # a constant rate.
    static.append(cyl_at(PX, PY, 0.89, 0.17, 0.58, m['iron'], verts=20))
    ring(static, (PX, PY, 0.63), 0.175, 0.035, m['dark'])       # base collar
    static.append(cyl_at(PX, PY, 1.21, PUMP_R, 0.07, m['dark'], verts=20))
    ram = [cyl_at(PX, PY, ROD_Z, 0.055, ROD_LEN, m['steel'], verts=16)]
    # The crosshead is the part the eye actually tracks, so it carries the
    # trim colour and is sized to be legible at 64 px per tile.
    ram.append(cyl_at(PX, PY, 1.63, 0.14, 0.10, m['trim'], verts=16))
    spin.append(Slide(ram, axis='Z', amplitude=PUMP_STROKE))

    # --- condensate tank, front right ------------------------------------
    TX, TY = 0.82, -0.70
    static.append(cyl_at(TX, TY, 0.62, 0.42, 0.84, m['steel'], verts=32))
    static.append(cyl_at(TX, TY, 1.07, 0.44, 0.06, m['dark'], verts=32))
    for z in (0.36, 0.62, 0.88):
        static.append(cyl_at(TX, TY, z, 0.435, 0.05, m['dark'], verts=32))
    # The lit sight glass is the machine's one strong colour cue: this is the
    # thing on the base that makes water.
    static.append(box(0.09, 0.05, 0.50, (TX, TY - 0.41, 0.62), m=m['water']))
    static.append(cyl_at(TX - 0.52, TY - 0.30, 0.30, 0.07, 0.06, m['lamp'],
                         verts=16, rot=(math.pi / 2, 0, 0)))

    # --- pipework ---------------------------------------------------------
    # Bundle drain down into the tank, then tank out to the south port.
    static.append(cyl_at(TX, 0.06, 0.42, 0.105, 0.76, m['steel'], verts=16,
                         rot=(math.pi / 2, 0, 0)))
    static.append(cyl_at(TX, -0.92, 0.30, 0.105, 0.32, m['steel'], verts=16,
                         rot=(math.pi / 2, 0, 0)))
    static.append(cyl_at(0.47, -1.05, 0.30, 0.105, 0.74, m['steel'], verts=16,
                         rot=(0, math.pi / 2, 0)))

    # --- fluid connections: N in, S out (matches fluid_boxes) ------------
    # The machine carries its own ports and the prototype leaves pipe_picture
    # and pipe_covers off. The vanilla cover is a one-tile sprite drawn on the
    # connection's own tile at +/-1, so it cannot cap a stub that reaches past
    # that tile: it lands as a brass disc floating half a tile up the body.
    # Slim on purpose, so they read as the machine's ports rather than as
    # lengths of vanilla pipe.
    for dx, dy in ((0, 1), (0, -1)):
        ang = math.atan2(dy, dx)
        axis = (math.pi / 2, 0, ang + math.pi / 2)
        static.append(box(0.34, 0.44, 0.40, (dx * 1.05, dy * 1.05, 0.36),
                          rot=(0, 0, ang), m=m['iron']))
        static.append(cyl_at(dx * 1.30, dy * 1.30, 0.36, 0.165, 0.70,
                             m['steel'], verts=24, rot=axis))
        static.append(cyl_at(dx * 1.46, dy * 1.46, 0.36, 0.215, 0.10,
                             m['dark'], verts=24, rot=axis))

    return static, spin


# Each group carries its own angle, and every one of them is a symmetry of its
# own part, so all four close together at frame 16 with no duplicate frames.
fr.run(build)
