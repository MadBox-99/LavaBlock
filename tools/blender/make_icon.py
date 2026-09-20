"""Turn an `--pass icon` render into a 64 px Factorio item icon.

Crops to the object, fits it into a square with a small margin, and downsamples
in one LANCZOS step so the 64 px result stays crisp.
"""
import sys
from PIL import Image

SRC, DST = sys.argv[1], sys.argv[2]
SIZE = int(sys.argv[3]) if len(sys.argv) > 3 else 64
MARGIN = 2                                    # px of breathing room at 64

im = Image.open(SRC).convert("RGBA")
im = im.crop(im.getbbox())
inner = SIZE - 2 * MARGIN
s = min(inner / im.width, inner / im.height)
im = im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))), Image.LANCZOS)

out = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
out.paste(im, ((SIZE - im.width) // 2, (SIZE - im.height) // 2))
out.save(DST)
print(f"{DST}  {out.size[0]}x{out.size[1]}  content {im.width}x{im.height}")
