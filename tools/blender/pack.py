"""Pack the rendered frames into Factorio sprite sheets and emit the Lua specs.

The render canvas is RES x RES centred on the entity origin at 64 px/tile, so a
crop's offset from the canvas centre converts straight into the sprite `shift`.
"""
import os, sys, glob
import numpy as np
from PIL import Image

SEQ = sys.argv[1]
OUT = sys.argv[2]
RES = 384
PX_PER_TILE = 64
LINE_LENGTH = 8


def union_bbox(paths):
    bb = None
    for p in paths:
        b = Image.open(p).convert("RGBA").getbbox()
        if b is None:
            continue
        bb = b if bb is None else (min(bb[0], b[0]), min(bb[1], b[1]),
                                   max(bb[2], b[2]), max(bb[3], b[3]))
    return bb


def pad_even(bb, margin=2):
    x0, y0, x1, y1 = bb
    x0, y0 = max(0, x0 - margin), max(0, y0 - margin)
    x1, y1 = min(RES, x1 + margin), min(RES, y1 + margin)
    if (x1 - x0) % 2: x1 = min(RES, x1 + 1) if x1 < RES else x1 - 1
    if (y1 - y0) % 2: y1 = min(RES, y1 + 1) if y1 < RES else y1 - 1
    return (x0, y0, x1, y1)


def shadowify(im, cutoff=16):
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


def pack(kind, transform=None):
    paths = sorted(glob.glob(os.path.join(SEQ, kind + "_*.png")))
    if not paths:
        print("!! no frames for", kind); return None
    frames = [Image.open(p).convert("RGBA") for p in paths]
    if transform:
        frames = [transform(f) for f in frames]
    bb = union_bbox_imgs(frames)
    bb = pad_even(bb)
    x0, y0, x1, y1 = bb
    w, h = x1 - x0, y1 - y0
    rows = (len(frames) + LINE_LENGTH - 1) // LINE_LENGTH
    sheet = Image.new("RGBA", (w * LINE_LENGTH, h * rows), (0, 0, 0, 0))
    for i, f in enumerate(frames):
        sheet.paste(f.crop(bb), ((i % LINE_LENGTH) * w, (i // LINE_LENGTH) * h))
    os.makedirs(os.path.dirname(OUT) or ".", exist_ok=True)
    path = OUT + "-" + kind + ".png"
    sheet.save(path, optimize=True)
    # crop centre relative to the canvas centre -> Factorio shift, in tiles
    sx = ((x0 + x1) / 2 - RES / 2) / PX_PER_TILE
    sy = ((y0 + y1) / 2 - RES / 2) / PX_PER_TILE
    print(f"{kind:7s} frames={len(frames)}  frame={w}x{h}  sheet={sheet.size[0]}x{sheet.size[1]}"
          f"  shift=({sx:+.4f}, {sy:+.4f})  -> {os.path.basename(path)}"
          f"  {os.path.getsize(path)//1024} kB")
    return dict(w=w, h=h, n=len(frames), sx=sx, sy=sy, file=os.path.basename(path))


def union_bbox_imgs(imgs):
    bb = None
    for im in imgs:
        b = im.getbbox()
        if b is None:
            continue
        bb = b if bb is None else (min(bb[0], b[0]), min(bb[1], b[1]),
                                   max(bb[2], b[2]), max(bb[3], b[3]))
    return bb


e = pack("entity")
s = pack("shadow", transform=shadowify)

if e and s:
    print("\n--- Lua ---")
    for tag, d, extra in (("animation", e, ""),
                          ("shadow", s, "\n            draw_as_shadow = true,")):
        print(f"""        {{
            filename = GFX .. "{d['file']}",
            priority = "high",{extra}
            width = {d['w']},
            height = {d['h']},
            frame_count = {d['n']},
            line_length = {LINE_LENGTH},
            animation_speed = 0.5,
            scale = 0.5,
            shift = {{ {d['sx']:.4f}, {d['sy']:.4f} }},
        }},""")
