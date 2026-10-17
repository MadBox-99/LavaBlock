-- The vanilla Mk2 power armour, plated in titanium alloy. Vanilla builds it
-- from modules, processing units, motors and low density structure, with no
-- armour plate in it at all.
--
-- Twenty titanium alloy plates added.
local utils = require("lib.utils")

table.insert(data.raw.recipe["power-armor-mk2"].ingredients,
    { type = "item", name = "titanium-alloy-plate", amount = 20 })

-- Titanium alloy comes from Titanium processing.
utils.add_tech_prereq("power-armor-mk2", "titanium-processing")
