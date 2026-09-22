"""Turn an `--pass icon` or `--pass tech` render into a Factorio icon.

Crops to the object, fits it into a square with a small margin, and downsamples
in one LANCZOS step so the result stays crisp.

    make_icon.py SRC DST [size] [alpha-floor]

`alpha-floor` is for the technology pass, whose render includes a contact
shadow. The shadow fades to nothing over a wide area, so cropping on any
non-zero pixel frames the faintest fringe of it and shrinks the machine to
half the icon. Cropping at an alpha of around 10 keeps the shadow that can
actually be seen and throws away the rest.
"""
import sys
from PIL import Image

SRC, DST = sys.argv[1], sys.argv[2]
SIZE = int(sys.argv[3]) if len(sys.argv) > 3 else 64
FLOOR = int(sys.argv[4]) if len(sys.argv) > 4 else 0
MARGIN = max(2, round(SIZE / 32))             # 2 px at 64, 8 px at 256

im = Image.open(SRC).convert("RGBA")
if FLOOR:
    box = im.getchannel("A").point(lambda a: 255 if a > FLOOR else 0).getbbox()
else:
    box = im.getbbox()
im = im.crop(box)
inner = SIZE - 2 * MARGIN
s = min(inner / im.width, inner / im.height)
im = im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))), Image.LANCZOS)

out = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
out.paste(im, ((SIZE - im.width) // 2, (SIZE - im.height) // 2))
out.save(DST)
print(f"{DST}  {out.size[0]}x{out.size[1]}  content {im.width}x{im.height}")
