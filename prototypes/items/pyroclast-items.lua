-- Obsidian: unique volcanic glass mineral extracted from lava on Pyroclast
local obsidian = {
    type = "item",
    name = "obsidian",
    icons = {
        {
            icon = "__base__/graphics/icons/coal.png",
            icon_size = 64,
            tint = { r = 0.15, g = 0.1, b = 0.35, a = 1 } -- dark purple/blue (volcanic glass)
        }
    },
    subgroup = "raw-material",
    order = "z[obsidian]",
    stack_size = 200,
    weight = 2000
}

return { obsidian }
