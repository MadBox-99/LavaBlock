"""Recolour a base-game science pack flask into one of the mod's own.

    make_science_pack.py BASE-PACK OUT.png [--collar N] [--gamma G]

    make_science_pack.py utility \
        ../LavaBlock-graphics/graphics/icons/lava-science-pack.png

Why this exists rather than a `tint` in the prototype
-----------------------------------------------------
The mod's other packs are recoloured in the prototype, with an `icons` layer
and a tint, and that is the right way to do it when it works. It multiplies
the WHOLE image though, so the metal collar at the top of the flask goes
whatever colour the glass goes - the XP and circuit packs both have violet
and green collars for that reason. Factorio has no way to mask part of a
layer, so getting a flask with a steel collar means writing the file.

Why a luminance ramp rather than a multiply
-------------------------------------------
A multiply keeps the vanilla painting's brightness and only moves its hue,
so the result is always A PALE FLASK OF COLOURED LIQUID - which is what all
six vanilla packs already are. The first cut of this icon was orange at hue
16 while the automation pack sits at hue 360, sixteen degrees away, and at
32 px in the toolbar the two were hard to tell apart. Going yellower only
trades the collision: the utility pack is at hue 43.

So the difference is not hue. Source luminance is pushed through a ramp
instead: dark basalt at the bottom, glowing orange at the very top. The
facet steps of the vanilla painting survive - they are luminance steps and
the ramp is monotonic - but the reading flips from "bright liquid" to "dark
rock lit from inside", and nothing else in the row reads that way.

GAMMA is what sets how much of the flask is crust and how much is crack.
The vanilla painting is mostly bright, so without it almost every pixel
lands in the glowing end of the ramp and the icon comes out MORE orange
rather than darker. At 3.0 about two thirds of the flask sits darker than
Factorio's inventory slot.

Watch the silhouette, not just the mean: the crust must stay above the slot
background or the outline dissolves. The floor stop is there for that.
"""
import os
import sys

import numpy as np
from PIL import Image

FACTORIO = os.environ.get(
    "FACTORIO_DATA",
    r"C:/Program Files (x86)/Steam/steamapps/common/Factorio/data")
BASE_MODS = ("base", "space-age", "quality", "elevated-rails")

# Cooled basalt through to the melt showing through a crack. The first stop
# is the floor and is deliberately not black - see the silhouette note above.
STOPS = (
    (0.00, (0.050, 0.044, 0.046)),
    (0.28, (0.130, 0.060, 0.048)),
    (0.52, (0.400, 0.105, 0.030)),
    (0.74, (0.900, 0.300, 0.040)),
    (0.90, (1.000, 0.560, 0.090)),
    (1.00, (1.000, 0.850, 0.430)),
)
GAMMA = 3.0
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


def recolour(src, collar, gamma, blend=BLEND, stops=STOPS):
    a = np.asarray(src).astype(float)
    out = a.copy()
    rgb = a[..., :3] / 255.0
    lum = 0.2126 * rgb[..., 0] + 0.7152 * rgb[..., 1] + 0.0722 * rgb[..., 2]

    # Normalise over the glass only. The collar is the brightest thing in
    # the image and would otherwise eat the top of the range, leaving the
    # flask itself bunched into the dark half of the ramp.
    glass = lum[collar:][a[collar:, :, 3] > 128]
    lo, hi = np.percentile(glass, (2, 98))

    t = np.clip((lum - lo) / (hi - lo), 0, 1) ** gamma
    xs = np.array([s[0] for s in stops])
    cs = np.array([s[1] for s in stops])
    for c in range(3):
        out[..., c] = np.interp(t, xs, cs[:, c]) * 255.0

    out[:collar] = a[:collar]
    for y in range(collar, min(collar + blend, out.shape[0])):
        k = (y - collar) / float(blend)
        out[y, :, :3] = a[y, :, :3] * (1 - k) + out[y, :, :3] * k
    return Image.fromarray(np.clip(out, 0, 255).astype(np.uint8))


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if len(args) < 2:
        raise SystemExit(__doc__)
    base, out = args[0], args[1]

    def opt(flag, default):
        return sys.argv[sys.argv.index(flag) + 1] if flag in sys.argv else default

    collar = int(opt("--collar", COLLAR))
    gamma = float(opt("--gamma", GAMMA))

    # Vanilla icons ship as a 120x64 mipmap strip; the 64x64 at the left is
    # the icon itself and the rest is the pre-built mipmap chain. Factorio
    # 2.0 builds icon mipmaps itself, so this writes a plain 64x64.
    src = Image.open(find_pack(base)).convert("RGBA").crop((0, 0, 64, 64))
    recolour(src, collar, gamma).save(out)
    print("%s  <- %s-science-pack, gamma %.1f, collar kept above row %d"
          % (out, base, gamma, collar))


if __name__ == "__main__":
    main()
