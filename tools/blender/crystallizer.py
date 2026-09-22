"""Crystallizer - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python crystallizer.py --
          --pass entity|shadow|icon --direction north --frames 32 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A crystallising hearth: a hexagonal pan of molten rock with three rabble
arms turning slowly through it, and six clusters of crystal standing on the
shelf around the rim, growing out of the melt and being taken away again.

Not a Czochralski puller, which is what "crystallizer" usually draws. A
puller is a crucible with a long rod hanging above it pulling a boule up
into the air, and at a forty-five degree camera that rod stands straight
through the middle of the sprite and hides the only interesting thing in
the machine. The same objection as the crusher's hopper: the part that says
what the machine does must not be the part something else is drawn over.

A hearth answers it by working outwards instead of upwards. The melt stays
open and glowing in the middle, the product grows in a ring around it where
nothing can cover it, and the whole machine is under a metre tall - so it
reads as a pan of something hot with things growing in it, from directly
above, at ninety pixels.

The arms turn inside the melt only, never out over the crystals. Three of
them, so the sheet closes on a third of a turn, which is run()'s default.

The crystals are the only violet in the mod. The compressor is blue-grey,
the condenser teal, the centrifuge orange, the arboretum green and glass,
the crushers rust, steel and ochre - amethyst on a hot orange pan belongs
to nothing else on the island, and that is the whole job of the colour.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, cone_at,  # noqa: E402
                             box, bar, MATS, mat, Spin, Grow)

DECK_TOP = 0.21

# --- the hearth ----------------------------------------------------------
BODY_R = 1.24
BODY_H = 0.64
BODY_TOP = DECK_TOP + BODY_H
RIM_R = 1.30
MELT_R = 0.78
SHELF_R = 1.06
SHELF_TOP = BODY_TOP + 0.01
# Derived, never a number of its own. The first version hard-coded the
# surface height, and raising the body by twelve centimetres dropped the
# melt underneath its own shelf - a machine with no pan at all.
MELT_Z = SHELF_TOP + 0.04       # a little proud, so the pan has a lip

# --- the crystals --------------------------------------------------------
CRYS_N = 6
CRYS_R = 0.99                   # ring radius, out on the shelf
CRYS_H = 0.82                   # the tallest spike in a cluster

# --- the rabble arms -----------------------------------------------------
# Angle, radius as a fraction of MELT_R, the two side lengths, and how far
# the plate is turned out of true. Written out rather than generated, so the
# crust is the same in every facing and in every re-render.
CRUST = (
    (14, 0.82, 0.26, 0.15, 0.22), (61, 0.70, 0.17, 0.21, -0.35),
    (96, 0.86, 0.31, 0.12, 0.08), (148, 0.74, 0.14, 0.14, 0.44),
    (176, 0.88, 0.22, 0.19, -0.12), (223, 0.66, 0.28, 0.13, 0.31),
    (259, 0.85, 0.16, 0.24, -0.26), (301, 0.76, 0.24, 0.16, 0.05),
    (334, 0.89, 0.13, 0.18, -0.41),
)

ARM_N = 3
ARM_IN = 0.10
ARM_OUT = 0.58                  # stops well inside MELT_R: see the header
ARM_Z = MELT_Z + 0.10
SPINDLE_H = 0.46


def prism(x, y, z, r, h, tilt, spin, m):
    """One crystal: a six-sided spike, leaning.

    Hexagonal rather than round because a cone reads as a pile of sand and a
    six-sided prism reads as a crystal, and the difference survives all the
    way down to the icon. The lean is what stops six of them looking like a
    row of bollards - real crystal clusters grow out at every angle.
    """
    o = cone_at(x, y, z, r, r * 0.16, h, m, verts=6)
    o.rotation_euler = (tilt * math.cos(spin), tilt * math.sin(spin), spin)
    return o


def cluster(x, y, a, m):
    """Three spikes of different heights out of one root."""
    out = [prism(x, y, SHELF_TOP - 0.02, 0.135, CRYS_H, 0.10, a, m)]
    for dx, dy, r, h, tilt in ((0.17, 0.05, 0.075, CRYS_H * 0.62, 0.30),
                               (-0.12, -0.14, 0.060, CRYS_H * 0.44, -0.38)):
        c, s = math.cos(a), math.sin(a)
        out.append(prism(x + dx * c - dy * s, y + dx * s + dy * c,
                         SHELF_TOP - 0.02, r, h, tilt, a + 1.1, m))
    return out


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    m['deck'] = mat("deck", (0.050, 0.048, 0.046), 0.80, 0.20, wear=0.55)
    # Pale grey-violet, and much darker here than it looks on the sprite:
    # the icon pass turns the sun up hard and a colour picked to look right
    # in a swatch comes back white.
    m['case'] = mat("case", (0.232, 0.212, 0.268), 0.56, 0.72, wear=0.80)
    # Amethyst, with just enough emission to hold its colour in the shadow
    # side of the ring. Above about 1.5 the Standard view transform clips it
    # to white and the crystals turn into six paper cut-outs.
    m['crystal'] = mat("crystal", (0.205, 0.135, 0.395), 0.18, 0.0,
                       emit=(0.40, 0.26, 0.86), emit_str=0.26)
    m['brick'] = mat("brick", (0.196, 0.134, 0.106), 0.88, 0.0, wear=0.66)
    # Brass, only for the gas line, so the two inlets differ in colour as
    # well as in bore. It is the gas combiner's material next door.
    m['brass'] = mat("brass", (0.370, 0.256, 0.078), 0.32, 1.0, wear=0.62)
    # Its own melt, not the shared `lava`. That one is mixed for a pipe or a
    # ladle seen edge-on; here the player looks straight down a half-metre
    # disc of it, and at 1.9 the whole pan clips to a flat white-orange hole
    # with no surface at all.
    m['melt'] = mat("melt", (0.118, 0.042, 0.014), 0.72, 0.0,
                    emit=(1.00, 0.34, 0.05), emit_str=0.95)
    m['panel'] = mat("panel", (0.045, 0.030, 0.062), 0.30, 0.2,
                     emit=(0.72, 0.42, 1.00), emit_str=0.9)

    static, spin, grow = [], [], []
    add = static.append

    # --- plinth -----------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))

    # --- hearth body ------------------------------------------------------
    # Hexagonal, not round. Every other vessel in the mod is a cylinder, and
    # at sprite size the flats are what tells this one from the centrifuge.
    add(cyl_at(0, 0, DECK_TOP + BODY_H / 2, BODY_R, BODY_H, m['brick'],
               verts=6))
    add(cyl_at(0, 0, BODY_TOP - 0.06, RIM_R, 0.14, m['case'], verts=6))
    # Refractory shelf the crystals stand on, inside the rim.
    add(cyl_at(0, 0, SHELF_TOP - 0.04, SHELF_R, 0.08, m['brick'], verts=6))

    # Six buttresses on the hex corners, tying the rim down to the plinth.
    for i in range(6):
        a = 2 * math.pi * i / 6
        add(bar((RIM_R * 0.96 * math.cos(a), RIM_R * 0.96 * math.sin(a),
                 BODY_TOP - 0.06),
                (RIM_R * 1.04 * math.cos(a), RIM_R * 1.04 * math.sin(a),
                 DECK_TOP), 0.085, m['steel']))

    # --- the melt ---------------------------------------------------------
    add(cyl_at(0, 0, MELT_Z - 0.05, MELT_R + 0.06, 0.10, m['case'],
               verts=40))
    add(cyl_at(0, 0, MELT_Z, MELT_R, 0.08, m['melt'], verts=40))
    # Crust on the melt: cooled plates floating on it and caught against the
    # rim. Deliberately irregular. The first version was fourteen identical
    # blocks on an even ring, and three arms turning inside a ring of evenly
    # spaced radial marks is a clock face - which is what it read as, and
    # nothing else. Broken ice never divides the circle evenly.
    for ang, rad, sx, sy, skew in CRUST:
        a = ang * math.pi / 180.0
        add(box(sx, sy, 0.045, (rad * MELT_R * math.cos(a),
                                rad * MELT_R * math.sin(a), MELT_Z + 0.03),
                rot=(0, 0, a + skew), m=m['dark']))

    # --- crystals ---------------------------------------------------------
    # Each cluster grows and is taken on its own schedule. All six filling
    # together would read as one animation copied six times; staggered, the
    # ring reads as a process with something always at every stage.
    for i in range(CRYS_N):
        a = 2 * math.pi * i / CRYS_N + math.pi / 6
        x, y = CRYS_R * math.cos(a), CRYS_R * math.sin(a)
        grow.append(Grow(cluster(x, y, a, m['crystal']),
                         pivot=(x, y, SHELF_TOP - 0.02), axis='Z',
                         phase=i / float(CRYS_N), low=0.12, hold=0.80))

    # --- rabble arms ------------------------------------------------------
    # A drum for a hub and short deep blades, not three thin spokes off a
    # point. Thin radial rods over a round face are clock hands whatever
    # else is going on around them; a stubby rabble with visible plough
    # blades is machinery.
    # The hub is kept small on purpose. At a quarter of the pan's radius it
    # is a grey lid over the middle of the melt, and the melt is the part
    # that says the machine is running.
    arms = [cyl_at(0, 0, ARM_Z + SPINDLE_H / 2 - 0.12, 0.11, SPINDLE_H,
                   m['case'], verts=14),
            cyl_at(0, 0, ARM_Z - 0.02, 0.155, 0.12, m['steel'], verts=14)]
    for i in range(ARM_N):
        a = 2 * math.pi * i / ARM_N
        c, s = math.cos(a), math.sin(a)
        arms.append(box(ARM_OUT - ARM_IN, 0.13, 0.11,
                        ((ARM_IN + ARM_OUT) / 2 * c,
                         (ARM_IN + ARM_OUT) / 2 * s, ARM_Z),
                        rot=(0, 0, a), m=m['steel']))
        # The blade is set across the sweep so it ploughs the melt instead
        # of slicing it - a bare rod turning leaves no wake at all.
        arms.append(box(0.09, 0.34, 0.17, (ARM_OUT * c, ARM_OUT * s,
                                           ARM_Z - 0.05),
                        rot=(0, 0, a + 0.30), m=m['dark']))
    spin.append(Spin(arms, pivot=(0, 0, 0), axis='Z'))

    # --- the two inlets, on the flanks -------------------------------------
    # Model -X is the left of the sprite and Factorio's west, model +X the
    # right and east; the X sign does not flip between the two. Y does -
    # modelled +Y renders at the top of the sprite, the top of a sprite is
    # north, and Factorio counts Y southwards, so a stub at +Y is {0,-1}.
    #
    # Both flanks, because the shielded recipe wants melt and gas at once
    # and a machine with two feeds has to show two. Lava on the left in a
    # heavy pipe, gas on the right in a thin one, so which is which can be
    # read off the model rather than guessed.
    def inlet(sx, r_pipe, r_flange, box_h, m_pipe):
        add(box(0.46, 0.36, box_h, (sx * 1.06, 0, box_h / 2 + 0.16),
                m=m['case']))
        add(cyl_at(sx * 1.30, 0, 0.37, r_pipe, 0.70, m_pipe, verts=24,
                   rot=(0, math.pi / 2, 0)))
        add(cyl_at(sx * 1.46, 0, 0.37, r_flange, 0.10, m['dark'], verts=24,
                   rot=(0, math.pi / 2, 0)))
        add(bar((sx * 1.06, 0, 0.56), (sx * 0.80, 0, SHELF_TOP - 0.04),
                0.075, m['steel']))

    inlet(-1, 0.165, 0.215, 0.42, m['steel'])     # west  {-1, 0} - the melt
    inlet(1, 0.105, 0.150, 0.34, m['brass'])      # east  { 1, 0} - the gas

    # --- product chute, south (the near edge) ------------------------------
    # South is -Y here. The first version put it at +Y calling it the near
    # edge, which is the back of the sprite, and the chute spent four
    # facings hidden behind the machine's own body.
    add(box(0.74, 0.40, 0.16, (0, -1.16, 0.46), rot=(0.42, 0, 0),
            m=m['case']))
    add(box(0.82, 0.10, 0.30, (0, -1.32, 0.30), m=m['dark']))
    for sx in (-1, 1):
        add(bar((sx * 0.36, -1.30, 0.34), (sx * 0.36, -1.06, DECK_TOP),
                0.055, m['steel']))

    # --- switchgear, north (the back) --------------------------------------
    add(box(0.72, 0.34, 0.56, (-0.30, 1.12, 0.49), m=m['case']))
    add(box(0.46, 0.05, 0.24, (-0.30, 0.94, 0.60), m=m['panel']))
    add(cyl_at(0.42, 1.12, 0.44, 0.09, 0.46, m['steel'], verts=12))

    return static, spin + grow


fr.run(build)
