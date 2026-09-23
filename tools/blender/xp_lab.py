"""XP lab - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python xp_lab.py -- \
          --pass entity|shadow --frames 32 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A lab has no facing, so this model is rendered once and once only: north.
Factorio asks a lab for an `on_animation` and an `off_animation` and never
for a direction, which makes this the cheapest sheet in the mod - a quarter
of what a rotatable machine costs.

The only building in the mod that is not industrial. Everything else here is
plate, pipe and lagging; this one is cut stone with amethyst growing out of
it, because what it reads is the enchanted science pack and not a bottle of
chemicals. It borrowed the vanilla lab's picture until now, tinted violet,
which made it a purple copy of the building standing next to it rather than
a different building.

The amethyst is deliberately the same material the crystallizer grows and
the silica crystal icon is cut from. The crystals are the only violet in the
mod and that is the whole point: the machine that makes them and the machine
that reads them are visibly the same stone.

Every moving part turns about Z. A lab cannot be rotated, so there is no
facing that could hide them, but a lying rotation is also the one a camera
looking down at 45 degrees reads best - and nothing is drawn over the
crystals, which are the working parts here.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, cone_at,  # noqa: E402
                             box, bar, MATS, mat, Spin)

DECK_TOP = 0.30              # top of the stone platform
PED_TOP = 0.86               # top of the central pedestal

CORE_FACETS = 6              # the floating crystal is a six-sided prism
CORE_SPIN = 360 / CORE_FACETS
# High enough that the downward spike clears the pedestal entirely.
# At +0.30 the two intersected and the whole core read as one grey
# lump growing out of the stone instead of hanging over it.
CORE_Z = PED_TOP + 0.60
CORE_H = 0.62

MOTES = 4                    # small crystals orbiting the core
MOTE_SPIN = 360 / MOTES
MOTE_R = 0.62                # orbit radius
MOTE_Z = PED_TOP + 0.62


def prism(x, y, z, r, h, tilt, spin, m):
    """One crystal: a six-sided spike, leaning.

    Lifted wholesale from crystallizer.py, and deliberately not factored
    into factorio_render: the two machines want the same crystal to look
    like the same mineral, and a shared helper that later grows options for
    one of them would quietly change the other.
    """
    o = cone_at(x, y, z, r, r * 0.16, h, m, verts=6)
    o.rotation_euler = (tilt * math.cos(spin), tilt * math.sin(spin), spin)
    return o


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    # Dressed stone rather than plate: dark, matt and not metallic at all,
    # which is what separates this building from every other one here at a
    # glance even before the colour registers.
    m['stone'] = mat("stone", (0.168, 0.158, 0.186), 0.86, 0.0, wear=0.70)
    m['trim'] = mat("trim", (0.268, 0.248, 0.302), 0.74, 0.15, wear=0.62)
    # The same amethyst the crystallizer grows. Emission stays low: above
    # about 1.5 the Standard view transform clips it to white and a crystal
    # turns into a paper cut-out.
    m['crystal'] = mat("crystal", (0.205, 0.135, 0.395), 0.18, 0.0,
                       emit=(0.40, 0.26, 0.86), emit_str=0.26)
    # The core is the one thing in the building that is meant to be looked
    # at, so it glows harder than the crystals growing out of the stone.
    m['core'] = mat("core", (0.300, 0.190, 0.560), 0.14, 0.0,
                    emit=(0.58, 0.34, 1.00), emit_str=1.30)
    m['brass'] = mat("brass", (0.370, 0.256, 0.078), 0.32, 1.0, wear=0.62)

    static, spin = [], []
    add = static.append

    # --- the platform ----------------------------------------------------
    add(box(2.84, 2.84, 0.18, (0, 0, 0.09), m=m['stone']))
    add(box(2.62, 2.62, 0.14, (0, 0, 0.23), m=m['trim']))
    # Flagstone joints, shallow but enough to break up 3x3 of flat grey.
    for u in (-0.84, 0.0, 0.84):
        add(box(2.56, 0.05, 0.03, (0, u, DECK_TOP + 0.005), m=m['stone']))
        add(box(0.05, 2.56, 0.03, (u, 0, DECK_TOP + 0.005), m=m['stone']))

    # --- corner buttresses, each with a crystal growing out of it --------
    for sx in (-1, 1):
        for sy in (-1, 1):
            x, y = sx * 1.08, sy * 1.08
            add(box(0.52, 0.52, 0.44, (x, y, DECK_TOP + 0.22), m=m['stone']))
            add(box(0.60, 0.60, 0.07, (x, y, DECK_TOP + 0.47), m=m['trim']))
            add(prism(x, y, DECK_TOP + 0.50, 0.105, 0.36, 0.14,
                      sx * sy * 0.7, m['crystal']))

    # --- the pedestal ----------------------------------------------------
    add(cyl_at(0, 0, DECK_TOP + 0.14, 0.58, 0.28, m['stone'], verts=8))
    add(cyl_at(0, 0, DECK_TOP + 0.32, 0.46, 0.14, m['trim'], verts=8))
    add(cyl_at(0, 0, PED_TOP - 0.12, 0.34, 0.24, m['stone'], verts=8))
    # Brass collar under the core, the only metal on the building. It is
    # what makes the floating crystal read as mounted rather than dropped.
    add(cyl_at(0, 0, PED_TOP + 0.01, 0.30, 0.07, m['brass'], verts=16))
    # Three posts round the collar, reaching up towards the core but
    # stopping well short of it. They say the crystal is held in a
    # field rather than on a spindle - and nothing reaches over it.
    for i in range(3):
        a = 2 * math.pi * i / 3 + 0.5
        add(cyl_at(0.34 * math.cos(a), 0.34 * math.sin(a),
                   PED_TOP + 0.20, 0.045, 0.34, m['brass'], verts=10))
        add(prism(0.34 * math.cos(a), 0.34 * math.sin(a),
                  PED_TOP + 0.36, 0.05, 0.14, 0.0, a, m['crystal']))

    # --- the core: a floating crystal, turning ---------------------------
    core = []
    core.append(prism(0, 0, CORE_Z, 0.28, CORE_H, 0.0, 0.0, m['core']))
    # An inverted spike underneath, so it reads as suspended rather than
    # standing on something. Two points meeting in the air is the single
    # clearest way to say "this is not resting on the pedestal".
    c = cone_at(0, 0, CORE_Z - 0.34, 0.28, 0.28 * 0.16, 0.34, m['core'],
                verts=CORE_FACETS)
    c.rotation_euler = (math.pi, 0, 0)
    core.append(c)
    spin.append(Spin(core, pivot=(0, 0, CORE_Z), axis='Z',
                     degrees=CORE_SPIN))

    # --- motes: small crystals orbiting the core -------------------------
    # A second rate, so the building does not read as one object rotating.
    motes = []
    for i in range(MOTES):
        a = 2 * math.pi * i / MOTES
        motes.append(prism(MOTE_R * math.cos(a), MOTE_R * math.sin(a),
                           MOTE_Z, 0.075, 0.24, 0.0, a, m['crystal']))
    spin.append(Spin(motes, pivot=(0, 0, MOTE_Z), axis='Z',
                     degrees=MOTE_SPIN))

    # --- the reading desk, on the south face -----------------------------
    # Where the packs go in. South is the bottom of the sprite and the face
    # nearest the camera, so it is the one edge a player actually sees.
    add(box(1.10, 0.42, 0.40, (0, -1.02, DECK_TOP + 0.20), m=m['stone']))
    add(box(1.22, 0.52, 0.06, (0, -1.02, DECK_TOP + 0.43),
            rot=(-0.20, 0, 0), m=m['trim']))
    for sx in (-1, 1):
        add(prism(sx * 0.40, -1.02, DECK_TOP + 0.44, 0.055, 0.17, 0.0,
                  0.0, m['crystal']))

    # --- buttress ribs, corner to pedestal -------------------------------
    # Stone, static, and kept low: they run under the motes' orbit, never
    # over it. Nothing is drawn above the crystals on this building.
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(bar((sx * 0.92, sy * 0.92, DECK_TOP + 0.10),
                    (sx * 0.34, sy * 0.34, DECK_TOP + 0.16), 0.11,
                    m['trim']))

    return static, spin


fr.run(build)
