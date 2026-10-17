-- The vanilla electric engine, built the way an electric motor is: magnets
-- that turn and coils round them that push. Vanilla builds it from an
-- engine unit and lubricant, a combustion engine dressed up as an electric
-- one.
--
-- A little more iron than before: five plates' worth of magnetite in the
-- magnet, seven in the coils and the steel and two in the circuits, which
-- is fourteen against vanilla's eleven. Far more copper, eleven plates
-- against three, and no lubricant. No fluid any more, so an ordinary
-- assembler builds it.
local utils = require("lib.utils")

local recipe = data.raw.recipe["electric-engine-unit"]
recipe.categories = { "advanced-crafting" }
recipe.ingredients = {
    { type = "item", name = "ferrite-magnet",     amount = 1 },
    { type = "item", name = "magnetic-coil",      amount = 2 },
    { type = "item", name = "steel-plate",        amount = 1 },
    { type = "item", name = "electronic-circuit", amount = 2 },
}

-- Magnets and coils come from Ferromagnetism.
utils.add_tech_prereq("electric-engine", "ferromagnetism")
