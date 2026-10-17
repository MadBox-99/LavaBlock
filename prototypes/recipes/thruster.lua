-- Space Age's thruster, its nozzle and chamber of superalloy. A rocket
-- engine's combustion chamber runs hotter than steel melts and is only kept
-- whole by the cooling and by being nickel superalloy; vanilla builds one
-- of ten steel plates.
--
-- Ten superalloy plates in place of the ten steel plates. Every platform
-- needs thrusters, so space travel now waits on the superalloys.
local utils = require("lib.utils")

local recipe = data.raw.recipe["thruster"]
if recipe then
    for _, ingredient in pairs(recipe.ingredients) do
        if ingredient.name == "steel-plate" then
            ingredient.name = "superalloy-plate"
        end
    end
end

-- Superalloy comes from Superalloys.
utils.add_tech_prereq("space-platform-thruster", "superalloys")
