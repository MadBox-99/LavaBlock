-- The vanilla rocket part, with a superalloy plate in each for the engine.
-- The island's thrusters already have superalloy chambers; a rocket engine
-- burns hotter still, and its turbopump and nozzle are the same metal.
--
-- One plate a part, fifty a launch. The rocket silo now comes after
-- Superalloys, which platforms already needed for their thrusters.
local utils = require("lib.utils")

local recipe = data.raw.recipe["rocket-part"]
table.insert(recipe.ingredients, { type = "item", name = "superalloy-plate", amount = 1 })

-- Superalloy comes from Superalloys.
utils.add_tech_prereq("rocket-silo", "superalloys")
