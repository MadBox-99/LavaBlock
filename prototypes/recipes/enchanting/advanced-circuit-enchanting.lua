-- Basic enchanting: 40 -> 41 (2.5% bonus)
local basic = {
    type = "recipe",
    name = "advanced-circuit-enchanting-basic",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.0, b = 0.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.2, b = 0.2, a = 1.0 },
    },
    energy_required = 25,
    ingredients = {
        { type = "item",  name = "advanced-circuit", amount = 40 },
        { type = "fluid", name = "fusioning-lava",   amount = 200 },
    },
    results = {
        { type = "item", name = "advanced-circuit", amount = 41 }
    },
    main_product = "advanced-circuit",
}

-- Advanced enchanting: 20 -> 22 (10% bonus)
local advanced = {
    type = "recipe",
    name = "advanced-circuit-enchanting-advanced",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.0, b = 0.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.2, b = 0.2, a = 1.0 },
    },
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "advanced-circuit",        amount = 20 },
        { type = "fluid", name = "stronger-fusioning-lava", amount = 200 },
    },
    results = {
        { type = "item", name = "advanced-circuit", amount = 22 }
    },
    main_product = "advanced-circuit",
}

-- Ultimate enchanting: 10 -> 13 (30% bonus, requires extra materials)
local ultimate = {
    type = "recipe",
    name = "advanced-circuit-enchanting-ultimate",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.0, b = 0.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.2, b = 0.2, a = 1.0 },
    },
    energy_required = 15,
    ingredients = {
        { type = "item",  name = "advanced-circuit",   amount = 10 },
        { type = "fluid", name = "enchanted-lava",     amount = 200 },
        { type = "item",  name = "base-magma-ball",    amount = 10 },
        { type = "item",  name = "electronic-circuit", amount = 5 },
    },
    results = {
        { type = "item", name = "advanced-circuit", amount = 13 }
    },
    main_product = "advanced-circuit",
}

return { basic, advanced, ultimate }
