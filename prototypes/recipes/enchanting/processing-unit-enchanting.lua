-- Basic enchanting: 40 -> 41 (2.5% bonus)
local basic = {
    type = "recipe",
    name = "processing-unit-enchanting-basic",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.0, g = 0.0, b = 0.8, a = 1.0 },
        secondary = { r = 0.2, g = 0.2, b = 1.0, a = 1.0 },
    },
    energy_required = 30,
    ingredients = {
        { type = "item",  name = "processing-unit",  amount = 40 },
        { type = "fluid", name = "fusioning-lava",   amount = 500 },
    },
    results = {
        { type = "item", name = "processing-unit", amount = 41 }
    },
    main_product = "processing-unit",
}

-- Advanced enchanting: 20 -> 22 (10% bonus)
local advanced = {
    type = "recipe",
    name = "processing-unit-enchanting-advanced",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.0, g = 0.0, b = 0.8, a = 1.0 },
        secondary = { r = 0.2, g = 0.2, b = 1.0, a = 1.0 },
    },
    energy_required = 25,
    ingredients = {
        { type = "item",  name = "processing-unit",         amount = 20 },
        { type = "fluid", name = "stronger-fusioning-lava", amount = 500 },
    },
    results = {
        { type = "item", name = "processing-unit", amount = 22 }
    },
    main_product = "processing-unit",
}

-- Ultimate enchanting: 10 -> 13 (30% bonus, requires extra materials)
local ultimate = {
    type = "recipe",
    name = "processing-unit-enchanting-ultimate",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.0, g = 0.0, b = 0.8, a = 1.0 },
        secondary = { r = 0.2, g = 0.2, b = 1.0, a = 1.0 },
    },
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "processing-unit",  amount = 10 },
        { type = "fluid", name = "enchanted-lava",   amount = 500 },
        { type = "item",  name = "base-magma-ball",  amount = 20 },
        { type = "item",  name = "advanced-circuit", amount = 5 },
        { type = "item",  name = "sulfur",           amount = 10 },
    },
    results = {
        { type = "item", name = "processing-unit", amount = 13 }
    },
    main_product = "processing-unit",
}

return { basic, advanced, ultimate }
