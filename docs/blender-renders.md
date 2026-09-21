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
| Camera | orthographic, `rotation_euler.x = 90 - 45`, `ortho_scale` = frame tiles |
| Render | frame tiles x 64 px square, so always **64 px per tile** |
| Sprite `scale` | `32 / 64 = 0.5` |
| Model centre | world origin, which lands at the canvas centre |

`view_transform` is set to `Standard`; Blender's default AgX washes the lava
emission out to white.

### Frame size

Six tiles fits a 3x3 machine and its shadow, and that is the default. A bigger
footprint needs a bigger frame: the sun throws the shadow up and to the right
by roughly 0.56 tiles of x and 0.62 tiles of y per tile of height, so a 5x5
building 1.9 tiles tall reaches nearly four tiles from the origin on the far
side. Run off the edge and the sheet still packs, it just crops to a lie.

A model script passes its own default (`run(..., frame_tiles=9)` for the 5x5
arboretum) and `--frame-tiles N` overrides it. Nothing else changes: the pixels
per tile, and so the sprite `scale`, stay the same at any frame size.

## Passes

- **entity** — the machine on a transparent film.
- **shadow** — a ground plane with `is_shadow_catcher = True`, the machine set
  to `visible_camera = False`, and the fill light and world background turned
  off. Without that last step the catcher picks up a wide, faint ambient
  occlusion halo, which is not what a Factorio shadow sprite is. The catcher
  already writes black RGB with the shadow in alpha, so no conversion is needed
  beyond clipping sampling noise below alpha 16.
- **tint** — only the contents that Factorio recolours per recipe, on their own
  film. See *Recipe-tinted contents* below.

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
in-world machine read as the same object. It pushes the key light up a little
because an icon is read at 64 px, and renders one frame at 512 px:

```sh
blender --background --factory-startup --python tools/blender/lava_centrifuge.py -- \
        --pass icon --samples 512 --out /tmp/icon
python tools/blender/make_icon.py /tmp/icon/icon_000.png \
       graphics/icons/items/lava-centrifuge.png 64
```

`make_icon.py` crops to the object and downsamples in a single LANCZOS step,
which keeps the 64 px result crisp. Factorio 2.0 generates icon mipmaps itself,
so there is no need for the packed mipmap strip older base-game icons use.

Unlike the entity and shadow passes, the icon frame is **not** anchored on the
entity origin: it is centred and fitted to the model's own bounding box. The
world sprite has to keep a fixed origin so the sheet lines up with the tile,
but that frame is centred on the ground, and a tall machine - the water
condenser's cooling columns reach 1.6 tiles - runs straight out of the top of
it. Nothing else about the two passes differs.

## Fluid connections

Pick one of two arrangements and commit to it. Mixing them is what goes wrong.

**Modelled stubs.** Drop `pipe_picture` and `pipe_covers`, and model the port
yourself all the way out. This is what every machine in the mod does, and it
is the one that looks right here: the vanilla cover is a small brass disc
drawn flat on the ground, which reads as a spare part stuck on a machine whose
ports are modelled in perspective.

**Vanilla graphics.** Keep both, and stop the model at the body. They are
one-tile sprites drawn centred on the connection's own `position` tile - for a
3x3 machine that is the machine's own edge tile, not the neighbour's - so the
model must not reach past it. Add `secondary_draw_orders = { north = -1 }` or
the north cover lies across the middle of a tall machine.

The failure mode is doing both at once: a stub reaching to 1.46 with a cover
drawn at 1.0 leaves a brass cap floating half a tile up the body, nowhere near
the port it is supposed to cap. Worth checking by compositing
`base/graphics/entity/pipe-covers/pipe-cover-*.png` (128 px at `scale = 0.5`,
so 64 px, no shift) onto a test render at the connection tile before
committing to a sequence.

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

### Several moving parts

`build()` can return a list of `Spin` groups instead of a flat list of
objects. Each group has its own objects, its own `pivot`, its own `axis`
(`'X'`, `'Y'` or `'Z'` in entity space) and its own `degrees` over the sheet:

```python
spin.append(Spin(fan, pivot=(FX, FY, 0), degrees=60))       # flat, 6 blades
spin.append(Spin(ext, pivot=(cx, cy, 0), degrees=-60))      # the other way
spin.append(Slide(ram, axis='Z', amplitude=0.13))           # a piston
```

The loop closes when **every** `Spin` angle is a symmetry of its own part, so
they all come back together on the last frame. Negative angles are fine and
are the cheap way to make two identical assemblies not look copy-pasted. Axis
`'Y'` puts a wheel face-on to the camera; `'Z'` is a fan lying flat.

`Slide` reciprocates instead of turning: the offset is
`amplitude*sin(2*pi*f/frames)`, so it closes on its own whatever the frame
count, and it eases at both ends of the stroke the way a crank-driven ram
does. `phase` is in turns, so two rams can be given 0 and 0.5.

`Grow` scales a group along one axis about its `pivot`, which is how a tank
fills or a culture tube grows. Growth is the one motion that does not loop by
itself - a thing that gets bigger every frame has to get back to nothing - so
it fills over `hold` of the sheet and **drains** over the rest instead of
snapping back. That keeps the curve continuous at the seam, so there is no
pop. Put the pivot at the base of the thing, not its centre, or it grows in
both directions.

A ring of `Grow` groups given evenly spaced `phase` values is what makes a
rack read as a process rather than as one animation copied six times: there is
always one nearly full and one nearly empty, and they never all drain at once.
Note that staggered phases and a turntable do not combine - a rotation that
moves each pod one slot along forces every pod to the same phase, so pick one
or the other.

One turning part on a large machine reads as a still picture with a detail
stuck to it. Give a big machine two or three, at different rates - and if
everything on it spins, one part that does not is worth more than another fan.
A moving part still has to have a job: a wheel turning on the side of a
condenser is decoration, a ram pumping condensate is the machine working.

### Screens, liquid and smoke

Three things that look like they need a simulation, and do not.

**A perforated drum** is `perforated_drum()`: a thin-walled cylinder, one
boolean for the bore and a second for the joined hole cutters, with the
cutters deleted afterwards so the stray-object assert stays honest. In front
of something lit - a glowing rotor, a culture - it is worth far more than a
ring of bars, which closes up into a plain tube at this size. Its pattern
repeats every `360/per_row` degrees, so the sheet must turn it by a whole
number of those; assert that at the call site, as `lava_centrifuge.py` does.

**Moving liquid** does not want Mantaflow, and not because baking is slow: a
simulation is a transient, so its last frame never matches its first, and
nothing makes a seamless 16-frame loop out of one. A surface with N lobes
turning by exactly one lobe over the sheet closes by construction, and at 64
px a tile that is what stirred liquid looks like. The bio garden's pulp is a
cone with six lumps riding on it, turning 60 degrees.

**Smoke does not belong in the render at all.** A volume is slow in Cycles,
does not loop, and misbehaves in both the shadow pass (it confuses the shadow
catcher) and the tint pass (it will not hold out cleanly). Let Factorio draw
it: `utils.stack_smoke()` builds three working visualisations up one line,
each larger, fainter and slower than the last, which reads as a plume rising
and thinning. Two traps:

- `smoke` is a field on generators, boilers and reactors, **not** on crafting
  machines. An assembling machine ignores it in silence, so the data stage
  loads clean, `data-raw-dump.json` shows the field - it dumps the Lua table,
  not the loaded prototype - and nothing ever appears in game.
- Put the plume at the top of the machine by **measuring the sheet**, not by
  working it back from the camera angle. The tallest point is rarely over the
  entity centre, so the vertical factor comes out different for every model.
  Find the highest opaque row, take the centroid of the pixels just below it,
  and convert with the sheet's own `shift` - and do it per facing, because a
  stack that is off-centre swings across the sprite as the machine turns.

### Frame count and symmetry

Spin the parts by **one** symmetry step over the whole sheet, not several. The
air compressor turns two blade pitches (90 degrees on an 8-blade fan) across 32
frames, so frame 16 is pixel-identical to frame 0 and half the sheet is wasted.
The water condenser turns one pitch (60 degrees on a 6-blade fan) across 16
frames: every frame is unique and the sheet is half the size for the same
motion. The per-frame angle, and so the apparent speed, is what `frame_count`
and `animation_speed` decide together - a longer sheet is not a faster fan.

### Clearance around moving parts

Anything static that overlaps the swept volume reads as broken geometry, and it
is much harder to spot in a still than in motion. Work the sweep out in numbers
rather than by eye: a blade of length `L` pitched by `p` about its own axis
reaches `z_hub + (L/2)*sin(p) + (t/2)*cos(p)`, plus the bevel width. The
condenser keeps those two figures as constants next to the guard height for
exactly this reason.

`graphics_set` deliberately has no `idle_animation`: Factorio rejects an idle
animation whose frame count differs from `animation`, and with `animation`
alone the machine simply freezes on its current frame when it stops crafting.

### Recipe-tinted contents

A machine that makes several things can show which one it is making, the way
the vanilla chemical plant does: put the liquid, the culture, the glowing
charge on its own sheet and hang it off `graphics_set.working_visualisations`
with `apply_recipe_tint = "primary"`. Factorio multiplies that sheet by the
recipe's `crafting_machine_tint`, so one sheet covers every recipe, and being
a working visualisation it is drawn only while the machine runs - an idle
machine correctly shows empty glass.

Two things have to be true of the sheet.

**It must be near-neutral.** The tint is a multiply, so any hue left in the
render fights it: a green culture rendered green goes black under a red
recipe. Render the contents at around 0.72 grey and let the tint supply all
the colour. The icon pass is not tinted, so give the same material its real
colour there:

```python
m['algae'] = mat("algae", (0.72, 0.72, 0.705) if fr.PASS == 'tint'
                 else (0.095, 0.38, 0.13), 0.33, 0.0)
```

**It must be occluded correctly.** A working visualisation is drawn *over* the
entity sheet, so anything of the machine that stands in front of the contents
has to cut itself out of it. The `tint` pass does that with Cycles holdouts:
objects in `fr.TINT` render normally, objects in `fr.CLEAR` (glass, which is
already drawn in the entity sheet and must not appear twice) are hidden from
the camera, and **everything else becomes a holdout** - still in the scene, so
the contents are lit and shadowed exactly as they are in the entity sheet, but
rendering as a hole. A dome rib crossing a tube then cuts the tube out of the
tint sheet precisely where it covers it.

The same objects are hidden from the entity and shadow passes, or they would
be painted twice, once untinted. The icon keeps them: an item icon of six
empty tubes says nothing about the machine.

**Hiding them means every ray type, not just the camera.** Cycles'
`visible_camera = False` only stops an object being *seen*; it still blocks
light and casts shadows. The bio garden's pool of pulp is a disc filling the
whole thickener pan, and while the entity sheet did not show it, it laid a
shadow over everything in the pan - the dome came out with a black hole under
it and nothing in the model explained why. `hide_completely()` in
`factorio_render` clears all six visibility flags; use it, never the camera
flag alone. Objects in `fr.CLEAR` are a different case and keep their other
rays on, because the glass really is there in the entity sheet and the
contents must be lit through it the same way in both.

A dark recess modelled behind each window pays for itself - it is in the
entity sheet, so an idle machine reads as a dark porthole rather than as a
hole in the shell.

## Notes

- Cycles on OptiX occasionally dies mid-sequence with `Misaligned address in
  CUDA queue`. The script takes `--start N` so a run can resume; see the retry
  loop in `render_all.sh`.
- Validate a change with `factorio.exe --dump-data`, which runs the whole data
  stage and exits non-zero on a bad prototype.
