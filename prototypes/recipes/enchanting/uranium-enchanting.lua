-- Basic Uranium Enchanting: lava + coal -> uranium ore
-- Alternative to chemical plant recipe, uses enchanter
local basic = {
    type = "recipe",
    name = "uranium-enchanting-basic",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.1, g = 0.8, b = 0.1, a = 1.0 },
        secondary = { r = 0.2, g = 1.0, b = 0.2, a = 1.0 },
    },
    energy_required = 15,
    ingredients = {
        { type = "fluid", name = "lava", amount = 2000 },
        { type = "item",  name = "coal", amount = 20 },
    },
    results = {
        { type = "item", name = "uranium-ore", amount = 5 }
    },
    icon = "__base__/graphics/icons/uranium-ore.png",
    icon_size = 64,
    allow_productivity = true,
}

-- Advanced Uranium Enchanting: enchanted-lava + coal + sulfur -> more uranium ore
-- Better yield than basic recipe
local advanced = {
    type = "recipe",
    name = "uranium-enchanting-advanced",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.1, g = 0.8, b = 0.1, a = 1.0 },
        secondary = { r = 0.2, g = 1.0, b = 0.2, a = 1.0 },
    },
    energy_required = 10,
    ingredients = {
        { type = "fluid", name = "enchanted-lava", amount = 500 },
        { type = "item",  name = "coal",           amount = 10 },
        { type = "item",  name = "sulfur",         amount = 5 },
    },
    results = {
        { type = "item", name = "uranium-ore", amount = 15 }
    },
    icon = "__base__/graphics/icons/uranium-ore.png",
    icon_size = 64,
    allow_productivity = true,
}

return { basic, advanced }
