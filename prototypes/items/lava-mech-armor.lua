-- Create a nerfed version of mech-armor for LavaBlock start
-- Keeps all mech-armor functionality (flight, animations) but very weak stats
-- Speed is handled in control.lua via character_running_speed_modifier

if data.raw["armor"]["mech-armor"] then
    local lava_mech_armor = table.deepcopy(data.raw["armor"]["mech-armor"])

    lava_mech_armor.name = "lava-mech-armor"
    lava_mech_armor.localised_name = { "item-name.lava-mech-armor" }
    lava_mech_armor.localised_description = { "item-description.lava-mech-armor" }
    lava_mech_armor.order = "f[lava-mech-armor]"

    -- Very weak resistances
    lava_mech_armor.resistances = {
        { type = "physical",  decrease = 2,  percent = 10 },
        { type = "explosion", decrease = 5,  percent = 10 },
        { type = "fire",      decrease = 5,  percent = 30 },
        { type = "acid",      decrease = 2,  percent = 10 }
    }

    -- No inventory bonus
    lava_mech_armor.inventory_size_bonus = 0

    -- Smaller equipment grid
    lava_mech_armor.equipment_grid = "small-equipment-grid"

    data:extend({ lava_mech_armor })
end
