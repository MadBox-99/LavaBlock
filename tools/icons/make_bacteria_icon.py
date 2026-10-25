"""Recolour one of Space Age's bacteria icons for a bacterium of the mod's.

    make_bacteria_icon.py SRC DST HUE [SAT]

Space Age draws its iron and copper bacteria as a glistening culture, four
variations of it; a new strain should look like one more of the same
family, so it is the same picture with its hue turned. HUE is the target
hue in degrees (0 red, 60 yellow, 120 green); every pixel keeps its own
saturation and value, so the highlights and the dark edge survive. SAT
scales the saturation (default 1.0).

    python tools/icons/make_bacteria_icon.py \\
        "C:/Program Files (x86)/Steam/steamapps/common/Factorio/data/space-age/graphics/icons/iron-bacteria.png" \\
        ../LavaBlock-graphics/graphics/icons/items/leaching-bacteria.png 55 1.1

The base-game icon is the 64 px picture followed by its mipmaps in one
strip, so only the first 64 px square is read.
"""
import colorsys
import sys
from PIL import Image

SRC, DST = sys.argv[1], sys.argv[2]
HUE = float(sys.argv[3]) / 360.0
SAT = float(sys.argv[4]) if len(sys.argv) > 4 else 1.0

im = Image.open(SRC).convert("RGBA").crop((0, 0, 64, 64))
px = im.load()
for y in range(im.height):
    for x in range(im.width):
        r, g, b, a = px[x, y]
        _, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
        r2, g2, b2 = colorsys.hsv_to_rgb(HUE, min(1.0, s * SAT), v)
        px[x, y] = (round(r2 * 255), round(g2 * 255), round(b2 * 255), a)
im.save(DST)
print(DST)
