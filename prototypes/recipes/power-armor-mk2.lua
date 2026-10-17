-- The vanilla Mk2 power armour, plated in titanium alloy and with
-- neodymium magnets in its joints. Vanilla builds it from modules,
-- processing units, motors and low density structure, with no armour plate
-- in it at all; a motor small enough to wear and strong enough to move a
-- suit of armour is a neodymium one.
--
-- Twenty titanium alloy plates and twenty neodymium magnets added.
local utils = require("lib.utils")

table.insert(data.raw.recipe["power-armor-mk2"].ingredients,
    { type = "item", name = "titanium-alloy-plate", amount = 20 })
table.insert(data.raw.recipe["power-armor-mk2"].ingredients,
    { type = "item", name = "neodymium-magnet", amount = 20 })

-- Titanium alloy comes from Titanium processing and the magnets from Rare
-- earth processing.
utils.add_tech_prereq("power-armor-mk2", "titanium-processing")
utils.add_tech_prereq("power-armor-mk2", "rare-earth-processing")
