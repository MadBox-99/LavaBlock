-- The vanilla modules, made harder to build on the island. Each tier is
-- built on the island's next chip technology, the same part in all four
-- families, on top of everything vanilla already asks for:
--
-- - Tier 1, two silica crystals: the quartz oscillator a module keeps time
--   by. Lava crystallization is red and green science, as the modules are,
--   so the first tier comes no later than before; it only waits on the
--   crystallizer.
-- - Tier 2, a crystal circuit board: the island's own board, with a ruby, a
--   sapphire and two pyrite on it.
-- - Tier 3, two microchips, printed by EUV lithography. That puts every
--   tier 3 module behind production science and the lithography line.
--
-- The cheap part is on the first tier because the tiers multiply: a tier 3
-- module is four tier 2s and sixteen tier 1s. A speed module 3 now costs
-- sixteen silica crystals, four crystal boards - about twenty crystal
-- growings for their rubies - and two microchips on top of vanilla's.
--
-- Items only, so the electromagnetic plant still makes them.
--
-- Not alternative recipes beside vanilla's. Lava ones made modules out of
-- circuits and free lava with no advanced circuit, and their tier 3 skipped
-- Gleba's spoilage; microchip ones were a second tree of technologies for
-- the same tier 1 modules. Both made modules easier, not different.
local utils = require("lib.utils")

local FAMILIES = { "speed", "efficiency", "productivity", "quality" }

-- The recipe and technology name suffix of each tier, the part it adds and
-- the technology that part comes from.
local TIERS = {
    { suffix = "",   part = "silica-crystal",        amount = 2, tech = "lava-crystallization" },
    { suffix = "-2", part = "crystal-circuit-board", amount = 1, tech = "crystal-circuit-board" },
    { suffix = "-3", part = "microchip",             amount = 2, tech = "euv-lithography" },
}

for _, family in pairs(FAMILIES) do
    for _, tier in pairs(TIERS) do
        local name = family .. "-module" .. tier.suffix
        local recipe = data.raw.recipe[name]
        if recipe then
            table.insert(recipe.ingredients, { type = "item", name = tier.part, amount = tier.amount })
            utils.add_tech_prereq(name, tier.tech)
        end
    end
end
