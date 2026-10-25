-- The vanilla laser turret, with a laser in it. Vanilla builds one of steel,
-- circuits and batteries; the island's laser source already shows what a
-- laser is - a ruby rod pumped by light, between quartz optics.
--
-- A ruby and a quartz lens a turret, as the laser cutter takes. The turret
-- now comes after Laser cutting, for the lens; the ruby is grown long
-- before that.
local utils = require("lib.utils")

local recipe = data.raw.recipe["laser-turret"]
table.insert(recipe.ingredients, { type = "item", name = "ruby",        amount = 1 })
table.insert(recipe.ingredients, { type = "item", name = "quartz-lens", amount = 1 })

-- Quartz lenses come from Laser cutting.
utils.add_tech_prereq("laser-turret", "laser-cutting")
