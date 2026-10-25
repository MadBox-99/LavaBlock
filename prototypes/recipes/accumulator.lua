-- The vanilla accumulator, as a grid store is built: cells behind an
-- inverter. Vanilla is five lead-acid batteries in an iron case, with
-- nothing to turn their direct current back into the line's.
--
-- Four batteries where vanilla takes five, two nickel plates and a
-- transformer. The nickel is Edison's nickel-iron cell beside the lead-acid
-- ones - the long-lived storage battery grids ran on before lithium - and
-- the transformer is the inverter.
--
-- Not lithium-ion cells, though the island makes them. Fulgora's
-- electromagnetic science takes an accumulator a pack and comes before
-- Aquilo, where the cells are made: an accumulator built of cells would
-- need Aquilo to reach Fulgora's science, and Aquilo needs that science.
local utils = require("lib.utils")

local recipe = data.raw.recipe["accumulator"]
recipe.ingredients = {
    { type = "item", name = "iron-plate",   amount = 2 },
    { type = "item", name = "battery",      amount = 4 },
    { type = "item", name = "transformer",  amount = 1 },
    { type = "item", name = "nickel-plate", amount = 2 },
}

-- The transformer comes from Ferromagnetism, nickel plate from Rare earth
-- processing.
utils.add_tech_prereq("electric-energy-accumulators", "ferromagnetism")
utils.add_tech_prereq("electric-energy-accumulators", "rare-earth-processing")
