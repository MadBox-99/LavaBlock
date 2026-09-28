"""Recolour the mod's gas icon for a new gas.

    make_gas_icon.py SRC DST R G B

Every gas here wears the same flame-shaped plume and only the colour says
which one it is - air, oxygen, argon, chlorine and shielding gas all share
the silhouette. So a new gas is not drawn, it is the plume of an existing
one with its shading kept and its colour swapped: the brightness of each
pixel, relative to the brightest one, scales the target colour.

    python tools/icons/make_gas_icon.py \
        ../LavaBlock-graphics/graphics/icons/gas/air.png \
        ../LavaBlock-graphics/graphics/icons/gas/carbon-dioxide.png 96 84 74
"""
import sys
from PIL import Image

SRC, DST = sys.argv[1], sys.argv[2]
TARGET = tuple(int(c) for c in sys.argv[3:6])

im = Image.open(SRC).convert("RGBA")
lum = im.convert("L")
peak = max(lum.getextrema()[1], 1)
out = Image.new("RGBA", im.size)
src, grey, px = im.load(), lum.load(), out.load()
for y in range(im.height):
    for x in range(im.width):
        k = grey[x, y] / peak
        px[x, y] = tuple(min(255, round(c * k * 1.35)) for c in TARGET) \
            + (src[x, y][3],)
out.save(DST)
print(DST)
