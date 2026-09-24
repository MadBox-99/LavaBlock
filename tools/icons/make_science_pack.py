"""Recolour a base-game science pack flask into one of the mod's own.

    make_science_pack.py BASE-PACK OUT.png [--collar N] [--top R,G,B] [--bot R,G,B]

    make_science_pack.py utility \
        ../../../LavaBlock-graphics/graphics/icons/lava-science-pack.png

Why this exists rather than a `tint` in the prototype
-----------------------------------------------------
The mod's other packs are recoloured in the prototype, with an `icons` layer
and a tint, and that is the right way to do it when it works. It multiplies
the WHOLE image though, so the metal collar at the top of the flask goes
whatever colour the glass goes - the XP and circuit packs both have violet
and green collars for that reason. Factorio has no way to mask part of a
layer, so getting an orange flask with a steel collar means writing the
file.

What was wrong with the icon this replaces
------------------------------------------
It was a smooth airbrushed gradient. Every vanilla science pack is FACETED -
angular patches of light with hard edges - and that, not the colour, is why
the old one looked out of place beside them. Recolouring the vanilla
painting keeps the facets and changes only the hue, so the result belongs in
the row.

It was also a 120x64 packed mipmap strip while the prototype declared no
`icon_size` and no `icon_mipmaps`, so Factorio read the first 64x64 and 56
pixels of it were dead weight. Factorio 2.0 builds icon mipmaps itself; this
writes a plain 64x64.
"""
import os
import sys

import numpy as np
from PIL import Image

FACTORIO = os.environ.get(
    "FACTORIO_DATA",
    r"C:/Program Files (x86)/Steam/steamapps/common/Factorio/data")
BASE_MODS = ("base", "space-age", "quality", "elevated-rails")

# Molten rock, lit from inside: brighter and yellower at the top of the
# glass, deeper and redder towards the bottom, because that is how a pool of
# melt reads and a flat multiply does not.
TOP = (1.00, 0.52, 0.16)
BOT = (0.95, 0.20, 0.05)
# Rows of the 64 px icon that are the metal collar and stay metal. Measured
# off the art rather than guessed: the flask's neck is 16 px wide from row
# 12 down, and the ring above it is wider.
COLLAR = 10
BLEND = 3                       # rows to fade the recolour in over


def find_pack(name):
    for mod in BASE_MODS:
        p = f"{FACTORIO}/{mod}/graphics/icons/{name}-science-pack.png"
        if os.path.isfile(p):
            return p
    raise SystemExit("no such science pack: %s" % name)


def recolour(src, top, bot, collar, blend):
    a = np.asarray(src).astype(float).copy()
    h = a.shape[0]
    for y in range(h):
        if y < collar:
            continue
        # Fade in over a few rows, or the collar ends in a hard colour step.
        k = min(1.0, (y - collar) / float(blend))
        t = (y - collar) / float(max(1, h - collar))
        mul = [top[i] + (bot[i] - top[i]) * t for i in range(3)]
        for c in range(3):
            a[y, :, c] *= (1 - k) + k * mul[c]
    return Image.fromarray(np.clip(a, 0, 255).astype(np.uint8))


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if len(args) < 2:
        raise SystemExit(__doc__)
    base, out = args[0], args[1]

    def opt(flag, default):
        return sys.argv[sys.argv.index(flag) + 1] if flag in sys.argv else default

    collar = int(opt("--collar", COLLAR))
    top = tuple(float(v) for v in opt("--top", ",".join(map(str, TOP))).split(","))
    bot = tuple(float(v) for v in opt("--bot", ",".join(map(str, BOT))).split(","))

    # Vanilla icons ship as a 120x64 mipmap strip; the 64x64 at the left is
    # the icon itself and the rest is the pre-built mipmap chain.
    src = Image.open(find_pack(base)).convert("RGBA").crop((0, 0, 64, 64))
    recolour(src, top, bot, collar, BLEND).save(out)
    print("%s  <- %s-science-pack, collar kept above row %d"
          % (out, base, collar))


if __name__ == "__main__":
    main()
