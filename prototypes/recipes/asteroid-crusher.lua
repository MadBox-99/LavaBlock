-- Space Age's asteroid crusher (its prototype is "crusher"; the file is
-- named apart from the island's roll crushers), with jaws of manganese
-- steel. Hadfield's steel hardens under every blow it takes, which is why
-- the jaws of real rock crushers are made of nothing else.
--
-- Ten manganese steel plates in place of the ten steel plates. Space
-- platforms now come after Alloy steels.
local utils = require("lib.utils")

local recipe = data.raw.recipe["crusher"]
if recipe then
    for _, ingredient in pairs(recipe.ingredients) do
        if ingredient.name == "steel-plate" then
            ingredient.name = "manganese-steel-plate"
        end
    end
end

-- Manganese steel comes from Alloy steels.
utils.add_tech_prereq("space-platform", "alloy-steels")
