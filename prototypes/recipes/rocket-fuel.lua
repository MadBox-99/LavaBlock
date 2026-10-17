-- The vanilla rocket fuel, a hybrid motor's charge: a grain of solid fuel
-- with nitrous oxide to burn it in, the way SpaceShipOne flew. Vanilla
-- soaks the solid fuel in light oil, which is a fuel without the oxidiser
-- a rocket has to carry.
--
-- 20 nitrous oxide in place of the 10 light oil: twenty ammonia and twenty
-- nitric acid a rocket fuel.
local utils = require("lib.utils")

local recipe = data.raw.recipe["rocket-fuel"]
for _, ingredient in pairs(recipe.ingredients) do
    if ingredient.name == "light-oil" then
        ingredient.name = "nitrous-oxide"
        ingredient.amount = 20
    end
end

-- Nitrous oxide comes from Ammonia synthesis.
utils.add_tech_prereq("rocket-fuel", "ammonia-synthesis")
