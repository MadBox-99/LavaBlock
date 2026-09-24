"""The lava science pack icon.

  blender --background --factory-startup --python science_pack.py -- \
          --pass icon --ground 0 --samples 512 --out DIR

The camera, materials and render loop live in factorio_render.

Every science pack in Factorio is the same flask seen from the same angle,
and that sameness is the whole point: the silhouette says "this is a science
pack" and what is inside says which one. So the outline here is deliberately
the vanilla one - round body, short neck, stopper - and only the contents
are the mod's own.

What was there before was the vanilla flask recoloured orange, which said
nothing this mod has not already said with a tint. This one is filled with
what the island actually runs on: molten rock with a crust of cooled basalt
floating on it, lit from inside, the same reading as the crystallizer's pan.
The glass is real glass, which the mod now makes, so the pack is built out
of its own production chain rather than out of a colour filter.

Three things about a 64 px icon drove the shape:

  * the crust has to be a RING at the melt line, not a lid. Covering the
    melt puts out the only light in the icon.
  * glass cannot be transparent here. There is no environment to refract,
    so a glass shell renders as a dark smear; it is a thin bright rim
    instead, which is what reads as glass at this size anyway.
  * the neck must be short. At 64 px a tall neck costs the body the height
    it needs, and the body is what carries the colour.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, cone_at,  # noqa: E402
                             torus_at, MATS, mat)

BODY_R = 0.62                 # the round flask body
BODY_Z = 0.66
BODY_FLAT = 0.94              # vertical squash, so it sits like a flask
NECK_R = 0.17
NECK_H = 0.26
# Where the melt stops, as a fraction of the body's height from the bottom.
# High: a science pack reads as a bottle of something, and a bottle that is
# a third full reads as an empty bottle with a puddle in it.
FILL = 0.70
RINGS = 20                    # profile steps the body is lathed from


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    # The melt. This is the only light in the icon and it is read at 64 px,
    # so it sits higher than the machines' glows do - but still well under
    # the point where the red channel saturates and the orange walks off
    # towards yellow, which is what the number to watch really is.
    m['melt'] = mat("melt", (0.520, 0.170, 0.035), 0.38, 0.0,
                    emit=(1.00, 0.36, 0.05), emit_str=0.78)
    # Cooled basalt: the dark crust. No emission at all - the contrast
    # between it and the melt under it is the whole image.
    m['crust'] = mat("crust", (0.072, 0.064, 0.066), 0.86, 0.0, wear=0.60)
    # Glass, and deliberately OPAQUE. Transmission was tried and is wrong
    # here for a reason that is worth writing down: the render film is
    # transparent, so Cycles gives a transmissive surface almost no alpha
    # and the whole upper half of the flask simply vanishes from the image.
    # What is left is the melt on its own - a glowing egg. Factorio's own
    # science pack icons are painted the same way, opaque throughout, with
    # the glass read purely off its highlights.
    m['glass'] = mat("glass", (0.300, 0.355, 0.385), 0.10, 0.0)
    g = m['glass'].node_tree.nodes['Principled BSDF']
    g.inputs['Coat Weight'].default_value = 0.9
    g.inputs['Coat Roughness'].default_value = 0.02
    m['collar'] = mat("collar", (0.300, 0.310, 0.320), 0.34, 1.0, wear=0.45)
    m['cork'] = mat("cork", (0.180, 0.120, 0.070), 0.82, 0.0, wear=0.55)

    static = []
    add = static.append

    # --- the flask, in two zones with a fill line between them ------------
    # One sphere, split at the fill height into a melt half and a glass
    # half. The split is the icon: a vessel reads as holding something
    # because you can see where the something stops. Three earlier cuts had
    # no fill line - a glowing egg, then a sea mine, then a glowing egg
    # again - and every one of them failed for that reason and not for a
    # want of detail.
    #
    # The halves are built as two squashed spheres, each hidden inside the
    # other except for the part that shows. A boolean cut would be tidier
    # and there is no boolean in this toolkit; at 64 px the seam where they
    # meet is exactly the line that is wanted anyway.
    # Lathed from a stack of truncated cones following the sphere's own
    # profile, rather than built from two spheres. Two spheres was the
    # fourth cut and it read as a white pot with an orange foot, because
    # the upper one is a separate dome sitting ON the body instead of being
    # the same curve continued - there is no way to truncate a sphere here,
    # and a lathe needs none.
    half = BODY_R * BODY_FLAT
    def profile(u):                      # u from 0 at the bottom to 1 at top
        h = (2.0 * u - 1.0)
        return BODY_R * math.sqrt(max(0.0, 1.0 - h * h)), BODY_Z + h * half
    for i in range(RINGS):
        u0, u1 = i / RINGS, (i + 1) / RINGS
        r0, z0 = profile(u0)
        r1, z1 = profile(u1)
        zone = m['melt'] if (u0 + u1) / 2 < FILL else m['glass']
        add(cone_at(0, 0, z0, max(r0, 0.012), max(r1, 0.012), z1 - z0,
                    zone, verts=44))

    # A dark band of chilled crust right at the fill line, where the melt
    # skins over against the cold wall. One ring, not a scatter of islands:
    # islands would be inside a closed flask where nothing can see them,
    # which is what the second cut got wrong.
    fr_, fz_ = profile(FILL)
    add(torus_at((0, 0, fz_), fr_ * 1.01, 0.028, m['crust'], segments=44))

    neck_z = BODY_Z + BODY_R * BODY_FLAT - 0.06
    add(cone_at(0, 0, neck_z, BODY_R * 0.44, NECK_R + 0.02, 0.16,
                m['glass'], verts=32))
    add(cyl_at(0, 0, neck_z + 0.16 + NECK_H / 2, NECK_R, NECK_H,
               m['glass'], verts=28))
    add(torus_at((0, 0, neck_z + 0.16 + NECK_H - 0.02), NECK_R + 0.022,
                 0.030, m['collar'], segments=28))
    # A small, dark stopper. Big and pale it reads as a champagne cork and
    # takes the eye off the body, which is where the colour is.
    add(cyl_at(0, 0, neck_z + 0.16 + NECK_H + 0.07, NECK_R * 0.80, 0.11,
               m['cork'], verts=20))

    return static, []


# Small frame: this is one object about a tile and a half tall and the icon
# pass fits the frame to it anyway. Rendered with --ground 0, because a
# science pack stands on nothing and a contact shadow under a flask reads as
# a smudge once it is 64 px across.
fr.run(build, frame_tiles=3)
