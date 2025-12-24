-- Basic enchanting: 40 -> 41 (2.5% bonus)
local basic = {
    type = "recipe",
    name = "electronic-circuit-enchanting-basic",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.0, g = 0.8, b = 0.0, a = 1.0 },
        secondary = { r = 0.2, g = 1.0, b = 0.2, a = 1.0 },
    },
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "electronic-circuit", amount = 40 },
        { type = "fluid", name = "fusioning-lava",     amount = 100 },
    },
    results = {
        { type = "item", name = "electronic-circuit", amount = 41 }
    },
    main_product = "electronic-circuit",
}

-- Advanced enchanting: 20 -> 22 (10% bonus)
local advanced = {
    type = "recipe",
    name = "electronic-circuit-enchanting-advanced",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.0, g = 0.8, b = 0.0, a = 1.0 },
        secondary = { r = 0.2, g = 1.0, b = 0.2, a = 1.0 },
    },
    energy_required = 15,
    ingredients = {
        { type = "item",  name = "electronic-circuit",  amount = 20 },
        { type = "fluid", name = "stronger-fusioning-lava", amount = 100 },
    },
    results = {
        { type = "item", name = "electronic-circuit", amount = 22 }
    },
    main_product = "electronic-circuit",
}

-- Ultimate enchanting: 10 -> 13 (30% bonus, requires extra materials)
local ultimate = {
    type = "recipe",
    name = "electronic-circuit-enchanting-ultimate",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.0, g = 0.8, b = 0.0, a = 1.0 },
        secondary = { r = 0.2, g = 1.0, b = 0.2, a = 1.0 },
    },
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "electronic-circuit", amount = 10 },
        { type = "fluid", name = "enchanted-lava",     amount = 100 },
        { type = "item",  name = "base-magma-ball",    amount = 5 },
    },
    results = {
        { type = "item", name = "electronic-circuit", amount = 13 }
    },
    main_product = "electronic-circuit",
}

return { basic, advanced, ultimate }
