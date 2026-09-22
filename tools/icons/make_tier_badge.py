"""Build the corner badges that tell the three roll crushers apart.

The machines are the same model rendered three times, so at 32 px in an
inventory slot their icons are indistinguishable - the chimney, the motor and
the oil tank that separate them are small parts at the back of the drive bed.
A badge in the corner does the job the silhouette cannot.

Each badge is written on its own 64 px canvas, already sitting in the corner,
so the prototype can lay it straight over the machine icon with no scale and
no shift. Getting that arithmetic wrong is invisible until you are in the
game; a pre-placed badge cannot be wrong.

The glyphs are the base game's own signal sprites, tinted. Colour carries
further than shape at this size, so the three are picked far apart on the
wheel - orange, blue, green - rather than for prettiness.

    python tools/icons/make_tier_badge.py [factorio-data-dir]
"""
import os
import sys
from PIL import Image, ImageDraw

DATA = sys.argv[1] if len(sys.argv) > 1 else \
    r"C:/Program Files (x86)/Steam/steamapps/common/Factorio/data"
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                   "..", "..", "graphics", "icons", "badges")

SIZE = 64
PLATE = 27                # the badge itself, on the 64 px canvas
INSET = 1                 # keeps the rim off the very edge
GLYPH = 19                # the sprite inside the plate
RADIUS = 7

# The signal icons ship as a mipmap strip - 64, then 32, 16, 8 - so only the
# leading square is the full-resolution sprite.
# Named after the machine, not the tier, so a prototype can find a badge from
# the entity name alone and no second table has to be kept in step.
BADGES = [
    ("burner-roll-crusher", "base/graphics/icons/signal/signal-fire.png",
     (255, 122, 40)),
    ("roll-crusher", "base/graphics/icons/signal/signal-lightning.png",
     (110, 200, 255)),
    ("industrial-roll-crusher", "base/graphics/icons/fluid/lubricant.png",
     None),
]


def tinted(path, colour):
    im = Image.open(os.path.join(DATA, path)).convert("RGBA")
    im = im.crop((0, 0, SIZE, SIZE))
    im = im.crop(im.getbbox())
    if colour is not None:
        # The signal sprites are flat white, so the alpha is the whole shape
        # and a straight recolour keeps its edges.
        solid = Image.new("RGBA", im.size, colour + (255,))
        solid.putalpha(im.getchannel("A"))
        im = solid
    s = GLYPH / max(im.size)
    return im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))),
                     Image.LANCZOS)


def build(name, path, colour):
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(canvas)
    x1, y1 = SIZE - INSET, SIZE - INSET
    x0, y0 = x1 - PLATE, y1 - PLATE
    # A dark plate, because the badge sits over machine art and a bare glyph
    # would be read as part of the machine.
    d.rounded_rectangle((x0, y0, x1, y1), RADIUS, fill=(22, 22, 26, 245),
                        outline=(150, 150, 158, 255), width=2)
    g = tinted(path, colour)
    canvas.alpha_composite(g, (x0 + (PLATE - g.width) // 2 + 1,
                               y0 + (PLATE - g.height) // 2 + 1))
    dst = os.path.normpath(os.path.join(OUT, name + ".png"))
    canvas.save(dst)
    print("%s  %dx%d" % (dst, SIZE, SIZE))


os.makedirs(OUT, exist_ok=True)
for b in BADGES:
    build(*b)
