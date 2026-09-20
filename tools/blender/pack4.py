"""Pack a four-facing render into Factorio sprite sheets and emit the Lua.

  python pack4.py <scratch>/seq <out-dir>/lava-centrifuge

Expects <scratch>/seq/<direction>/<pass>_<frame>.png, as render_all.sh writes.

All four facings are cropped to one shared bounding box, so every direction
gets the same width, height and shift and the Lua stays readable. The render
canvas is RES x RES centred on the entity origin at 64 px/tile, so a crop's
offset from the canvas centre converts straight into the sprite `shift`.
"""
import os
import sys
import glob

import numpy as np
from PIL import Image

SEQ = sys.argv[1]
OUT = sys.argv[2]
RES = 384
PX_PER_TILE = 64
LINE_LENGTH = 8
DIRECTIONS = ("north", "east", "south", "west")
SHADOW_CUTOFF = 16


def shadowify(im, cutoff=SHADOW_CUTOFF):
    """Cycles shadow-catcher output -> the black-with-alpha PNG Factorio wants.

    The catcher already yields black RGB with the shadow in alpha; all that is
    left is to force RGB to pure black and clip the faint sampling noise that
    would otherwise stretch the crop across the whole canvas.
    """
    a = np.array(im)
    alpha = a[:, :, 3]
    alpha[alpha < cutoff] = 0
    a[:, :, :3] = 0
    return Image.fromarray(a, "RGBA")


def load(kind, direction):
    paths = sorted(glob.glob(os.path.join(SEQ, direction, kind + "_*.png")))
    frames = [Image.open(p).convert("RGBA") for p in paths]
    if kind == "shadow":
        frames = [shadowify(f) for f in frames]
    return frames


def union(boxes):
    boxes = [b for b in boxes if b]
    return (min(b[0] for b in boxes), min(b[1] for b in boxes),
            max(b[2] for b in boxes), max(b[3] for b in boxes))


def pad_even(bb, margin=2):
    x0, y0, x1, y1 = bb
    x0, y0 = max(0, x0 - margin), max(0, y0 - margin)
    x1, y1 = min(RES, x1 + margin), min(RES, y1 + margin)
    if (x1 - x0) % 2:
        x1 = x1 + 1 if x1 < RES else x1 - 1
    if (y1 - y0) % 2:
        y1 = y1 + 1 if y1 < RES else y1 - 1
    return (x0, y0, x1, y1)


def pack(kind):
    per_dir = {d: load(kind, d) for d in DIRECTIONS}
    missing = [d for d, f in per_dir.items() if len(f) == 0]
    if missing:
        sys.exit("no %s frames for: %s" % (kind, ", ".join(missing)))

    # one crop for all four facings, so they share width/height/shift
    bb = pad_even(union([f.getbbox() for fr in per_dir.values() for f in fr]))
    x0, y0, x1, y1 = bb
    w, h = x1 - x0, y1 - y0

    for d, frames in per_dir.items():
        rows = (len(frames) + LINE_LENGTH - 1) // LINE_LENGTH
        sheet = Image.new("RGBA", (w * LINE_LENGTH, h * rows), (0, 0, 0, 0))
        for i, f in enumerate(frames):
            sheet.paste(f.crop(bb), ((i % LINE_LENGTH) * w, (i // LINE_LENGTH) * h))
        path = "%s-%s-%s.png" % (OUT, kind, d)
        os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
        sheet.save(path, optimize=True)
        print("  %-6s %-5s frame=%dx%d sheet=%dx%d %4d kB"
              % (kind, d, w, h, sheet.size[0], sheet.size[1],
                 os.path.getsize(path) // 1024))

    n = len(per_dir["north"])
    sx = ((x0 + x1) / 2 - RES / 2) / PX_PER_TILE
    sy = ((y0 + y1) / 2 - RES / 2) / PX_PER_TILE
    return dict(w=w, h=h, n=n, sx=sx, sy=sy,
                file=os.path.basename(OUT) + "-" + kind)


e = pack("entity")
s = pack("shadow")

print("""
--- Lua ---
local function spin_layers(dir)
    return {
        {
            filename = GFX .. "%s-" .. dir .. ".png",
            priority = "high",
            width = %d,
            height = %d,
            frame_count = %d,
            line_length = %d,
            animation_speed = 0.5,
            scale = 0.5,
            shift = { %.4f, %.4f },
        },
        {
            filename = GFX .. "%s-" .. dir .. ".png",
            priority = "high",
            draw_as_shadow = true,
            width = %d,
            height = %d,
            frame_count = %d,
            line_length = %d,
            animation_speed = 0.5,
            scale = 0.5,
            shift = { %.4f, %.4f },
        },
    }
end""" % (e['file'], e['w'], e['h'], e['n'], LINE_LENGTH, e['sx'], e['sy'],
          s['file'], s['w'], s['h'], s['n'], LINE_LENGTH, s['sx'], s['sy']))
