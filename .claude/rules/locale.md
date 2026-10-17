---
paths:
  - "locale/**"
---

# Locale (`locale/en/LavaBlock.cfg`)

- One file, English only. Add each key to its existing `[section]`, next to
  the related entries. Never open a second copy of a section.
- Every new item, entity, fluid and technology gets a **name and a
  description**. A recipe gets a name only when it differs from its product's
  name. It gets a description only when it adds something the item does not
  say, for example a catalyst return rate.
- Technologies with numbered levels (`lava-smelting-productivity-1..4`) take
  one key without the number.
- Runtime messages go in `[lava-block]`. `technology-effect.*` keys are
  parsed by `control.lua`, so never rename one without changing the code.

## Voice

- Names are Title Case: `Lithography Machine`, `Hot Molten Salt`,
  `EUV Lithography`.
- Descriptions are plain present tense, one to three sentences, and end with
  a period. Say what it does and give the number the player plans around:
  "Destroys any fluid at 1200 per second - one pump's worth."
- Say where it fits in the island: what it is made from or what it stands in
  for. Don't write marketing text.
- Use British spelling and a spaced hyphen (` - `) as the dash.
- Use `[img=item/<name>]` for icons and `[color=...]` sparingly, for
  warnings only.
