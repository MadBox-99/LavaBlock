-- The vanilla tank, with its armour and tracks of manganese steel. Tank
-- tracks have been cast of Hadfield steel since the First World War, for
-- the reason crusher jaws are: a face that is battered harder only gets
-- harder.
--
-- 50 manganese steel plates for the 50 steel plates: five manganese a
-- tank.
local utils = require("lib.utils")

local recipe = data.raw.recipe["tank"]
for _, ingredient in pairs(recipe.ingredients) do
    if ingredient.name == "steel-plate" then
        ingredient.name = "manganese-steel-plate"
    end
end

-- Manganese steel comes from Alloy steels.
utils.add_tech_prereq("tank", "alloy-steels")
