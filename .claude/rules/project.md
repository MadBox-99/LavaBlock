# LavaBlock project conventions

Derived from the codebase as of 0.2.6. Where these rules and the generic
Factorio notes in CLAUDE.md disagree, these rules win.

## Two repos, one mod

- **LavaBlock** (this repo) holds every prototype, script and locale string.
  **LavaBlock-graphics** (sibling folder `../LavaBlock-graphics`) holds every
  sprite sheet and icon, and no Lua prototypes.
- Prototypes reference pictures as `__LavaBlock-graphics__/graphics/...`.
  Never add PNGs under this repo's `graphics/`.
- Both mods share one version number. `info.json` here depends on
  `LavaBlock-graphics >= <same version>`; bump that dependency whenever the
  graphics change.
- A change to any sheet or icon is a release of **both** mods. Release
  graphics first. A stale graphics mod raises no error, because the old path
  still resolves.

## Where things go

| What | Where |
|---|---|
| One prototype (item, recipe, tech, fluid, entity, tool) | `prototypes/<kind>/[<line>/]<name>.lua` |
| Registering those prototypes | the aggregator `prototypes/<kind>.lua` |
| Edits to vanilla prototypes that our own prototypes depend on | the matching aggregator (`recipes.lua`, `technologies.lua`) |
| Edits to other mods' prototypes (Pyroclast), tech removals | `data-updates.lua` |
| Anything that must see every mod's prototypes (generated recipes, lab inputs, scaling all panels) | `data-final-fixes.lua` |
| Runtime features | `scripts/<feature>.lua`, wired up from `control.lua` |
| Data-stage helpers (technology edits, lab inputs, icons, smoke) | `lib/utils.lua`, required as `local utils = require("lib.utils")` |
| Blender model scripts | `tools/blender/<entity_name_with_underscores>.py` |
| Icon generators | `tools/icons/` |
| Long-form docs | `docs/` (the render pipeline is `docs/blender-renders.md`) |

- `<kind>` folders are `items`, `recipes`, `technologies`, `fluids` (gases in
  `fluids/gases/`), `entity`, `tools`.
- `<line>` subfolders group a production chain: `lime/`, `crystals/`,
  `magma/`, `lithography/`, `laser/`, `crusher/`, `ethanol/`...
  Put a new prototype in its chain's folder. A new chain gets a new folder.
  Machines and their own items sit at the top level of `<kind>/`.
- File names are kebab-case and match the prototype name:
  `prototypes/items/tin-plate.lua` defines `tin-plate`.

## What ships

`info.json` → `package.ignore` excludes `.claude/`, `docs/`, `tools/`,
`CLAUDE.md`, `REVIEW.md`, scripts (`*.sh`, `*.ps1`) and node files. A new
dev-only top-level file or folder must be added there.

## Branches

- `main` is Factorio 2.0. `factorio-2.1` carries the 2.1 port (0.3.x).
- New work on `main` also has to be merged into `factorio-2.1` and ported.
  The 2.1 renames are listed in the `factorio-2-1-branch` memory.
- Do not create bare version tags (`0.2.7`). `fmtk publish` creates them and
  stops if one exists.

## Commits

- Subject: imperative, sentence case, no `feat:`-style prefix, no trailing
  period. Name the player-visible change, not the files:
  `Add the Quench Pit, a sink for any fluid`,
  `Give the Pug Mill its own model`, `Fix two dominated recipes and two early unlocks`.
- Body: prose, one paragraph per feature, with the numbers that matter.
  End with `Needs LavaBlock-graphics X.Y.Z.` when graphics changed.
- Graphics repo commits name the pictures: `Add lithography machine and train factory pictures`.
- `preparing release of version X` and `moved to version X` commits belong to
  `fmtk publish` (`npm run deploy`, author "compilatron"). Never write them by hand.

- Never add a root-level `util.lua`. It would shadow Factorio's core `util`
  for every `require("util")` in the mod.

## Known legacy deviations: don't copy, don't fix unasked

- Early recipe categories have bare names (`chemical`, `gas`, `gas-mix`,
  `arboretum`, `bio-garden`, `algae-tank`). See prototypes.md for the current rule.
- The productivity and XP-quest technology files call `data:extend`
  themselves, and `technologies.lua` requires them directly.
- `prototypes/items/storage-tank.lua` and `landfill.lua` edit vanilla
  prototypes from inside `items/`.
