"""Droplet icons for the mod's own fluids.

  blender --background --factory-startup --python fluid_icon.py -- \
          --pass tech --frames 1 --ground 0 --out DIR \n          --fluid liquid-nitrogen

Every fluid icon in Factorio is the same droplet seen from the same angle,
and that sameness is the point: the silhouette says "this is a fluid" and
the colour says which one. So this script builds one droplet and only the
material changes between fluids - a bespoke shape per fluid would read as a
different kind of thing, not a different fluid.

The droplet is a sphere whose upper half is tapered to a point, rather than
a cone stuck on a ball: a real teardrop has no seam where the shoulder meets
the tip, and at 64 px a seam is the only thing you would see.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import bpy                                                    # noqa: E402
from mathutils import Vector                                  # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import mat                               # noqa: E402

FLUID = fr.arg('--fluid', 'liquid-nitrogen')

# Base colour and roughness. These are much darker than the colour you want to end up with. The icon
# pass turns the sun up hard - an icon is read at 64 px with no scene around
# it - and a base colour picked to look right in a swatch comes back white.
FLUIDS = {
    # Cold blue, not a saturated primary one: this is the coldest thing on
    # the island, and it has to stay apart from vanilla water's teal.
    'liquid-nitrogen': ((0.062, 0.180, 0.435), 0.09),
}
assert FLUID in FLUIDS, "%s is not one of %s" % (FLUID, sorted(FLUIDS))

TAPER = 0.75        # how sharply the top half pinches in towards the tip
DRAW = 1.15         # how far past the sphere the tip is pulled

# A droplet does not stand on anything, so this is always rendered with
# --ground 0 and casts no shadow at all. See the header for the command.


def droplet(m):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=64, ring_count=40, radius=1.0)
    o = bpy.context.object
    for v in o.data.vertices:
        t = max(0.0, v.co.z)              # 0 at the equator, 1 at the top pole
        pinch = (1.0 - t) ** TAPER        # collapses to nothing at the pole
        v.co.x *= pinch
        v.co.y *= pinch
        # Height about one and a half times the width, which is the
        # proportion every fluid icon in the game is drawn at. The first
        # version stretched too little and came out a cone.
        v.co.z = v.co.z + t * DRAW
    o.data.materials.append(m)
    return o


def highlight():
    """A small bright panel, purely to be reflected.

    The pass lights with two suns, and a sun nine degrees wide reflects in a
    glossy surface as a broad soft sheen - which is why the first version came
    out matte beside the base game's droplets. Those are painted with one hard
    streak down the upper left, and the way to get a streak is to put
    something streak-shaped in front of the thing.
    """
    bpy.ops.object.light_add(type='AREA', location=(-2.0, -2.5, 3.8))
    lo = bpy.context.object
    lo.data.shape = 'RECTANGLE'
    lo.data.size, lo.data.size_y = 0.35, 2.0
    # Bright enough to out-shine the fill where it reflects, and no
    # brighter: at three times this the streak stops being a streak and
    # becomes a white hole with a blue edge.
    lo.data.energy = 2200
    lo.rotation_euler = (Vector((0, 0, 0.7)) - Vector(lo.location)).to_track_quat(
        '-Z', 'Y').to_euler()


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    base, rough = FLUIDS[FLUID]
    # No wear texture. Grime is what makes machinery read as Factorio art and
    # what makes a liquid read as dirty.
    m = mat(FLUID, base, rough, 0.0)
    # A wet coat. A bare dielectric at this roughness reflects about four
    # percent and reads as painted plastic; the coat is what makes it liquid.
    b = m.node_tree.nodes['Principled BSDF']
    b.inputs['Coat Weight'].default_value = 0.85
    b.inputs['Coat Roughness'].default_value = 0.03
    highlight()
    return [droplet(m)], []


fr.run(build, frame_tiles=3)
