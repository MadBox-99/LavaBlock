"""Air filter - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python air_filter.py -- \
          --pass entity|shadow --direction north --frames 32 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

Built to the placeholder the mod carried for months with nothing behind it:
`graphics/entity/air-filter/air-filter.png`, a flat shadowless drawing with
no prototype, no recipe and no locale key. The machine in it is a squat
octagonal furnace tower, widest at the ground, with tall grey pilasters at
its corners, louvred rust panels recessed between them, a deep cleft down
the front face, arched pipes over the throat, and a small impeller turning
in a dark hood at the very top.

Six things in that drawing are easy to get wrong. The first cut got four of
them and the second got two more, and they are worth naming because each
one changes what the machine reads as rather than how nice it looks:

  * the tower flares OUT towards the ground. A near-cylinder reads as a tank.
  * the pilasters are the mass of the machine, not a detail on it.
  * the plan is an OCTAGON. A smooth cone of revolution has no corners for
    the pilasters to stand on, and they end up scattered round a drum.
  * the impeller is SMALL - about a quarter of the body across - and sunk
    in a dark hood. Blown up to the tower's own width it becomes the whole
    machine and the tower becomes a plinth for it.
  * the blades are DARK against a glow behind them, not orange blades on a
    dark face. The drawing lights the fan from inside and reads the blades
    as a silhouette, which is most of why it survives at icon size.
  * the horizontal breaks belong to the louvred panels, not to the
    pilasters. Putting them on the grey plates turns tall walls into
    stacks of tiles.

A tower with a vertical axis is also the one silhouette equally right in
all four facings, and an impeller lying flat is the one moving part a
rotatable machine can never turn edge-on - the geothermal turbine lost both
of its moving parts to a standing wheel in the horizontal sheet before that
was caught. The drawing was already solving the problem this machine has.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, cone_at,  # noqa: E402
                             box, bar, torus_at, MATS, mat, Spin, Swing)

# --- the octagon ---------------------------------------------------------
# Blender puts a cone's vertices at multiples of 360/verts starting at +X,
# so an eight-sided cone has a CORNER due south and the front of the machine
# would land on an edge. Turning the body half a facet puts a flat FACE
# there instead, which is where the cleft has to go.
FACETS = 8
HALF_FACET = math.pi / FACETS
# Face centres sit closer to the axis than corners do. Anything laid on a
# flat face - a louvre panel, the cleft - belongs at this radius, and
# anything standing on a corner belongs at the full radius.
APOTHEM = math.cos(HALF_FACET)

BOT_Z, TOP_Z = 0.03, 1.76
# Circumradius. The taper is the shape's whole character, so it is stronger
# here than in the round version: that one had to stay gentle because its
# pilasters were scattered round a drum and splayed like legs when pushed.
# Standing on corners they lean with the wall instead.
BOT_R, TOP_R = 1.26, 0.82

# Wide. In the drawing the grey walls are most of what you see and the rust
# shows between them as slots; at 0.30 the proportion inverted and the tower
# read as an orange building with grey trim.
RIB_WIDE = 0.38               # tangential
RIB_THICK = 0.30              # radial
RIB_T0, RIB_T1 = 0.03, 0.95   # how much of the tower's height a plate spans
# Smaller than the segmented version's 6 degrees, because these plates are
# now full height: the same angle at five times the length throws the foot
# a fifth of a tile sideways and the tower comes apart.
SWING_DEG = 4.0

LOUVRES = 5                   # slats per panel

HOOD_R = 0.48                 # the dark hood, about a quarter of the body
HOOD_H = 0.26
HOOD_Z = TOP_Z
GLOW_R = 0.40                 # the lit disc inside it
FAN_Z = HOOD_Z + HOOD_H + 0.03
FAN_R = 0.39
FAN_BLADES = 16
FAN_SPIN = 360 / FAN_BLADES   # a turn the blades are symmetric under

# Arched pipes over the throat, as (y, half-span, rise). Both sit BEHIND
# the hood in Y, which is what lets them cross the sprite above the
# impeller without ever occluding it: this camera adds world Y and Z
# together going up the sprite, so a pipe further north renders higher AND
# further back, and the fan draws over it rather than under it.
ARCHES = ((0.44, 0.64, 0.50), (0.70, 0.38, 0.34))
ARCH_SEGS = 11

IND_R = 0.20                  # the second impeller, down in the cleft
IND_Z = 0.46
IND_BLADES = 9
IND_SPIN = -360 / IND_BLADES

PORT_Z = 0.42
FRONT = -math.pi / 2          # a face centre, due south, nearest the camera


def face_r(t, apothem=True):
    """Radius of the tower at height fraction `t`, on a face or a corner."""
    r = BOT_R + (TOP_R - BOT_R) * t
    return r * APOTHEM if apothem else r


def height(t):
    return BOT_Z + (TOP_Z - BOT_Z) * t


def slab(p1, p2, wide, thick, material):
    """A flat slab spanning two points - a wall leaning with the taper.

    `bar` would do the same job with a square section; these have to be
    much wider tangentially than they are deep, or they read as posts
    stuck round the rim instead of as the mass of the building.
    """
    d = (p2[0] - p1[0], p2[1] - p1[1], p2[2] - p1[2])
    length = math.sqrt(sum(c * c for c in d))
    mid = tuple((a + b) / 2 for a, b in zip(p1, p2))
    yaw = math.atan2(d[1], d[0])
    pitch = -math.asin(d[2] / length)
    return box(length, wide, thick, mid, rot=(0, pitch, yaw), m=material)


def at(r, a, z):
    return (r * math.cos(a), r * math.sin(a), z)


def arch(y, x0, x1, z0, rise, thickness, material, segs=ARCH_SEGS):
    """A semicircular pipe in a vertical plane, built from short bars.

    There is no arc primitive here and there does not need to be: at 64 px
    eleven chords are a circle.

    The plane is fixed in Y, so the arch spans the sprite left to right.
    That is not a preference, it is the only orientation that works: this
    camera maps world X straight onto screen X, so an arch built in a plane
    of constant X has NO horizontal extent on screen at all and collapses,
    every segment of it, onto one vertical line. Built fore-and-aft first,
    it rendered as two orange stripes beside the hood and half an hour went
    into looking for the objects before the projection was the answer.
    """
    pts = []
    for i in range(segs + 1):
        u = i / segs
        pts.append((x0 + (x1 - x0) * u, y, z0 + rise * math.sin(math.pi * u)))
    return [bar(pts[i], pts[i + 1], thickness, material)
            for i in range(segs)]


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    # The pilasters, and the lightest thing on the machine - they are what
    # the eye picks the shape out by, exactly as in the drawing.
    #
    # A little emission on the tower's materials, for the reason the
    # crystallizer's amethyst carries some: this body leans away from the
    # key light on the side that faces the camera, so without a lift the
    # whole thing renders near black and only its roof catches the sun.
    m['rib'] = mat("rib", (0.560, 0.566, 0.575), 0.46, 0.80, wear=0.50,
                   emit=(0.74, 0.75, 0.78), emit_str=0.16)
    # The louvred panels between them. Rust red, which is what keeps this
    # machine apart from the air compressor's cold grey next door.
    m['panel'] = mat("panel", (0.395, 0.170, 0.078), 0.72, 0.30, wear=0.60,
                     emit=(0.82, 0.36, 0.16), emit_str=0.12)
    # The shadow line under each louvre slat. Dark, but nowhere near the
    # hood's black: five black bars across a panel read as a barcode.
    m['slat'] = mat("slat", (0.150, 0.098, 0.062), 0.80, 0.20, wear=0.55)
    m['collar'] = mat("collar", (0.062, 0.060, 0.058), 0.64, 0.90, wear=0.45)
    m['shell'] = mat("shell", (0.420, 0.425, 0.432), 0.40, 1.0, wear=0.55)
    # The inside of the cleft. This is the one material on the machine that
    # exists because of a rendering fault rather than a drawing: built out
    # of `collar` the chase came out a flat black rectangle with nothing in
    # it for light to reach, and it read as a hole punched in the sprite
    # rather than a recess in a building. It is dark, but it is LIT, and it
    # carries NO wear - wear is not a dial, it swaps in a noise ramp and
    # takes the full darkened mix with it, which would put this material
    # straight back where it started.
    m['chase'] = mat("chase", (0.085, 0.076, 0.072), 0.78, 0.25,
                     emit=(0.55, 0.34, 0.22), emit_str=0.18)
    # The glow behind the blades. Far dimmer than the ~1.5 clipping ceiling
    # would suggest is safe, because that ceiling is where a colour turns
    # WHITE and this one goes wrong long before it gets there: the red
    # channel saturates first, so an orange at 1.15 over a disc this size
    # came out lemon yellow with no orange left anywhere in it. The number
    # that matters for a warm colour is the one that keeps red under 1, not
    # the one that keeps all three under 1.
    m['glow'] = mat("glow", (0.480, 0.175, 0.040), 0.40, 0.0,
                    emit=(1.00, 0.34, 0.05), emit_str=0.45)
    # The blades themselves, dark. In the drawing the fan is a black
    # sunburst over a lit throat, not an orange one on a dark face, and
    # that inversion is most of why the original reads at icon size.
    m['blade'] = mat("blade", (0.055, 0.052, 0.056), 0.52, 0.85)

    static, spin = [], []
    add = static.append

    # --- the tower --------------------------------------------------------
    # No base plate under it. The drawing has none, and a dark square slab
    # showing past the pilasters is the single clearest way to make this
    # read as a model standing on a tile rather than as a building.
    body = cone_at(0, 0, BOT_Z, BOT_R, TOP_R, TOP_Z - BOT_Z, m['panel'],
                   verts=FACETS)
    body.rotation_euler = (0, 0, HALF_FACET)
    add(body)

    # --- louvred panels, one per face ------------------------------------
    # Not on the front face, which is the cleft, and not on the two the
    # fluid ports stand on: a port growing out of a set of louvres reads as
    # a pipe punched through a grille.
    for i in range(FACETS):
        a = 2 * math.pi * i / FACETS
        if abs(math.cos(a)) > 0.9 or abs(math.sin(a) + 1.0) < 1e-6:
            continue
        add(slab(at(face_r(0.10) + 0.015, a, height(0.10)),
                 at(face_r(0.92) + 0.015, a, height(0.92)),
                 0.66, 0.06, m['panel']))
        # The slats. These are the drawing's horizontal breaks, and they
        # belong here and not on the pilasters - which is the mistake the
        # last version made, and it turned tall walls into stacks of tiles.
        for k in range(LOUVRES):
            t = 0.14 + 0.72 * (k + 0.5) / LOUVRES
            add(box(0.07, 0.64, 0.035, at(face_r(t) + 0.05, a, height(t)),
                    rot=(0, 0, a), m=m['slat']))

    # --- the pilasters ----------------------------------------------------
    # One per corner of the octagon, standing on the edge where two faces
    # meet, which is what makes the plan read as faceted rather than round.
    for i in range(FACETS):
        a = HALF_FACET + 2 * math.pi * i / FACETS
        # One continuous slab from foot to cap. The whole plate hangs from
        # its cap and is rocked by the draught through the machine: hinged
        # along the top, free at the bottom.
        plate = [slab(at(face_r(RIB_T0, apothem=False) + 0.04, a,
                         height(RIB_T0)),
                      at(face_r(RIB_T1, apothem=False) + 0.04, a,
                         height(RIB_T1)),
                      RIB_WIDE, RIB_THICK, m['rib'])]
        # A chunky end on the BOTTOM, part of the plate and swinging with
        # it - not a separate foot bolted to the ground. A static foot was
        # tried and was wrong twice over: the drawing has no such thing,
        # and a plate swinging clear of a fixed foot lifts off it and
        # flashes a bright wedge underneath on every stroke.
        plate.append(box(0.36, RIB_WIDE + 0.06, 0.16,
                         at(face_r(RIB_T0, apothem=False) + 0.07, a,
                            height(RIB_T0) + 0.05),
                         rot=(0, 0, a), m=m['shell']))
        # Hinge on the horizontal line tangential to the tower at the top
        # of the plate, so the bottom swings out from the wall and back,
        # which is what a draught does to a hanging plate. A radial axis
        # would make it wag sideways instead, like a flag.
        #
        # Built LAST, after every piece of the plate exists: Swing copies
        # the list it is handed, so anything appended afterwards is in no
        # group at all and trips the stray-object assertion in assemble().
        spin.append(Swing(plate,
                          pivot=at(face_r(RIB_T1, apothem=False) + 0.04, a,
                                   height(RIB_T1)),
                          axis_vec=(-math.sin(a), math.cos(a), 0.0),
                          degrees=SWING_DEG, phase=i / FACETS))
        # The stepped cap is the hinge bracket and stays put. Two courses,
        # the upper one narrower, because a single block reads as the plate
        # simply stopping and the drawing's pilasters are clearly capped.
        add(box(0.30, RIB_WIDE + 0.06, 0.11,
                at(face_r(0.97, apothem=False) + 0.03, a, height(0.97)),
                rot=(0, 0, a), m=m['shell']))
        add(box(0.22, RIB_WIDE - 0.04, 0.09,
                at(face_r(1.0, apothem=False), a, TOP_Z + 0.07),
                rot=(0, 0, a), m=m['rib']))

    # --- the cleft down the front face ------------------------------------
    # South is the bottom of the sprite and the face nearest the camera -
    # the one side of this machine a player ever really sees.
    #
    # The opening is built as a stack of courses that narrow going down, so
    # it reads as a V and not a slot. Everything here is additive: the
    # depth is done with value and light, not with geometry, because there
    # is nothing to cut a hole in.
    COURSES = 6
    for k in range(COURSES):
        t = 0.08 + 0.80 * k / COURSES
        t2 = 0.08 + 0.80 * (k + 1) / COURSES
        w = 0.28 + 0.58 * (k / (COURSES - 1))
        add(slab(at(face_r(t) + 0.02, FRONT, height(t)),
                 at(face_r(t2) + 0.02, FRONT, height(t2)),
                 w, 0.05, m['chase']))
        # A light cheek down each side of the course. Depth on a flat face
        # is a contrast trick and nothing else: the chase alone, at any
        # brightness, is one flat value and reads as a painted panel. Lit
        # walls either side of a dark middle read as a recess, and this is
        # what the drawing does too - its cleft is bright grey at the
        # edges and near black down the centre.
        for sx in (-1, 1):
            o = slab(at(face_r(t) + 0.035, FRONT, height(t)),
                     at(face_r(t2) + 0.035, FRONT, height(t2)),
                     0.07, 0.07, m['rib'])
            o.location.x += sx * (w / 2 + 0.03)
            add(o)
    # Two warm strips down the inside, which is what says there is a lit
    # furnace behind this face and not an empty box. They belong at the
    # EDGES of the opening: set close together at +-0.13 they merged into
    # one bright bar and the rungs crossing it turned the whole cleft into
    # a glowing ladder, which is the one thing it must not read as.
    for sx in (-1, 1):
        o = slab(at(face_r(0.22) + 0.045, FRONT, height(0.22)),
                 at(face_r(0.86) + 0.045, FRONT, height(0.86)),
                 0.045, 0.035, m['glow'])
        o.location.x += sx * 0.23
        add(o)
    # Rungs across the chase. Dark, not bright: lit in `shell` they were
    # the rungs of that ladder. They are here to break the opening up, and
    # a dark bar does that against a lit interior just as well.
    for t in (0.44, 0.60, 0.76):
        add(box(0.08, 0.40, 0.045, at(face_r(t) + 0.07, FRONT, height(t)),
                rot=(0, 0, FRONT), m=m['slat']))

    # --- the second impeller, at the foot of the cleft --------------------
    # The drawing has a small bright detail down there and a second fan in
    # the throat; this is both at once. It lies flat on a shelf standing
    # proud of the face, because the version before this one put it on the
    # tower's axis at z = 1.34 - inside the solid body, where it was never
    # once visible in any frame this machine has ever rendered.
    #
    # Lit the same way round as the one in the hood - a glowing disc with
    # DARK blades over it. Built the other way, with the blades themselves
    # emitting, nine of them at this size fused into a single white blob
    # with no blade visible in it at all.
    ind_r = face_r(0.24) + 0.16
    add(box(0.26, 0.56, 0.06, at(ind_r, FRONT, IND_Z - 0.06),
            rot=(0, 0, FRONT), m=m['collar']))
    add(cyl_at(0, -ind_r, IND_Z - 0.015, IND_R, 0.04, m['glow'], verts=16))
    ind = []
    for i in range(IND_BLADES):
        a = 2 * math.pi * i / IND_BLADES
        ind.append(box(IND_R * 1.8, 0.05, 0.03,
                       at(ind_r, FRONT, IND_Z), rot=(0, 0, a), m=m['blade']))
    ind.append(cyl_at(0, -ind_r, IND_Z + 0.02, 0.06, 0.06, m['collar'],
                      verts=12))
    spin.append(Spin(ind, pivot=at(ind_r, FRONT, IND_Z), axis='Z',
                     degrees=IND_SPIN))

    # --- the hood, and the impeller in it ---------------------------------
    # The impeller sits ON TOP of the hood's lit face, never inside it.
    # This is the fourth time in this repo a solid body has swallowed the
    # one part that had to be seen - the gas combiner's sight glass inside
    # its drum, the crystallizer's inlet inside its manifold, this fan
    # inside a collar and then inside a well, and the second impeller
    # inside the tower itself. A LIT face below the blades and a rim
    # around them gives the sunken look with nothing covering them.
    add(cyl_at(0, 0, HOOD_Z + HOOD_H / 2, HOOD_R, HOOD_H, m['collar'],
               verts=24))
    add(cyl_at(0, 0, HOOD_Z + HOOD_H - 0.01, GLOW_R, 0.04, m['glow'],
               verts=24))
    add(torus_at((0, 0, HOOD_Z + HOOD_H + 0.02), HOOD_R, 0.055, m['shell'],
                 segments=24))

    fan = []
    for i in range(FAN_BLADES):
        a = 2 * math.pi * i / FAN_BLADES
        # Thin, long and densely set, and DARK: the drawing's fan is a
        # black sunburst over a lit throat, and at 64 px a silhouette
        # carries further than a lit blade on a dark ground ever does.
        fan.append(box(FAN_R * 1.75, 0.055, 0.035, (0, 0, FAN_Z),
                       rot=(0, 0, a), m=m['blade']))
    fan.append(cyl_at(0, 0, FAN_Z + 0.02, 0.12, 0.09, m['collar'], verts=16))
    spin.append(Spin(fan, pivot=(0, 0, FAN_Z), axis='Z', degrees=FAN_SPIN))

    # --- arched pipes over the throat -------------------------------------
    # Behind the hood, never in front of it. These cross the sprite above
    # the impeller, which is the drawing's silhouette, and they are allowed
    # to only because they stand north of it: a pipe behind the fan is
    # drawn over BY the fan, so nothing ever covers the working part. The
    # same two arches moved to the south side would sit on top of the
    # blades and break the one rule this repo has about moving parts.
    for y, half, rise in ARCHES:
        for o in arch(y, -half, half, TOP_Z + 0.02, rise, 0.055, m['shell']):
            add(o)
        for sx in (-1, 1):
            add(cyl_at(sx * half, y, TOP_Z - 0.01, 0.085, 0.10,
                       m['collar'], verts=12))

    # --- fluid connections ------------------------------------------------
    # Dirty compressed air in on the west, clean air out on the east. X
    # keeps its sign between the model and the prototype; it is Y that
    # flips. Both stand on a flat face, which is why those two faces carry
    # no louvres.
    for sx in (-1, 1):
        add(box(0.34, 0.50, 0.46, (sx * 1.14, 0, PORT_Z), m=m['shell']))
        add(cyl_at(sx * 1.34, 0, PORT_Z, 0.175, 0.64, m['shell'], verts=24,
                   rot=(0, math.pi / 2, 0)))
        add(cyl_at(sx * 1.46, 0, PORT_Z, 0.225, 0.10, m['collar'], verts=24,
                   rot=(0, math.pi / 2, 0)))

    return static, spin


# Eight tiles: the tower is two and a half across at the ground and reaches
# past two tall with the arches on, and a body that tall throws its sun-side
# shadow well past the footprint.
fr.run(build, frame_tiles=8)
