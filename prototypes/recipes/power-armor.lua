-- The vanilla power armor, framed in titanium alloy, as the exoskeleton and
-- power armor MK2 already are. A suit that carries its own reactor and
-- motors cannot also carry forty steel plates.
--
-- Twenty titanium alloy plates in place of the forty steel plates: the
-- same strength at a little over half the weight.
local utils = require("lib.utils")

local recipe = data.raw.recipe["power-armor"]
local ingredients = {}
for _, ingredient in pairs(recipe.ingredients) do
    if ingredient.name == "steel-plate" then
        table.insert(ingredients, { type = "item", name = "titanium-alloy-plate", amount = 20 })
    else
        table.insert(ingredients, ingredient)
    end
end
recipe.ingredients = ingredients

-- Titanium alloy comes from Titanium processing.
utils.add_tech_prereq("power-armor", "titanium-processing")
