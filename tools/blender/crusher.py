"""Crusher - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python crusher.py -- \
          --pass entity|shadow|icon --direction north --frames 32 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A double-roll crusher: two toothed rolls standing side by side and turning
towards each other, with the rock going down the nip between them and the
product falling out of the slot onto an apron at the front.

Two rolls, not a jaw and a screen. One drum turning is a mixer, a kiln or a
washer - the shape says nothing about what the machine does to what is
inside it. Two of them turning towards each other say it in one frame: the
gap between them is the whole machine, and anything that goes in comes out
smaller.

The rolls stand apart along X and their axes run back into the scene. Laid
the other way - axes across the sprite, one roll in front of the other -
they cannot be told apart: at this camera a half-metre of separation in Y
is only 0.7 of separation on screen, less than the two diameters, so the
near roll eats the far one and the pair reads as a single studded slab.
That was the first version of this model and it was unusable. Side by side
the separation is horizontal, it survives the projection untouched, and the
nip is a clean dark slot straight down the middle of the sprite.

Teeth, not holes. A drilled wall is a screen, and on the rolls that do the
crushing it would be wrong twice over - it is not what a roll crusher looks
like, and a hole reads as empty where a tooth reads as bite. Turning about
an axis pointing away from the camera, the teeth also sweep across the
sprite rather than along it, which is the most legible motion this camera
can be given.

Each roll is driven by an engine outboard of its bearing: an eccentric on
the shaft, a connecting rod with a round big end wrapping it, and a
crosshead running in a cylinder that leans out into the corner of the
sprite. Teeth alone leave the direction ambiguous - a repeating pattern
going round could be going either way - and two rods swinging in mirror
image settle it in one frame. They cost the cheap wrap: an eccentric has no
symmetry, so the sheet closes on a whole turn rather than on one tooth
pitch, which is what sets the frame count at 32.

Nothing is drawn over the rolls. A real roll crusher is fed through a
hopper that covers them completely, and at this camera angle any hopper
loses its taper and reads as a plain box laid on top of the machine -
which is exactly the wrong thing to put over the only two parts that say
what the machine is.

Solids in, solids out: lava is quenched into basalt in a chemical plant
before it ever reaches this machine, so the burner and electric variants
carry no pipe stubs at all - which by itself says they belong to a
different part of the factory. Only the industrial variant has a port, at
the back centre, for the lubricant its recipes want.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, box,    # noqa: E402
                             bar, torus_at, MATS, mat, Spin, Rod, Piston)

DECK_TOP = 0.205
EDGE = 1.36                     # the deck's half width; nothing may cross it

# Three machines out of one model. Everything that says "roll crusher" - the
# skid, the rolls, the bearings, the engines, the apron - is shared, and each
# variant only adds what tells it apart, on the drive bed at the back where
# there is room. Rendering three whole models instead would be three times
# the work to draw the same two rolls three times.
VARIANT = fr.arg('--variant', 'electric')
assert VARIANT in ('burner', 'electric', 'industrial'), VARIANT

# Each tier is painted differently, because the chimney, the motor and the
# oil tank that tell them apart are a few pixels across once the machine is
# sitting on the ground among others. Colour is the only difference that
# survives at that size, and three identical grey machines in a row is the
# complaint this answers.
#
# Only the casing changes - the bed, the switchgear, the bearing housings and
# the engine cylinders. The rolls and their teeth stay the same steel in all
# three, because they are the part that says "crusher", and a red one and a
# yellow one with different rolls would read as two unrelated machines rather
# than two tiers of one.
#
# Dark rust, neutral steel, bright ochre: the three differ in value as well as
# in hue, so they stay apart in a screenshot, at night and for a colourblind
# player. The ochre is deliberately duller than the mod's `yellow` - a whole
# machine body in that paint blows out under this sun.
CASE = {
    'burner':     ((0.215, 0.132, 0.086), 0.70, 0.88, 0.86),
    'electric':   ((0.235, 0.224, 0.210), 0.62, 1.00, 0.78),
    'industrial': ((0.385, 0.282, 0.072), 0.54, 0.66, 0.80),
}

# --- the two rolls -------------------------------------------------------
ROLL_R = 0.38
ROLL_TOOTH = 0.06               # how far a tooth stands off the barrel
ROLL_OUT = ROLL_R + ROLL_TOOTH
ROLL_LEN = 1.34
ROLL_Z = 0.78
ROLL_Y = -0.18                  # centre of the barrels, front to back
ROLL_SEP = 1.04                 # centre to centre, across the sprite
ROLL_X = ROLL_SEP / 2
ROLL_TEETH = 12                 # columns of teeth round each barrel
ROLL_ROWS = 6                   # rows of teeth along it

# A whole turn per sheet, not one tooth pitch. The crank on the end of each
# roll is a single arm, so there is no symmetry left to hide behind - the
# only angle the sheet closes on is 360.
#
# That in turn caps the tooth count. A tooth must not advance more than
# about four tenths of its own pitch between frames, or the eye reads the
# pattern as crawling backwards, and the step is exactly ROLL_TEETH/FRAMES
# of a pitch. So teeth and frames are one decision: 12 teeth wants 32
# frames, and dropping back to 16 would mean 6 teeth and a bald roll.
ROLL_SPIN = 360.0
assert ROLL_SPIN % 360 == 0, "a cranked roll must close on a whole turn"
if fr.FRAMES > 1:               # the icon pass renders a single frame
    assert ROLL_TEETH / fr.FRAMES < 0.45, \
        "too many teeth for this frame count - they will strobe backwards"
NIP = ROLL_SEP - 2 * ROLL_OUT
assert NIP > 0.10, "the rolls' teeth run into each other"
assert NIP < 0.26, "the nip is so wide the rock would fall straight through"
assert ROLL_Z - ROLL_OUT > DECK_TOP + 0.10, "the rolls scrape the deck"
assert ROLL_X + ROLL_OUT < EDGE, "the rolls overhang the skid"
assert abs(ROLL_Y) + ROLL_LEN / 2 + 0.20 < EDGE, \
    "no room in front of the rolls for their bearings"

BLOCK_Y = ROLL_Y - ROLL_LEN / 2 - 0.10      # pillow blocks, at the near ends

# --- engine on each roll, outboard of its bearing ------------------------
# An eccentric rather than a crank web: the disc rides the shaft with its
# centre thrown off the axis, and the rod's round big end wraps the disc
# directly. Same motion as a crank pin, but there is no arm - which is the
# point, because an arm is what this drive was mistaken for the first time.
ECC_Y = BLOCK_Y - 0.23          # clear of the bearing cap and its bolts
ECC_R = 0.13                    # the eccentric disc
ECC_THROW = 0.20                # how far its centre sits off the axis
ROD_LEN = 0.52

# The bores lean outwards, into the two lower corners of the sprite, where
# there is nothing. Straight up was tried first and the cylinder landed on
# the roll's near end and read as a bolt head; laid flat it ran off the
# skid. Leaning it puts the barrel in empty deck and still leaves the rod
# swinging in the open in front of the bearing.
BORE_TILT = math.radians(38)
_UZ, _UX = math.cos(BORE_TILT), math.sin(BORE_TILT)
_ROOT = math.sqrt(ROD_LEN ** 2 - ECC_THROW ** 2 + (_UZ * ECC_THROW) ** 2)
T_NEAR = _ROOT - _UZ * ECC_THROW        # small end, closest to the shaft
T_FAR = _ROOT + _UZ * ECC_THROW         # and furthest: the rest pose
CYL_R, CYL_T0, CYL_T1 = 0.14, 0.56, 0.94    # the barrel, measured up the bore

assert ROD_LEN > ECC_THROW + 0.10, "the rod is too short to swing the shaft"
assert ECC_R + ECC_THROW < ROLL_OUT, "the eccentric swings wider than the roll"
assert ROLL_Z - ECC_THROW - ECC_R > DECK_TOP + 0.10, \
    "the eccentric scrapes the deck at the bottom of its turn"
assert CYL_T0 < T_FAR, "the crosshead never reaches into the cylinder"
assert CYL_T0 > T_NEAR + 0.10, "the crosshead never comes out of the cylinder"
assert CYL_T1 > T_FAR + 0.14, "the crosshead punches through the cylinder head"
assert ROLL_X + CYL_T1 * _UX + CYL_R * _UZ < EDGE, \
    "the cylinder overhangs the side of the skid"
assert ECC_Y - CYL_R > -EDGE, "the engine hangs over the front of the skid"

# Nothing stands over the nip. There were two goes at a feed funnel up here,
# a round one and then a square one, and neither survived being looked at:
# from 45 degrees above, the taper is the one part of a funnel you cannot
# see, so what is left is a lidded box sitting on top of the only two parts
# of the machine worth looking at. The slot stays open to the sky.

# --- drive bed across the back -------------------------------------------
BED_Y, BED_SY, BED_TOP = 0.92, 0.70, 0.66
assert BED_Y - BED_SY / 2 > ROLL_Y + ROLL_LEN / 2, "the bed is inside the rolls"
assert BED_Y + BED_SY / 2 < EDGE, "the bed overhangs the skid"

WHEEL_X, WHEEL_Y, WHEEL_Z = -1.00, 0.86, 0.98
WHEEL_R = 0.33
WHEEL_SPOKES = 6
# Belted to the rolls one for one, so it turns at the same rate they do.
WHEEL_SPIN = 360.0
assert WHEEL_Z - WHEEL_R >= BED_TOP - 0.04, "the flywheel is buried in the bed"
assert abs(WHEEL_X) + WHEEL_R < EDGE, "the flywheel overhangs the skid"

MOTOR_X, MOTOR_Y, MOTOR_Z = 0.66, 0.90, 0.88
MOTOR_R, MOTOR_LEN = 0.19, 0.76
assert MOTOR_X - MOTOR_LEN / 2 > WHEEL_X + WHEEL_R, \
    "the motor and the flywheel are in the same place"

CHUTE_Y = -0.86                 # under the slot, running out to the front

# Switchgear on the near left, where the deck would otherwise be bare: the
# rolls reach 0.96 across and the skid 1.36, and everything else that
# stands proud of the deck - the bed, the motor - is off to the right.
CAB_X, CAB_Y, CAB_W, CAB_TOP = -1.14, -0.62, 0.28, 0.84
assert CAB_X - CAB_W / 2 > -EDGE, "the cabinet overhangs the skid"
assert CAB_X + CAB_W / 2 < -(ROLL_X + ROLL_OUT), \
    "the cabinet is inside the left roll"


def toothed_roll(cx, m, m_tooth, spin_sign):
    """One crushing roll, axis along Y, teeth and all.

    Built straight into world space rather than at the origin and stood up
    afterwards: the teeth carry a rotation of their own, and re-posing the
    finished parts would throw it away.

    Alternate rows step half a pitch round, which stops the teeth lining up
    into stripes down the barrel. Since the sheet closes on a whole turn it
    costs nothing; back when it closed on one tooth pitch it was free too,
    because a turn of one pitch maps every row onto itself whatever phase
    it was given.
    """
    lie = (math.pi / 2, 0, 0)           # lay the Z-axis primitives along Y
    parts = [cyl_at(cx, ROLL_Y, ROLL_Z, ROLL_R, ROLL_LEN, m, verts=32,
                    rot=lie)]
    for i in range(ROLL_ROWS):
        y = ROLL_Y - ROLL_LEN / 2 + ROLL_LEN * (i + 0.5) / ROLL_ROWS
        phase = (math.pi / ROLL_TEETH) if i % 2 else 0.0
        for k in range(ROLL_TEETH):
            a = 2 * math.pi * k / ROLL_TEETH + phase
            # rot=(0, a, 0) leaves local Y along the barrel and swings local
            # Z out to the radius, so the box reads (width, axial, radial).
            parts.append(box(ROLL_TOOTH * 1.15,
                             ROLL_LEN / ROLL_ROWS * 0.52,
                             ROLL_TOOTH * 2.0,
                             (cx + ROLL_R * math.sin(a), y,
                              ROLL_Z + ROLL_R * math.cos(a)),
                             rot=(0, a, 0), m=m_tooth))
    for sy in (-1, 1):
        parts.append(torus_at((cx, ROLL_Y + sy * (ROLL_LEN / 2 + 0.03),
                               ROLL_Z), ROLL_R + 0.05, 0.045, MATS['steel'],
                              rot=lie))
    # A machined flange and hub over the near end. Bare, the barrel's end
    # cap faces down and away from the sun and comes out as a flat black
    # disc the size of the roll - two of them side by side read as tyres,
    # not as the ends of something turning.
    ny = ROLL_Y - ROLL_LEN / 2
    parts.append(cyl_at(cx, ny - 0.05, ROLL_Z, ROLL_R * 0.76, 0.06,
                        MATS['steel'], verts=24, rot=lie))
    parts.append(cyl_at(cx, ny - 0.11, ROLL_Z, 0.11, 0.10, MATS['steel'],
                        verts=12, rot=lie))

    # --- shaft and eccentric, outboard of the bearing ---------------------
    # Rotating about Y, y does not enter the rotation at all, so an eccentric
    # set well in front of the barrel still orbits the barrel's own axis.
    parts.append(cyl_at(cx, ECC_Y + 0.17, ROLL_Z, 0.06, 0.40,
                        MATS['steel'], verts=12, rot=lie))
    # Case grey, not steel. The disc spends half its turn in front of the
    # roll's own flange, which is bright steel too, and steel on steel
    # disappears for exactly the half of the cycle where the motion most
    # needs to be read.
    parts.append(cyl_at(cx, ECC_Y, ROLL_Z + ECC_THROW, ECC_R, 0.09,
                        MATS['case'], verts=24, rot=lie))
    return Spin(parts, pivot=(cx, ROLL_Y, ROLL_Z), axis='Y',
                degrees=spin_sign * ROLL_SPIN)


def engine(cx, sign):
    """The drive on one roll: cylinder, connecting rod and crosshead.

    Returns (static parts, Rod group, Piston group). The rod and the
    crosshead are separate groups because the rod tilts as it goes and the
    crosshead does not - but both are solved from the same slider-crank, so
    they cannot drift apart, and both take the roll's own `sign` so the big
    end stays on its eccentric.

    Everything is modelled where frame 0 puts it. Rod wants its shank drawn
    straight up from the big end whatever the bore does - the empty carries
    the tilt - so only the length has to be right here.
    """
    out = 1 if cx > 0 else -1               # which way this bore leans
    bore = (out * _UX, _UZ)
    tilt = (0, out * BORE_TILT, 0)
    centre = (cx, ECC_Y, ROLL_Z)

    def at(t):                              # a point t along the bore
        return (cx + out * t * _UX, ECC_Y, ROLL_Z + t * _UZ)

    big = ROLL_Z + ECC_THROW
    rod = [torus_at((cx, ECC_Y, big), ECC_R + 0.045, 0.042, MATS['steel'],
                    rot=(math.pi / 2, 0, 0))]
    z1, z2 = big + ECC_R * 0.7, big + ROD_LEN
    rod.append(box(0.085, 0.08, z2 - z1, (cx, ECC_Y, (z1 + z2) / 2),
                   m=MATS['steel']))
    rod.append(cyl_at(cx, ECC_Y, z2, 0.055, 0.11, MATS['steel'], verts=12,
                      rot=(math.pi / 2, 0, 0)))

    sx, _, sz = at(T_FAR)
    piston = [box(0.19, 0.13, 0.15, (sx, ECC_Y, sz), rot=tilt,
                  m=MATS['steel'])]

    mid = at((CYL_T0 + CYL_T1) / 2)
    st = [cyl_at(mid[0], ECC_Y, mid[2], CYL_R, CYL_T1 - CYL_T0,
                 MATS['case'], verts=24, rot=tilt)]
    head = at(CYL_T1 + 0.03)
    st.append(cyl_at(head[0], ECC_Y, head[2], CYL_R + 0.035, 0.07,
                     MATS['steel'], verts=24, rot=tilt))
    gland = at(CYL_T0 - 0.02)
    st.append(cyl_at(gland[0], ECC_Y, gland[2], CYL_R + 0.025, 0.05,
                     MATS['steel'], verts=24, rot=tilt))
    # Two bands, not a stack of fins. Evenly spaced rings on a leaning
    # barrel read as a screw thread at sprite size.
    for t in (0.34, 0.70):
        b = at(CYL_T0 + (CYL_T1 - CYL_T0) * t)
        st.append(cyl_at(b[0], ECC_Y, b[2], CYL_R + 0.02, 0.03,
                         MATS['steel'], verts=24, rot=tilt))
    # Struts back to the bearing housing rather than a post to the deck: a
    # post would stand up the front of the roll, and a bar in front of the
    # barrel is the one thing this model keeps having to be rid of.
    foot = at(CYL_T0 + 0.06)
    for t in (-1, 1):
        st.append(bar((foot[0] + t * 0.10, ECC_Y + 0.03, foot[2]),
                      (cx + t * 0.15, BLOCK_Y + 0.02, ROLL_Z + 0.06), 0.035,
                      MATS['steel']))
    return (st,
            Rod(rod, centre, ECC_THROW, ROD_LEN, sign=sign, bore=bore),
            Piston(piston, centre, ECC_THROW, ROD_LEN, sign=sign, bore=bore))


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.050, 0.048, 0.046), 0.80, 0.20, wear=0.55)
    m['case'] = mat("case", *CASE[VARIANT][:3], wear=CASE[VARIANT][3])
    m['roll'] = mat("roll", (0.300, 0.290, 0.280), 0.50, 1.0, wear=0.70)
    # The teeth are brighter than the barrel they stand on. Same grey and
    # the toothed roll silhouettes into a plain cylinder at sprite size.
    m['tooth'] = mat("tooth", (0.430, 0.418, 0.400), 0.32, 1.0, wear=0.55)
    # Crushed rock. No recipe tints it - the crusher makes one thing - so it
    # keeps its real colour in every pass.
    m['rock'] = mat("rock", (0.125, 0.117, 0.122), 0.85, 0.0, wear=0.20)
    m['panel'] = mat("panel", (0.070, 0.050, 0.015), 0.30, 0.2,
                     emit=(1.00, 0.62, 0.18), emit_str=0.9)

    static, spin = [], []
    add = static.append

    # --- skid base --------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(cyl_at(sx * 1.26, sy * 1.26, 0.23, 0.075, 0.08, m['steel'],
                       verts=6))

    # --- discharge, under the slot and out to the front -------------------
    # Laid before the rolls so it is clearly beneath them: the rock drops
    # through the nip, lands on this and runs out where it can be seen.
    # Kept short and pushed forward. Run back under the rolls it sits in
    # their shadow all day and the only loose rock on the machine is lost.
    add(box(0.66, 0.82, 0.06, (0, CHUTE_Y, 0.31), rot=(0.34, 0, 0),
            m=m['steel']))
    for sx in (-0.32, 0.32):
        add(box(0.05, 0.82, 0.13, (sx, CHUTE_Y, 0.36), rot=(0.34, 0, 0),
                m=m['steel']))
    for i, (rx, ry) in enumerate(((-0.18, -0.24), (0.07, -0.32),
                                  (0.22, -0.18), (-0.03, -0.12))):
        add(cyl_at(rx, CHUTE_Y + ry, 0.27, 0.06, 0.08, m['rock'], verts=6,
                   rot=(0, 0, i * 0.8)))

    # --- the two rolls (animated, towards each other) ---------------------
    # About Y, the left roll's inner face comes down for positive degrees
    # and the right roll's for negative: opposite signs is the whole of it.
    for cx, sign in ((-ROLL_X, +1), (+ROLL_X, -1)):
        spin.append(toothed_roll(cx, m['roll'], m['tooth'], sign))
        st, rod, piston = engine(cx, sign)
        static.extend(st)
        spin.append(rod)
        spin.append(piston)

    # --- pillow blocks at the near ends -----------------------------------
    lie = (math.pi / 2, 0, 0)
    for sx in (-1, 1):
        cx = sx * ROLL_X
        add(box(0.34, 0.16, ROLL_Z - DECK_TOP,
                (cx, BLOCK_Y, (DECK_TOP + ROLL_Z) / 2), m=m['case']))
        add(cyl_at(cx, BLOCK_Y - 0.12, ROLL_Z, 0.17, 0.10, m['steel'],
                   verts=20, rot=lie))
        for k in range(6):
            a = 2 * math.pi * k / 6
            add(cyl_at(cx + 0.12 * math.sin(a), BLOCK_Y - 0.18,
                       ROLL_Z + 0.12 * math.cos(a), 0.024, 0.04, m['dark'],
                       verts=6, rot=lie))
    # --- switchgear, near left --------------------------------------------
    add(box(CAB_W, 0.40, CAB_TOP - DECK_TOP,
            (CAB_X, CAB_Y, (DECK_TOP + CAB_TOP) / 2), m=m['case']))
    # A steel cap here came out as a sheet of white paper: it is a small
    # horizontal face high on the machine and this sun hits it flat on.
    add(box(CAB_W + 0.05, 0.44, 0.05, (CAB_X, CAB_Y, CAB_TOP + 0.02),
            m=m['case']))
    add(box(0.02, 0.30, 0.44, (CAB_X - CAB_W / 2 - 0.005, CAB_Y, 0.56),
            m=m['dark']))
    add(box(0.14, 0.05, 0.11, (CAB_X, CAB_Y - 0.21, 0.62), m=m['panel']))
    add(bar((CAB_X, CAB_Y + 0.20, CAB_TOP - 0.08),
            (CAB_X + 0.08, BED_Y - BED_SY / 2, BED_TOP - 0.12), 0.035,
            m['dark']))

    # --- drive bed, flywheel and motor ------------------------------------
    add(box(2.30, BED_SY, BED_TOP - DECK_TOP,
            (0, BED_Y, (DECK_TOP + BED_TOP) / 2), m=m['case']))
    for sx in (-1, 1):
        add(box(0.30, 0.14, 0.34, (sx * ROLL_X, BED_Y - BED_SY / 2 - 0.05,
                                   ROLL_Z - 0.10), m=m['case']))
    if VARIANT == 'burner':
        # A firebox and a stack where the electric motor goes. The stack is
        # the tell at a distance: it is the tallest thing on the sprite and
        # the only chimney in the mod, so a burner crusher can be picked out
        # of a row of them without reading a single label.
        add(box(0.62, 0.52, 0.46, (MOTOR_X, MOTOR_Y - 0.02, BED_TOP + 0.23),
                m=m['case']))
        add(box(0.30, 0.05, 0.22, (MOTOR_X, MOTOR_Y - 0.29, BED_TOP + 0.20),
                m=m['panel']))
        # Case grey on the horizontal faces up here, not steel: a small
        # flat face high on the machine takes this sun straight on and
        # comes back as a sheet of white paper.
        add(box(0.68, 0.58, 0.06, (MOTOR_X, MOTOR_Y - 0.02, BED_TOP + 0.49),
                m=m['case']))
        add(cyl_at(MOTOR_X, MOTOR_Y + 0.10, BED_TOP + 0.76, 0.14, 0.50,
                   m['dark'], verts=16))
        add(cyl_at(MOTOR_X, MOTOR_Y + 0.10, BED_TOP + 1.02, 0.17, 0.07,
                   m['dark'], verts=16))
        add(box(0.40, 0.34, 0.26, (-0.28, BED_Y + 0.12, BED_TOP + 0.13),
                m=m['dark']))
    else:
        add(cyl_at(MOTOR_X, MOTOR_Y, MOTOR_Z, MOTOR_R, MOTOR_LEN, m['case'],
                   verts=24, rot=(0, math.pi / 2, 0)))
        for t in (-0.24, 0.0, 0.24):
            add(cyl_at(MOTOR_X + t, MOTOR_Y, MOTOR_Z, MOTOR_R + 0.03, 0.04,
                       m['steel'], verts=24, rot=(0, math.pi / 2, 0)))

    if VARIANT == 'industrial':
        # Oil tank, inlet stub and a cup on each cylinder head. The stub
        # sits at front centre - +Y, the near edge at this camera - and the
        # fluid box is declared on that same edge. A port drawn anywhere
        # else is a port the player cannot plug a pipe into.
        # Off to the left, not over the centre line. Sat in the middle the
        # tank is directly in front of the lubricant port at this camera and
        # hides it completely facing north - which is the facing machines
        # are placed in, and a port nobody can see is a port nobody plumbs.
        add(cyl_at(-0.40, 0.95, BED_TOP + 0.26, 0.19, 0.52, m['case'],
                   verts=24))
        add(cyl_at(-0.40, 0.95, BED_TOP + 0.54, 0.21, 0.05, m['case'],
                   verts=24))
        add(cyl_at(-0.40, 0.95, BED_TOP + 0.60, 0.06, 0.10, m['steel'],
                   verts=12))
        # The port goes where every other port in the mod goes - out to 1.46
        # and down at 0.36 - because that is the height Factorio draws the
        # pipe that connects to it. A stub up on the bed looks tidier in
        # isolation and leaves the connecting pipe joining thin air.
        add(box(0.34, 0.44, 0.40, (0, 1.05, 0.36), m=m['iron']))
        add(cyl_at(0, 1.30, 0.36, 0.165, 0.70, m['steel'], verts=24,
                   rot=(math.pi / 2, 0, 0)))
        add(cyl_at(0, 1.46, 0.36, 0.215, 0.10, m['dark'], verts=24,
                   rot=(math.pi / 2, 0, 0)))
        add(bar((0, 1.10, 0.52), (-0.40, 0.98, BED_TOP + 0.16), 0.055,
                m['steel']))
        for sx in (-1, 1):
            cap = (sx * ROLL_X + sx * (CYL_T1 + 0.10) * _UX, ECC_Y,
                   ROLL_Z + (CYL_T1 + 0.10) * _UZ)
            add(cyl_at(cap[0], cap[1], cap[2], 0.055, 0.12, m['steel'],
                       verts=12))

    face = (math.pi / 2, 0, 0)          # lay the disc face-on to the camera
    wheel = [cyl_at(WHEEL_X, WHEEL_Y, WHEEL_Z, WHEEL_R, 0.07, m['case'],
                    verts=32, rot=face)]
    wheel.append(cyl_at(WHEEL_X, WHEEL_Y - 0.05, WHEEL_Z, WHEEL_R + 0.035,
                        0.05, m['steel'], verts=32, rot=face))
    wheel.append(cyl_at(WHEEL_X, WHEEL_Y - 0.09, WHEEL_Z, 0.10, 0.14,
                        m['steel'], verts=14, rot=face))
    for k in range(WHEEL_SPOKES):
        a = 2 * math.pi * k / WHEEL_SPOKES
        wheel.append(box(0.05, 0.05, WHEEL_R * 1.72,
                         (WHEEL_X, WHEEL_Y - 0.06, WHEEL_Z),
                         rot=(0, a, 0), m=m['steel']))
    spin.append(Spin(wheel, pivot=(WHEEL_X, WHEEL_Y, WHEEL_Z), axis='Y',
                     degrees=WHEEL_SPIN))

    add(bar((WHEEL_X, WHEEL_Y - 0.10, WHEEL_Z),
            (-ROLL_X, ROLL_Y + ROLL_LEN / 2, ROLL_Z), 0.05, m['steel']))
    add(bar((MOTOR_X - MOTOR_LEN / 2, MOTOR_Y, MOTOR_Z),
            (ROLL_X, ROLL_Y + ROLL_LEN / 2, ROLL_Z), 0.045, m['steel']))

    return static, spin


# Each roll turns one whole tooth pitch and the flywheel one spoke, so every
# group lands back on frame 0.
fr.run(build)
