-- Space Age's platform foundation, half of it aluminium. Everything that
-- has to be lifted to orbit is built light, and a station's frame is
-- aluminium for the same reason an aircraft's is.
--
-- Ten steel plates and five aluminium plates in place of twenty steel
-- plates. The rocket silo, which unlocks it, now comes after Titanium
-- processing, where aluminium is cast.
local utils = require("lib.utils")

local recipe = data.raw.recipe["space-platform-foundation"]
if recipe then
    for _, ingredient in pairs(recipe.ingredients) do
        if ingredient.name == "steel-plate" then
            ingredient.amount = 10
        end
    end
    table.insert(recipe.ingredients, { type = "item", name = "aluminium-plate", amount = 5 })
end

-- Aluminium plate is cast in Titanium processing.
utils.add_tech_prereq("rocket-silo", "titanium-processing")
