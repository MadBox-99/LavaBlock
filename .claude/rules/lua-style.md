---
paths:
  - "**/*.lua"
---

# Lua style

## Formatting

- 4-space indent, no tabs. Double quotes. Trailing comma after the last field
  of a multi-line table.
- Index `data.raw` with dots for fixed type names and brackets for hyphenated
  ones: `data.raw.recipe["iron-plate"]`, `data.raw["assembling-machine"]["assembling-machine-3"]`.
- Align the `=` signs inside ingredient and result lists the way the LuaLS
  formatter does:
  ```lua
  { type = "item", name = "silicon-wafer", amount = 1 },
  { type = "item", name = "tin-plate",     amount = 1 },
  ```

## Names

- Everything is `local`. Do not add globals.
- Locals and functions are `snake_case`. File-level constants are `UPPER_SNAKE`:
  `QUENCH_AMOUNT`, `MAX_WIRES`, `XP_RATES`, `GFX`, `RECIPES`.
- A module returns a table: `utils` in `lib/`, `M` in `scripts/`.
- `require` paths use dots and start at the mod root:
  `require("prototypes.recipes.lime.lime-mortar")`. Sprite metadata from the
  graphics mod is the exception: `require("__LavaBlock-graphics__/graphics/entity/<name>/<sheet>")`.

## Comments

Comments are the main documentation of this mod, and newer files all have one.
Follow these rules when writing them:

- Every prototype file opens with a prose comment that says what the thing
  is, what it is for in the island's economy, and why its numbers are what
  they are. Placeable machine *items* are exempt, because the entity file
  carries that comment.
- Explain **why**, not what. Show the arithmetic behind each number:
  "a chemical plant cools 20 salt a second, so a reactor, which takes 40,
  needs two of them."
- Record rejected alternatives and traps when they are not obvious. Say why
  the obvious option was not used: "Not `crushing`: that is Space Age's...".
- Write comments in English with British spelling (colour, centre, grey), in
  full sentences. Use `-` dashes, not em dashes.
- Document the parameters of functions in `lib/` and `scripts/` with `@param` lines.
- Section banners (`-- ====` or `-- ----`) belong only in long top-level files
  (`control.lua`, `data-final-fixes.lua`). Prototype files never use them.

## Logging

Data-stage `log()` lines start with `[LavaBlock]`.
