-- XP Lab - Dedicated lab for XP science packs only
local xp_lab = table.deepcopy(data.raw["lab"]["lab"])
xp_lab.name = "xp-lab"
xp_lab.minable.result = "xp-lab"

-- Only accepts XP science packs - keeps base lab separate
xp_lab.inputs = { "xp-science-pack" }

-- Purple/violet theme for RPG aesthetic
xp_lab.light = {
    intensity = 0.75,
    size = 8,
    color = { r = 0.7, g = 0.3, b = 1.0 }
}

-- Performance settings
xp_lab.researching_speed = 1
xp_lab.energy_usage = "100kW"
xp_lab.module_slots = 2

-- Purple tinted icon
xp_lab.icons = {
    {
        icon = "__base__/graphics/icons/lab.png",
        icon_size = 64,
        tint = { r = 0.7, g = 0.3, b = 1.0, a = 1 }
    }
}
xp_lab.icon = nil

return xp_lab
