-- The vanilla low density structure, built of duralumin. Vanilla makes the
-- lightest part in the game out of twenty copper plates, the heaviest of
-- its common metals; a lightweight structure is an aluminium alloy skin
-- over a frame.
--
-- Ten duralumin plates in place of the twenty copper plates: eight
-- aluminium, one copper and one magnesium. Space Age's foundry recipe gets
-- duralumin too (casting-low-density-structure.lua).
local utils = require("lib.utils")

local recipe = data.raw.recipe["low-density-structure"]
recipe.ingredients = {
    { type = "item", name = "steel-plate",     amount = 2 },
    { type = "item", name = "duralumin-plate", amount = 10 },
    { type = "item", name = "plastic-bar",     amount = 5 },
}

-- Duralumin comes from Light metals.
utils.add_tech_prereq("low-density-structure", "light-metals")
