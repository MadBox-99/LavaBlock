---
paths:
  - "prototypes/entity/**/*.lua"
  - "tools/**"
  - "docs/blender-renders.md"
---

# Entities, models and sprites

The full render pipeline is in `docs/blender-renders.md`. Read it before you
model or render anything.

## Entity prototype

- Start from `table.deepcopy` of the closest vanilla prototype. Then set
  `name`, `minable`, `max_health`, `corpse`, `crafting_categories`,
  `crafting_speed`, `energy_usage`, `module_slots` and `allowed_effects`.
- Nil out whatever the copy carries that no longer fits: `next_upgrade`,
  `fast_replaceable_group`, and `circuit_connector` /
  `circuit_wire_max_distance` when the footprint changed. Also nil out the
  inherited fluid boxes when the machine takes none.
- `collision_box` is the selection box pulled in by 0.1 on each side.
- The entity `icon` is the item's icon (`graphics/icons/items/<name>.png`),
  with `icons = nil`.
- The header comment says what the machine is, its footprint, and **why**
  its power draw is that number.
- Fluid box positions: Blender +Y is north, and Factorio counts Y southwards,
  so a stub modelled at `y = +1.46` is `{0, -1}`. This sign flip has gone
  wrong before.

## Sprites

- Sheets live in `../LavaBlock-graphics/graphics/entity/<name>/`. They are
  named `<name>-<pass>-<dir>.png`, where pass is `entity`, `shadow` or
  `tint`.
- Every sheet has a spritter `.lua` beside it. `require` it for `width`,
  `height`, `line_length`, `sprite_count`, `scale` and `shift`. **Never copy
  those numbers by hand**, because a re-pack changes them.
- Layer pattern (see `entity/lithography-machine.lua`):
  `local GFX = "__LavaBlock-graphics__/graphics/entity/<name>/"`, then a
  `layer(kind, dir, extra)` helper. Draw the shadow with
  `draw_as_shadow = true`. Put the glow in `working_visualisations` with
  `blend_mode = "additive", draw_as_glow = true, fadeout = true`.
- Render the facings the prototype actually reads: four for crafting
  machines, `north east` for generators, `north` only for labs and
  unrotatable entities.
- Chimney smoke uses `utils.stack_smoke(stack)`, never the `smoke` field.
  Assembling machines silently ignore that field.

## Models (`tools/blender/<name>.py`)

- The file is named after the entity with underscores. Its docstring gives
  the `render_all.sh` command and describes the model facing north, back to
  front.
- **Nothing over the working parts.** No hoppers, cages, gantries, manifolds
  or cross beams above anything that moves. Put feed and support to the side
  or rear.
- **Tiers must look different** on the map and in the icon: recolour the
  casing (never the working parts), separate the tiers in value as well as
  hue, and badge the icons. An add-on part alone is too small to read.
- Pipes are round and straight. No square-section elbows.
- When fixing a reported visual bug, change only that element. A full
  re-render costs about an hour. Ask before touching geometry the user did
  not mention.
