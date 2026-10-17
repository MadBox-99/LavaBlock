"""Recolour a base-game icon for one of the arc furnace's alloys.

    make_alloy_icon.py SRC DST R G B [GAIN]

Every pure metal on the island is a pile of plates stamped with its symbol,
rendered in tools/blender/parts.py. The alloys are not drawn: they are the
base game's own steel girder - steel being the one alloy vanilla has - with
its shading kept and its colour swapped, the way make_gas_icon.py does the
fluids. Solder takes the plastic bar's shape and nichrome the copper
cable's, because one is sold in bars and the other is wire.

A base-game icon is the 64 px picture followed by its mipmaps in one strip,
so only the first 64 px square is read.

    python tools/icons/make_alloy_icon.py \\
        "C:/Program Files (x86)/Steam/steamapps/common/Factorio/data/base/graphics/icons/steel-plate.png" \\
        ../LavaBlock-graphics/graphics/icons/parts/brass-plate.png 230 180 60

GAIN (default 1.15) lifts the result: the girder's brightest pixels are a
mid grey, and without it every alloy comes out a shade darker than steel.
"""
import sys
from PIL import Image

SRC, DST = sys.argv[1], sys.argv[2]
TARGET = tuple(int(c) for c in sys.argv[3:6])
GAIN = float(sys.argv[6]) if len(sys.argv) > 6 else 1.15

im = Image.open(SRC).convert("RGBA").crop((0, 0, 64, 64))
lum = im.convert("L")
peak = max(lum.getextrema()[1], 1)
out = Image.new("RGBA", im.size)
src, grey, px = im.load(), lum.load(), out.load()
for y in range(im.height):
    for x in range(im.width):
        k = grey[x, y] / peak
        px[x, y] = tuple(min(255, round(c * k * GAIN)) for c in TARGET) \
            + (src[x, y][3],)
out.save(DST)
print(DST)
