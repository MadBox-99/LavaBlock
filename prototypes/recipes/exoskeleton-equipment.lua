-- The vanilla exoskeleton, framed in titanium alloy. Vanilla frames a suit
-- a soldier has to carry in twenty steel plates; titanium alloy is as
-- strong at a little over half the weight, which is what every powered
-- exoskeleton is built of.
--
-- Twenty titanium alloy plates in place of the twenty steel plates.
local utils = require("lib.utils")

local recipe = data.raw.recipe["exoskeleton-equipment"]
for _, ingredient in pairs(recipe.ingredients) do
    if ingredient.name == "steel-plate" then
        ingredient.name = "titanium-alloy-plate"
    end
end

-- Titanium alloy comes from Titanium processing.
utils.add_tech_prereq("exoskeleton-equipment", "titanium-processing")
