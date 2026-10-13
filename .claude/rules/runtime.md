---
paths:
  - "control.lua"
  - "scripts/**/*.lua"
  - "migrations/**"
---

# Runtime scripts and migrations

## Structure

- A runtime feature is a module in `scripts/<feature>.lua`. It returns `M`
  with `M.register()`, which attaches its event handlers. It also exposes
  whatever `control.lua` has to call at init or on a config change
  (`M.rescan()`). `control.lua` requires it and calls
  `<feature>.register()` at the bottom.
- Constants sit at the top of the module in `UPPER_SNAKE`: `NAME`,
  `MAX_WIRES`, `SWEEP_TICKS`.
- One built-entity handler covers every way to build: `on_built_entity`,
  `on_robot_built_entity`, `on_space_platform_built_entity`,
  `script_raised_built` and `script_raised_revive`.

## State

- Use `storage`, never `global`.
- Initialise every `storage` table in `on_init` **and** in
  `on_configuration_changed`, as `storage.x = storage.x or {}`. Alternatively,
  use a lazy accessor like `poles()` in `scripts/island-link-pole.lua`. Saves
  made before the feature existed have to work.
- Anything rebuildable from the map (tracked entities) gets a `rescan()`,
  called from both `on_init` and `on_configuration_changed`.
- Check `.valid` on every entity and player you did not just receive.

## Technology effects

- `on_configuration_changed` calls `force.reset_technology_effects()`, so a
  new unlock on an existing technology reaches old saves without a migration.
  The `disable-recipe` pass then runs again after the reset. Keep that order.
- Custom effects use the `"nothing"` + `effect_description` pattern and are
  matched on `desc[1]`. Never match on a technology name.

## Migrations

- Rename a prototype with a JSON migration: `migrations/LavaBlock_<version>.json`.
- Re-enable or fix state with a Lua migration named after what it does
  (`migrations/recipe-tech.lua`). It starts with a comment saying what moved
  and why old saves need the fix.
- A removed prototype needs no migration. Say in the changelog what happens
  to existing copies of it.

## Messages

Player-facing text is always a locale key: `{ "lava-block.<key>", ... }`.
Never put a raw string in `print` or flying text.
