-- The vanilla substation, with a transformer where its six copper cables
-- were. A substation is a transformer on a pole: it steps the line down for
-- the machines round it, and six cables never did that.
local utils = require("lib.utils")

local recipe = data.raw.recipe["substation"]
recipe.ingredients = {
    { type = "item", name = "steel-plate",      amount = 10 },
    { type = "item", name = "advanced-circuit", amount = 5 },
    { type = "item", name = "transformer",      amount = 1 },
}

-- The transformer comes from Ferromagnetism.
utils.add_tech_prereq("electric-energy-distribution-2", "ferromagnetism")
