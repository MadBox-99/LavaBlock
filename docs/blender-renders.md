# Rendering entity sprites in Blender

How the `lava-centrifuge` sprites were produced. The same setup works for any
other entity in this mod; only the model in `build()` changes.

Scripts live in [`tools/blender/`](../tools/blender/) and are excluded from the
released mod zip via `package.ignore` in `info.json`.

## The projection

Factorio's entity art is not a geometrically consistent 3D projection, so the
camera has to be matched to the base game by measurement rather than derived.
Two facts drive the setup:

1. **Volumes are seen from about 45 degrees above the ground.** Measured by
   fitting an ellipse to the bottom silhouette arc of `storage-tank.png` and by
   comparing test renders of a plain cylinder against it. 26 degrees is clearly
   too side-on, 50 degrees too top-down.
2. **Footprints stay square.** A 3x3 machine covers a full 3x3 tiles of screen,
   not 3x2.1. Base-game sprites fill their tile box in both directions.

Those two pull in opposite directions: a camera tilted to 45 degrees squashes
the ground plane by `sin(45) = 0.707`. The fix is to pre-stretch the model along
Y by `1 / sin(45) = 1.414`, which cancels the squash exactly. Ground shapes then
come out true to plan while vertical faces keep the tilted look. In the script
this is the `ROOT` empty, which everything is parented to; the rotor spins
*inside* it, so the spin stays circular in plan.

## Scale contract

| | |
|---|---|
| 1 Blender unit | 1 Factorio tile |
| Camera | orthographic, `rotation_euler.x = 90 - 45`, `ortho_scale = 6` |
| Render | 384 x 384, so 6 tiles across = **64 px per tile** |
| Sprite `scale` | `32 / 64 = 0.5` |
| Model centre | world origin, which lands at the canvas centre |

`view_transform` is set to `Standard`; Blender's default AgX washes the lava
emission out to white.

## Passes

- **entity** — the machine on a transparent film.
- **shadow** — a ground plane with `is_shadow_catcher = True`, the machine set
  to `visible_camera = False`, and the fill light and world background turned
  off. Without that last step the catcher picks up a wide, faint ambient
  occlusion halo, which is not what a Factorio shadow sprite is. The catcher
  already writes black RGB with the shadow in alpha, so no conversion is needed
  beyond clipping sampling noise below alpha 16.

The sun points west-north-west at roughly 50 degrees up, so the shadow falls to
the right and slightly down, matching the base-game shadow `shift` offsets.

## Producing the sheets

```sh
bash tools/blender/render_all.sh tools/blender/lava_centrifuge.py \
     lava-centrifuge /abs/path/to/scratch 32
cp /abs/path/to/scratch/sheets/*.png /abs/path/to/scratch/sheets/*.lua \
   graphics/entity/lava-centrifuge/
```

For an entity that cannot be rotated, add `north` as a fifth argument and only
that one facing is rendered - a quarter of the work.

Packing is done by [spritter](https://github.com/fgardt/factorio-spritter),
which crops each sheet, lays the frames out, runs oxipng, and writes a `.lua`
data file next to every sheet with its `width`, `height`, `line_length`,
`scale` and `shift`. Put the binary in `tools/bin/` (gitignored); grab the
`x86_64-pc-windows-gnu` build from its releases page.

**Ship the `.lua` files alongside the `.png`s and `require` them from the
prototype** instead of copying numbers by hand - see `lava-centrifuge.lua`.
A re-pack then needs no prototype edit at all, which matters because spritter
crops each facing separately, so all four differ.

Entity and shadow are packed in separate runs. The shadow needs `-a 16`, a
crop alpha high enough to ignore Cycles' sampling noise, which would otherwise
stretch the crop across the whole canvas. Never pass `--transparent-black` on a
shadow: it turns "black" pixels transparent, and a shadow is entirely black.

`spritter optimize` on the result saves nothing, because the spritesheet
command already runs oxipng. `--lossy` (pngquant) is a different matter: it cut
the lava centrifuge's eight sheets from 5.4 MB to 1.4 MB with differences
confined to the alpha edges and some faint dithering, invisible at the 50% the
game draws them at.

Pass `--out` an **absolute** path: Blender resolves a relative `filepath`
against the blend file root, not the working directory, and silently writes to
somewhere like `C:\seq`.

### Four facings

The fluid connections rotate with the entity, so a machine whose model shows
where its ports are has to be rendered four times; a single sheet leaves the
stubs pointing the wrong way on any rotated machine. `--direction` turns the
model via the `TURN` empty, which sits **under** `ROOT`: rotating above the Y
pre-stretch would shear the model instead of turning it. Factorio turns an
entity clockwise on screen, which is negative Z in Blender.

The lights are not parented to `ROOT`, so the sun stays put while the machine
turns, which is what you want - the shadow must keep falling the same way.

## The item icon

`--pass icon` reuses the same model, camera and Y stretch, so the icon and the
in-world machine read as the same object. It only frames tighter
(`ortho_scale = 4.3`), pushes the key light up a little because an icon is read
at 64 px, and renders one frame at 512 px:

```sh
blender --background --factory-startup --python tools/blender/lava_centrifuge.py -- \
        --pass icon --samples 512 --out /tmp/icon
python tools/blender/make_icon.py /tmp/icon/icon_000.png \
       graphics/icons/items/lava-centrifuge.png 64
```

`make_icon.py` crops to the object and downsamples in a single LANCZOS step,
which keeps the 64 px result crisp. Factorio 2.0 generates icon mipmaps itself,
so there is no need for the packed mipmap strip older base-game icons use.

## Fluid connections

If the model has its own pipe stubs, drop `pipe_picture` and `pipe_covers` from
the fluid boxes. Factorio draws them on top of the entity animation, so on a
tall machine the north one ends up lying across the middle of the body. The
base game works around this with `secondary_draw_orders = { north = -1 }`, but
with modelled stubs the graphics are redundant anyway, so removing them is the
simpler fix. `air-compressor.lua` already had them commented out for the same
reason.

Size the stubs against the vanilla pipe, or they will not read as connected:

| | tiles | px at 64/tile |
|---|---|---|
| Vanilla pipe body | 0.92 | 59 |
| Vanilla pipe flange | 1.03 | 66 |

The vanilla pipe's axis sits almost exactly at ground level on screen, because
pipes are drawn far more top-down than this camera; putting the stub's axis at
`z = 0.22` lines it up. Nothing bridges the gap to the player's pipe any more,
so check the overlap by compositing a real `pipe-straight-*.png` next to a test
render before committing to a full sequence.

## Animation

The rotor and the three counterweight arms turn 120 degrees over the 32 frames.
Because the arms are 120 degrees apart, frame 32 lands exactly on frame 0, so
the loop is seamless at any `animation_speed`.

### The spin axis

`run(build, spin_degrees=N)` turns the moving parts about the **entity centre**
by default, which is only right when the moving assembly is modelled there, as
the centrifuge rotor is. Anything mounted off-centre - the air compressor's
impeller sits front left - has to be given its own axis with
`pivot=(x, y, 0)`, or it orbits the machine instead of spinning in place. The
symptom is subtle in a still and obvious in motion.

Quick check without watching the animation: render two frames and take the
bounding box of the pixels that differ. It should cover the moving part and
nothing else.

`graphics_set` deliberately has no `idle_animation`: Factorio rejects an idle
animation whose frame count differs from `animation`, and with `animation`
alone the machine simply freezes on its current frame when it stops crafting.

## Notes

- Cycles on OptiX occasionally dies mid-sequence with `Misaligned address in
  CUDA queue`. The script takes `--start N` so a run can resume; see the retry
  loop in `render_all.sh`.
- Validate a change with `factorio.exe --dump-data`, which runs the whole data
  stage and exits non-zero on a bad prototype.
