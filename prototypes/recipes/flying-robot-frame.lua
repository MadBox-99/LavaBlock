-- The vanilla flying robot frame, with a neodymium magnet in its rotor
-- motors. A drone is lifted by small brushless motors, and every one of
-- them is built round rare-earth magnets: nothing else is strong enough
-- for the weight.
--
-- One magnet a frame, a quarter of a magnet craft. Robots now wait on Rare
-- earth processing.
local utils = require("lib.utils")

local recipe = data.raw.recipe["flying-robot-frame"]
table.insert(recipe.ingredients, { type = "item", name = "neodymium-magnet", amount = 1 })

-- Neodymium magnets come from Rare earth processing.
utils.add_tech_prereq("robotics", "rare-earth-processing")
