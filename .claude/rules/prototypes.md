---
paths:
  - "prototypes/**/*.lua"
  - "data.lua"
  - "data-updates.lua"
  - "data-final-fixes.lua"
  - "settings.lua"
---

# Prototype conventions

## One prototype, one file, returned

- Each file returns its prototype table. It does not call `data:extend`:
  ```lua
  -- <what it is, what it is for, why these numbers>
  return {
      type = "item",
      name = "tin-plate",
      ...
  }
  ```
- Register the file in its aggregator (`prototypes/items.lua`,
  `recipes.lua`, `technologies.lua`, `fluids.lua`, `entities.lua`,
  `tools.lua`), next to the other prototypes of its production line and under
  that line's comment. **A file that is not in the aggregator does not exist
  in the game.**
- Unrelated prototypes added together still get separate files. A table plus
  a loop is only for a *family*: tiers of one machine (`entity/crusher.lua`),
  numbered levels of one technology, or recipes that are passes of one
  process (`recipes/crusher/stone-crushing.lua`). Such a file returns an
  array, and the aggregator lists each index.
- Space Age is a hard dependency. Pyroclast is optional, so guard every
  Pyroclast touch with `if mods["Pyroclast"]` in `data-updates.lua`.

## Naming

- Prototype names are kebab-case and plain, with no mod prefix:
  `microchip`, `tin-plate`, `laser-source`, `magma-reactor`.
- Use `lava-` only for a LavaBlock variant of a vanilla thing:
  `lava-science-pack`, `lava-speed-module`, `lava-mech-armor`.
- Use `lava-block-` for anything internal or global: settings
  (`lava-block-foundation-limit`), item subgroups (`lava-block-crystals`),
  surface properties (`lava-block-lava-ocean`).
- Name alternative recipes after what makes them different:
  `<product>-<method>` (`iron-smelting-cryo-cooling`, `gravel-grinding-oiled`),
  `<product>-from-<source>` (`solar-panel-from-wafers`), or
  `<new-ingredient>-<product>` (`microchip-processing-unit`).
- Name process recipes as gerunds: `basalt-crushing`, `salt-melting`,
  `crystal-growing`.
- Name recipe categories `<object>-<gerund>`: `rock-crushing`,
  `chip-lithography`, `wash-distilling`, `rolling-stock-assembling`. Never use
  a bare verb like `crushing` or `distillation`, which another mod will
  share. Explain the choice in a comment in `recipe-category.lua`.
- **Check every new name for collisions before using it.** `data:extend`
  overwrites without warning. Check vanilla + Space Age *and* Pyroclast
  (unzip `mods/Pyroclast_*.zip` and grep it). `crusher` and `obsidian` both
  shipped as silent overwrites.

## Field order

Keep this order so that files diff cleanly:

- **item:** `type, name, icon, icon_size, subgroup, order, place_result, stack_size`
- **recipe:** `type, name, categories, enabled, energy_required, ingredients, results, main_product, allow_productivity, auto_recycle`, then `icon, subgroup, order`
- **technology:** `type, name, icon, icon_size, effects, prerequisites, unit | research_trigger, order`
- **fluid:** `type, name, subgroup, default_temperature, heat_capacity, base_color, flow_color, icon, icon_size, order, auto_barrel`

## Items and icons

| Kind | Icon path | Notes |
|---|---|---|
| Placeable machine | `graphics/icons/items/<name>.png` | `subgroup = "production-machine"` (`"energy"` for generators). The entity uses the same icon |
| Intermediate / part | `graphics/icons/parts/<name>.png` | |
| Tiered machine | `utils.badged_icon(name)` | Tiers must be told apart by icon and on the map |
| Fluid | `graphics/icons/fluid/<name>.png` | |
| Gas | `graphics/icons/gas/<name>.png` | |
| Technology | `graphics/technology/<tech-name>.png` | `icon_size = 256` |

All paths are prefixed with `__LavaBlock-graphics__/`. Item icons are 64 px with
`icon_size = 64` written out, even though it is the default.

## Recipes

- A recipe that makes a fluid, or turns lava into anything, goes in its
  line's `lava-block-*` row of the Chemistry tab
  (`prototypes/item-groups/chemistry.lua`), not in vanilla's
  `fluid-recipes`. Other item recipes sit with their item.
- Write ingredients and results in full:
  `{ type = "item", name = "...", amount = N }`. No shorthand tuples.
- Use `enabled = false` unless the recipe is part of the starting kit's opening
  moves. A technology unlocks it, and the technology's header comment says why
  it belongs there.
- Set `allow_productivity = true` explicitly on processing and intermediate
  recipes. Never set it on machine recipes.
- Mark a catalyst that comes back (like the laser source) with
  `ignored_by_productivity`, so that productivity multiplies only the product.
- An alternative recipe for something that already has a recipe sets
  `auto_recycle = false`, so recycling keeps using the original. The lava
  module recipes once broke module recycling.
- **No free lunch.** Run every new loop through the arithmetic, including
  max productivity. If a round trip could net a profit, refuse productivity
  or make it a single step (see `brick-crushing`). A new route must not be
  strictly better or strictly worse than the one it sits beside.

## Technologies

- The header comment says why each prerequisite is there and what era the
  tech belongs to.
- No dead ends. Everything a technology hands over must have a use among the
  recipes unlocked by then. The Enchanted Science Pack was removed for
  breaking this.
- Science pack order follows vanilla, with `lava-science-pack` after the
  red/green/blue packs and before production, utility and space.
- Custom effects use the `"nothing"` + `effect_description` pattern from
  CLAUDE.md, never a hardcoded technology name in `control.lua`.
- A new science pack must be added to both `lab` and `biolab` in
  `data-final-fixes.lua` with `utils.add_lab_input`.

## Editing vanilla or other mods' prototypes

- Append, don't replace. Use
  `table.insert(data.raw.technology["railway"].effects, {...})`, and
  `utils.remove_recipe_unlock(tech, recipe)` to take one unlock out. Do not
  reassign the whole `effects` or `crafting_categories`, which erases what
  other mods added.
- Use the `lib/utils.lua` helpers for technology surgery:
  `remove_technology` (reconnects the tree), `replace_tech_ingredient`,
  `replace_tech_prereq`, `add_tech_prereq`.
- Guard against the prototype being absent: `if data.raw.recipe["sulfur"] then`.
- To restrict a vanilla recipe to or away from the lava world, add a
  `lava-block-lava-ocean` surface condition. Never clone it once per planet.
- A comment above each edit says what gameplay reason it serves.

## Settings

- Prefix with `lava-block-`. Use `order` letters. Add a comment explaining
  why the setting is startup rather than runtime, or the reverse.
- Every setting gets a name and a description in `[mod-setting-name]` and
  `[mod-setting-description]`.
