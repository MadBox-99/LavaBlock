-- The vanilla night vision, with optics. A light amplifier is two lenses
-- either side of the tube that does the amplifying; vanilla builds it of
-- circuits and steel alone.
--
-- Two quartz lenses a pair. Night vision now comes after Laser cutting.
local utils = require("lib.utils")

local recipe = data.raw.recipe["night-vision-equipment"]
table.insert(recipe.ingredients, { type = "item", name = "quartz-lens", amount = 2 })

-- Quartz lenses come from Laser cutting.
utils.add_tech_prereq("night-vision-equipment", "laser-cutting")
