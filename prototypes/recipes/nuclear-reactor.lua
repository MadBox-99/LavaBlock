-- The vanilla nuclear reactor, with a stainless steel vessel and boron
-- control rods. A reactor holds its water at full temperature and pressure
-- for the life of the plant, and every real pressure vessel is clad inside
-- in stainless steel so that the water never touches carbon steel. The
-- rods that hold the chain reaction back are boron, which swallows
-- neutrons; vanilla's reactor has nothing to stop it with.
--
-- 500 stainless plates for the 500 steel plates, and 100 boron.
local utils = require("lib.utils")

local recipe = data.raw.recipe["nuclear-reactor"]
recipe.ingredients = {
    { type = "item", name = "concrete",              amount = 500 },
    { type = "item", name = "stainless-steel-plate", amount = 500 },
    { type = "item", name = "advanced-circuit",      amount = 500 },
    { type = "item", name = "copper-plate",          amount = 500 },
    { type = "item", name = "boron",                 amount = 100 },
}

-- The boron comes from Boron processing.
utils.add_tech_prereq("nuclear-power", "boron-processing")
