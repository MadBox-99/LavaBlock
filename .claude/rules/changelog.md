---
paths:
  - "changelog.txt"
  - "info.json"
---

# Changelog and version

## Format

```
---------------------------------------------------------------------------------------------------
Version: 0.2.6
Date: ????
  Features:
    - Entry text, no trailing period
```

- The unreleased version keeps `Date: ????`. `fmtk publish` writes the date
  (`YYYY-MM-DD`) on release. Never fill it in by hand.
- After each release, fmtk's "moved to version" commit opens the next entry
  and bumps `info.json`. So the top entry is already the version in
  development: add to it, and don't open a new version or bump `info.json`
  unless asked.
- Categories in use, in this order: `Major Features`, `Features`,
  `Balancing`, `Changes`, `Bugfixes`, `Graphics`, `Scripting`,
  `Compatibility`, `Info`. Use no other names.

## Writing entries

- Write for players, not for the repo. Name nothing internal: no file
  names, no Lua field names, no function names.
- Give one entry per player-visible fact, in full sentences joined by commas
  or dashes, with no period at the end of the entry.
- Give the numbers: power, rates, ingredient counts, and what a ratio works
  out to ("90 an hour for a working reactor").
- For a new machine, say what its model shows, then what it does and draws,
  what it is built from, and which technology unlocks it after which
  prerequisites ("All of it is the X technology, after A, B and C").
- For a balance change, give both the old and the new number and the reason.
- For a removal, say what happens to copies that already exist in a save.
- Whenever pictures changed, add under `Changes`:
  `Needs LavaBlock-graphics X.Y.Z, which carries <what>`.
- The graphics mod (`../LavaBlock-graphics/changelog.txt`) gets the matching
  entry, under `Graphics:` only, with one line per machine or icon set:
  "Sprite sheets and icon for the X, rendered from a new model, with ...".
