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
   ../LavaBlock-graphics/graphics/entity/lava-centrifuge/
```

**Sheets do not live in this mod.** `graphics/` was split out into
`LavaBlock-graphics`, a sibling mod that holds every sheet and icon and
declares no prototypes at all, so that a release touching only recipes,
balance or text does not make everyone download eighty megabytes of
unchanged machines. Prototypes reference it as
`__LavaBlock-graphics__/graphics/...`, including the `require()` of a
sheet's `.lua` metadata, and `LavaBlock` carries a hard dependency on it.

The two are versioned together. A render that changes a sheet is a release
of the graphics mod; forgetting it leaves everyone on the old pictures with
no error to warn them, because the path still resolves.

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
Four is the count for a **crafting machine**. Two other prototype types in
this mod want different numbers, and rendering the wrong count is either a
broken sheet or half an hour of GPU thrown away:

| prototype | animations it asks for | render |
|---|---|---|
| assembling-machine, furnace | `graphics_set.animation.{north,east,south,west}` | all four |
| generator | `vertical_animation`, `horizontal_animation` | `"north east"` |
| lab | `on_animation`, `off_animation` | `north` only |

A generator is never drawn facing south or west - the game mirrors nothing
and simply uses the two it has - so `render_all.sh <model> <name> <dir> 32
"north east"` is the whole job, and north is the vertical sheet because the
model's long axis runs north-south. A lab has no facing at all, which makes
it the cheapest sheet here; its idle animation is the running sheet read one
frame deep, so `off_animation` needs no render of its own.


The fluid connections rotate with the entity, so a machine whose model shows
where its ports are has to be rendered four times; a single sheet leaves the
stubs pointing the wrong way on any rotated machine. `--direction` turns the
model via the `TURN` empty, which sits **under** `ROOT`: rotating above the Y
pre-stretch would shear the model instead of turning it. Factorio turns an
entity clockwise on screen, which is negative Z in Blender.

The lights are not parented to `ROOT`, so the sun stays put while the machine
turns, which is what you want - the shadow must keep falling the same way.

### Depth separates badly, width separates perfectly

Two identical parts set apart along **Y** do not read as two. The projection
collapses a depth offset to `d / sqrt(2)` on screen, so parts of diameter `w`
only show daylight between them once `d > w * sqrt(2)` - and at that spacing
they are no longer obviously one assembly. Anything short of it and the near
part simply eats the far one: same material, same silhouette, no gap, one
blob. The crusher's two rolls were laid out this way first and the pair read
as a single studded slab.

Set apart along **X** the offset survives the projection untouched, `d > w` is
enough, and the gap between them is a clean vertical slot. So: whenever the
point of a model is that there are *two* of something, stand them side by
side across the sprite, never one behind the other.

The catch is that a rotated facing turns X into Y. The crusher's rolls are
unmistakable facing north and south and merge into one mass facing east and
west, and there is no arrangement that avoids it - a pair can only be
side-by-side on one axis. Pick the axis that makes the default facing right.

### A curve in a plane of constant X has no shape on screen

The same projection has a sharper edge to it. Screen height is driven by
`y + z` and screen width by `x` alone, so **every point of a shape built in a
plane of constant X lands on one vertical line.** Whatever the shape is, that
is all it can ever be.

The air filter's arched pipes were built fore-and-aft first, as semicircles
in the planes `x = +-0.62`, on the reasoning that this kept them clear of the
impeller in all four facings. They rendered as two orange stripes. The
objects were all there - a dump of the scene listed every segment at the
right place, up to `z = 2.39` - and half an hour went into hunting for a
culling bug that did not exist before the projection was the answer.

An arch, a hoop, a bent pipe, anything whose point is that it *curves*, has to
span **X**. Which then puts it across the sprite, and usually across whatever
is in the middle of the machine - so give it a `y` behind the moving part
rather than in front. North of the part it is drawn over *by* the part, which
satisfies both the shape and the rule about nothing covering the working
parts; south of it, it covers them.

### A hole needs an inner wall

There is no primitive for a ring, and the obvious substitute does not work:
a dark disc laid on top of a solid deck is a painted circle, not a hole. At
45 degrees a hole is known by the *inner wall* the camera can see down into
on the far side, and a disc has none.

The fix is a boolean, which is already part of this toolkit -
`perforated_drum` cuts its bore the same way. An `annulus` helper is eight
lines: add a cylinder, add a smaller one, subtract, delete the cutter. The
Quench Pit's deck is one.

Two numbers decide whether the hole reads. Depth from the lip down to
whatever is at the bottom wants to be most of the hole's radius - at half
that, the far wall shows too little of itself and the pit looks like a bowl.
And a **raised kerb** around the lip is what separates deck from drop; flush
with the deck the edge has no shadow line and the hole goes back to looking
painted on. The pit's first cut had a deck 0.56 tall and read as a full
pool; at 0.70 with a 0.11 kerb it reads as a shaft.

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

### The technology icon

`--pass tech` renders the same model as a **product shot**, which is what
base-game technology icons are and what the map sprite is not. Three things
change, and all three matter:

- **A perspective camera, lower and swung round** (`TECH_ELEV`, `TECH_AZ`,
  `TECH_LENS`). The map camera is orthographic at 45 degrees and dead ahead;
  reused at 256 px it produces a large copy of the sprite, which reads as a
  screenshot pasted into the tech tree rather than a picture of a thing.
- **No Y pre-stretch.** That stretch exists only to square the footprint up
  under the 45 degree camera. This camera is free of the convention, so the
  pass resets `ROOT` to 1 - otherwise the machine comes out half again too
  deep.
- **A contact shadow inside the picture.** A shadow-catcher plane with a
  transparent film puts the shadow into the alpha, and the sun is steeper and
  much softer than the map sun. The sprite sun deliberately throws a long hard
  shadow sideways, because Factorio draws that as its own layer; inside a
  single icon the same shadow reads as a second object and shoves the machine
  out of the frame.

```sh
blender --background --factory-startup --python tools/blender/crusher.py --         --pass tech --frames 1 --samples 256 --out /tmp/tech --variant burner
python tools/blender/make_icon.py /tmp/tech/tech_000.png        graphics/technology/stone-crushing.png 256 10
```

The trailing `10` is an alpha floor. The contact shadow fades to nothing over
a wide area, so cropping on any non-zero pixel frames the faintest fringe of
it and leaves the machine at half size in the middle of the icon.

Name the file after the **technology**, not the machine: a technology that
unlocks several things still needs one picture, and the tech is what the file
is for.

**The shadow catcher hides everything below it.** It stands in for the
background, so a model that reaches under z = 0 simply loses that part, and
the giveaway is subtle: nothing looks broken, the subject just comes out
small with a clean horizontal cut where the ground is. The crusher roll
rendered as half a drum this way, the condenser coil as a row of half-moons,
and the culture column as everything above its middle hoop. `parts.py` now
calls `sit_on_ground()` before rendering, which drops the whole part onto
z = 0 — so a part can still be authored about its own centre, which is the
natural way to build one. A model built for `--ground 0`, like a fluid
droplet, is exempt because it has no catcher under it.

**Machine icons take `--pass icon`, not this one.** The technology pass is
for the tech tree; an item icon rendered with it is lit and framed unlike
every other machine in the inventory, and next to its neighbours it reads as
belonging to a different mod. The rule is simply which list the picture ends
up in: `graphics/technology/` gets the tech pass, `graphics/icons/items/`
gets the icon pass, and `graphics/icons/parts/` gets the tech pass because a
part is a product shot rather than a building on a map.

### Tiers of the same machine

Three tiers rendered from one model with a different part bolted on each -
a chimney, a motor, an oil tank - look identical everywhere the player
actually meets them. On the ground a 3x3 machine is about 90 px, and a part
small enough to sit on the drive bed is a handful of pixels inside that; in
an inventory slot the whole machine is 32 px. The add-on is the right way to
build the model and the wrong thing to rely on for telling tiers apart.

Two things fix it, and both are needed:

**Paint the casing, not the working parts.** Give each tier its own body
colour and leave whatever says what the machine *does* alone. On the roll
crushers the bed, the switchgear, the bearing housings and the engine
cylinders are tiered - dark rust, steel grey, ochre - and the rolls and
their teeth are the same steel in all three. Recolour the rolls too and the
tiers stop reading as one family and start reading as three unrelated
machines.

Separate them in **value as well as hue**. Three colours of the same
brightness collapse into one grey at night, in a screenshot, and for a
colourblind player. Dark, mid, bright is worth more than red, green, blue.

Watch the brightness ceiling while picking: this sun is hard, and a whole
body in the mod's `yellow` blows out the same way a small horizontal steel
face does. The ochre used here is deliberately duller than that paint.

**Badge the icon.** At 32 px even a body colour is a wash, and the reliable
signal is a small high-contrast glyph. Put it in the **top right**: Factorio
prints the stack count across the bottom of an inventory slot, and a badge in
either bottom corner is read over by the number. Draw it on its own full-size
canvas, already sitting in that corner, and lay it over the machine icon as a
second `icons` layer with no `scale` and no `shift`:

```lua
icons = {
    { icon = ".../icons/items/" .. name .. ".png",  icon_size = 64 },
    { icon = ".../icons/badges/" .. name .. ".png", icon_size = 64 },
}
```

The arithmetic behind `scale` and `shift` can only be checked by loading the
game; a badge pre-placed on the canvas cannot land in the wrong place. Name
the badge file after the entity and no second table has to be kept in step.
`tools/icons/make_tier_badge.py` builds them from the base game's own signal
sprites, tinted.

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

## Materials

`mat(name, base, rough, metal, emit=, emit_str=, wear=)`. The first four are
ordinary Principled inputs. Two of them have a catch.

**`wear` is a switch, not a dial.** It looks like a blend strength and it is
not. The function sets the mix factor to `wear` and then links a noise ramp
over that same input, so the authored number is discarded and the factor
swings the whole way from 0 to 1 across the noise. Wherever the ramp reaches
1 the patch takes the *full* darkened colour - `base * 0.42 + 0.045` - no
matter whether `wear=0.85` or `wear=0.05` was passed. What `wear` actually
controls is whether the grime is wired up at all.

On the dark greys and ochres every machine here is built from, that is
exactly the weathering the mod wants. On a light colour it is ruinous: the
air filter's cartridges are meant to be the only white thing in the mod and
came out of the first render as stacks of dark coins. **A part that has to
stay light must be given no `wear` at all.**

**Emission above about 1.5 clips to white.** The Standard view transform has
no tonemapping, so a glow authored to look right in a swatch comes back as a
white shape with no colour left in it. The crystallizer's amethyst sits at
0.26, the gas combiner's sight glass at 1.15, and the geothermal turbine's
feed pipe had to be dropped to 1.10 - at the shared `lava` material's 1.9 a
thin pipe reads as a strip light painted on the casing rather than as
something hot inside a pipe. Big open pools can take 1.9; pipes and windows
cannot.

**But 1.5 is the ceiling for *white*, not the ceiling for a colour.** A warm
emission is far from balanced - `(1.00, 0.34, 0.05)` puts nearly all of its
energy in red - so the red channel saturates long before the strength reaches
anything like 1.5, and once it does, only green and blue are still climbing.
The colour then walks up towards yellow while the picture is nowhere near
white. The air filter's impeller glow was authored at 1.15 on that reasoning
and came back lemon; at 0.45 it is orange. For a warm colour the number to
watch is `emit_str * emit.r`, and it wants to stay under about 0.5.

**Which way round a lit part is lit changes how far it carries.** The same
impeller built as orange blades on a dark face, and as dark blades on a lit
disc, is not the same sprite at 64 px. Emitting blades bloom into each other
and sixteen of them fuse into one bright wheel with no blade in it; dark
blades over a lit disc stay sixteen blades however small the sprite gets,
because the reader is tracking the gaps and the gaps are the bright part.
When a small round thing has to read as *turning*, light the hole and not the
spokes.

**A big lit area is the same trap from the other side.** The Quench Pit's
melt is a disc 1.7 tiles across, and the first cut was one orange disc with
four dark plates on it: a flat light with dirt on it, no depth and nothing
to look at. Inverted - crust plates covering about two thirds, the glow
coming up through the cracks between them - the same disc reads as molten
rock, because now the bright parts are thin and irregular and the eye has
edges to follow. The mod's science pack icon works for the same reason.

Both cases give one rule: **on a lit area the eye reads the dark shapes, so
put the detail in what blocks the light, not in what emits it.**

And the area itself sets the strength. `emit_str * emit.r` near 1 is fine
for a pool at this size but the shared `lava` material's 1.9 is not - over
1.7 tiles the red channel saturates across the whole disc and the pit goes
lemon, which is the warm-colour ceiling above applied to a large area rather
than a small one.

## Animation

The rotor and the three counterweight arms turn 120 degrees over the 32 frames.
Because the arms are 120 degrees apart, frame 32 lands exactly on frame 0, so
the loop is seamless at any `animation_speed`.

### The spin axis
**On a four-way machine, prefer axis `Z`.** A wheel on axis `Y` stands up
facing the camera, which is what makes it read as turning - but only in two
of the four facings. Turn the machine ninety degrees and its axis now runs
across the screen, the wheel is seen edge-on, and the animation is gone. The
geothermal turbine lost both its moving parts to this in the horizontal
sheet and had to be rebuilt around it; the fix there was to raise the
flywheel until its top stands clear above the casing, and to move the second
moving part to a fan lying flat. A part lying flat is seen from above
whichever way the machine is turned, because the camera looks down at
45 degrees in every facing.

So: a generator or a lab, which have one or two fixed facings, can use a
camera-facing wheel freely. A rotatable machine should put its motion on
`Z` unless the standing wheel is tall enough to clear everything around it.

The gas combiner shipped with this fault for a release. Its blower wheel
stood facing the camera, and the comment above it argued the case
correctly - a wheel on the end of that drum turns about an axis pointing
across the screen and would be seen edge-on - while reasoning about the
north facing only. Rotating the machine is what turns a `Y` axis into an
`X` one, so the wheel disappeared entirely in the east sheet and came back
as a single brass line in the west. The fix was a centrifugal blower with
an upright shaft: same part, same job, impeller lying flat.

**Look at the difference image; do not trust a pixel count on its own.**
Subtract two frames, scale the result up and look at it. Every moving part
shows as a bright blob and everything else is black, so one picture per
facing answers the question outright - and it is the only form of this test
that cannot mislead you. The gas combiner's four now show exactly two blobs
each: a six-pointed star where the impeller turns and a small disc where
the dosing ram rides.

```python
a = np.asarray(frame(facing, 0).convert("RGB"), int)
b = np.asarray(frame(facing, 4).convert("RGB"), int)
Image.fromarray(np.clip(np.abs(a - b).sum(2) * 2, 0, 255).astype(np.uint8))
```

Counting the changed pixels is a useful summary **only between two renders
of the same model at the same settings**, one facing against the same
facing. Comparing the standing wheel against the flat impeller that way, at
512 px and 80 samples:

| facing | standing wheel | flat impeller |
|--------|---------------:|--------------:|
| north  |            999 |          1406 |
| east   |            570 |          1272 |
| south  |            971 |          1307 |
| west   |            510 |          1222 |

Two facings carrying half the motion of the other two is the signature, and
the residue in those two is whatever *else* moves.

Two ways to fool yourself with that number, both of which I did:

* **Comparing against the shipped sheets.** spritter crops and scales them,
  so their counts share no scale with a raw render and the comparison says
  nothing. It said the old model moved *more*.
* **Taking the bounding box of the changed pixels.** Cycles noise is
  scattered over the whole sprite and a sheet's frame edges bleed, so the
  box covers almost the entire frame however small the real motion is.
  Raising the threshold does not help; it thins the noise without moving
  the box.


`run(build, spin_degrees=N)` turns the moving parts about the **entity centre**
by default, which is only right when the moving assembly is modelled there, as
the centrifuge rotor is. Anything mounted off-centre - the air compressor's
impeller sits front left - has to be given its own axis with
`pivot=(x, y, 0)`, or it orbits the machine instead of spinning in place. The
symptom is subtle in a still and obvious in motion.

Quick check without watching the animation: render two frames and take the
bounding box of the pixels that differ. It should cover the moving part and
nothing else.

### Swing: a part the machine does not drive

`Spin` turns a thing that is driven and `Slide` strokes a thing that is
pushed along a line. `Swing` is for a part that is *moved by* what the
machine does rather than by a shaft: a louvre blade, a hanging plate, a
damper flap. It rocks its group about a hinge by
`degrees*sin(2*pi*(f/frames + phase))`, which closes its own loop and eases
at both ends of the travel the way something moved by a fluid settles.

Its hinge is an **arbitrary vector**, not one of X, Y and Z, because a plate
on the flank of a round body hinges about a line that is tangential there -
axis-aligned at only four places round the ring. It asks Blender for the
rotation in axis-angle form, so no euler composition is needed.

Two things to get right:

- **Hinge along the top, and put the whole plate in one group.** Split the
  segments of one plate across several groups and each rocks about its own
  top, so the plate shears apart instead of swinging.
- **Give a ring of plates evenly spaced phases.** `phase=i/count` runs the
  movement round the machine as a wave; without it every plate flaps in
  unison and it reads as one animation copied N times rather than as air
  moving through a building.

Anything the plate ends in - a thicker block at the bottom, say - must be in
the swinging group too. A static foot under a swinging plate is lifted clear
on every stroke and flashes whatever is under it.

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

#### One asymmetric part sets the price for the whole group

Everything on a `Spin` shares its closing angle, so the least symmetric part
decides it. A ring of six bolts on a roll that closes on a 14-tooth pitch
(360/14) does not land back on itself and the sheet jumps at the wrap; move
the bolts onto the static bearing cap and the problem is gone. A crank arm
cannot be moved off - it is the thing that has to turn - so it forces the
group to close on a whole 360.

That in turn caps how finely the rest of the group may be patterned. A
repeating pattern advancing more than about **0.4 of its own pitch per frame**
reads as crawling backwards, and on a group closing on a full turn the step is
exactly `count / FRAMES` of a pitch. So `count < 0.4 * FRAMES`: 12 teeth need
32 frames, and at 16 frames the same roll could only carry 6. Pattern count
and frame count are one decision, not two.

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

## The GPU

Renders run on OptiX. The card here is a GTX 1660 Ti with 6 GB, and the
desktop is on the same card, so the amount left for Cycles depends entirely
on what else is open — Factorio and a browser between them take about four
and a half gigabytes.

That matters, because **OptiX does not report running out of video memory as
running out of video memory**. The allocation fails inside a kernel and comes
back as `Illegal address in CUDA queue`, which reads like a driver bug. If a
render dies with that one, close the game and the browser before blaming
anything else.

**Do not stop there, because a second fault looks the same and is not that.**
`Misaligned address in CUDA queue`, in `integrator_shade_surface` or
`integrator_compact_shadow_states`, turns up on this card with five gigabytes
free, and only in the **shadow** pass — the crystallizer's entity and tint
passes rendered all four facings clean while its shadow pass faulted
twenty-one times. It looks like a driver fault in OptiX's shadow path on a
1660 Ti, which is Turing without RT cores.

**"No amount of free memory prevents it" was written here, and it was too
strong.** It came back later on the air filter, again in the shadow pass
only — but that time with **1.65 GB free, not five**, and it stopped coming
back the moment the memory did. The reason the memory was that low is the
lesson: two *abandoned* renders were still running. Stopping a background
render kills the shell, not the Blender under it, and `render_all.sh`'s
retry loop then relaunches Blender as fast as you can kill it — so an
abandoned run keeps rendering, holding VRAM and competing for the CPU that
feeds the GPU. Kill the shell **and** its Blender together, matching on the
output directory:

```sh
# PowerShell; match the scratch dir of the run being abandoned
$ids = Get-CimInstance Win32_Process |
       Where-Object { $_.CommandLine -match '<outdir>' -and
                      $_.Name -match 'bash|blender' } |
       Select-Object -ExpandProperty ProcessId
Stop-Process -Id $ids -Force
```

The same two orphans also made every timing on that run meaningless: GPU
frames came out five times slower than the same pass on a quiet machine.
Check what else is on the card before concluding anything from a render
time. So: shadow-pass faults correlate with memory pressure much more than
this section first claimed. Survivable either way — see the fallback and the
relaunch loop below — but look at free VRAM and at stray processes first.

`factorio_render.py` handles this in three places:

- **It prints the free memory at startup** and warns below 1.5 GB, because no
  other line in the log will tell you the fix is to close something.
- **It enables only the devices of the backend it chose.** The device list
  holds the same card twice, once as CUDA and once as OptiX, and the CPU once
  — and the CPU entry is shared between backends. Switching all of them on,
  which is the obvious loop to write, quietly enables hybrid CPU+GPU
  rendering: the scene then lives in host memory as well as in VRAM, and at
  64 to 256 px the GPU has finished the frame before the CPU has finished its
  first tile. That was the old behaviour, and it is where most of these
  failures came from.
- **It falls back to the CPU on the first failed frame** and stays there for
  the rest of the run. Not a GPU retry first: when this card goes, it goes
  several times in a row.

  Falling back means turning the *backend* off — `compute_device_type` to
  `NONE`, every device but the CPU unticked — not just setting
  `scene.cycles.device`. A faulted kernel poisons the CUDA context, and the
  scene-level device only says which device to use; it does not tell the
  add-on to let go of the context it already holds. Setting it alone gets
  `Failed to retain CUDA context` on every frame after the first, which is
  exactly what the first version of this did.

`--device CPU` forces it from the start. Some subjects need that anyway; a
fluid droplet is small enough that the CPU costs nothing.

**The outer retry loop is the real answer, not the fallback.** A fresh
process gets a fresh CUDA context and is back on the GPU, and resuming costs
one frame. That is what carried the crystallizer's north shadow pass to
32/32: six launches, every frame on OptiX. Finishing a long sheet on the CPU
would have been correct and very slow, so treat the in-process fallback as
the safety net for one frame and `render_all.sh` with `--start N` as the plan.

If Blender does not merely error but dies, no Python in the script can catch
it — that is the other thing the outer loop is for.

## Notes

- Validate a change with `factorio.exe --dump-data`, which runs the whole data
  stage and exits non-zero on a bad prototype.
