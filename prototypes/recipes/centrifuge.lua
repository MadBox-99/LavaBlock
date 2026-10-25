-- The vanilla centrifuge, its rotors in stainless steel. Enriching uranium
-- spins its fluoride gas thousands of times a second, and anything that
-- corrodes in it is gone in a week; the rotors and the casing are
-- stainless.
--
-- Fifty stainless steel plates in place of the fifty steel plates.
-- Uranium processing now comes after Alloy steels.
local utils = require("lib.utils")

local recipe = data.raw.recipe["centrifuge"]
for _, ingredient in pairs(recipe.ingredients) do
    if ingredient.name == "steel-plate" then
        ingredient.name = "stainless-steel-plate"
    end
end

-- Stainless steel comes from Alloy steels.
utils.add_tech_prereq("uranium-processing", "alloy-steels")
