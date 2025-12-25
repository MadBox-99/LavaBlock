-- Enchanted Locomotive (produces enchanted-locomotive item)
local locomotive = {
    type = "recipe",
    name = "enchanted-locomotive",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.0, b = 1.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.2, b = 1.0, a = 1.0 },
    },
    energy_required = 30,
    ingredients = {
        { type = "fluid", name = "enchanted-lava",     amount = 1000 },
        { type = "item",  name = "electronic-circuit", amount = 5 },
        { type = "item",  name = "engine-unit",        amount = 10 },
        { type = "item",  name = "iron-gear-wheel",    amount = 200 },
        { type = "item",  name = "steel-plate",        amount = 50 },
    },
    results = {
        { type = "item", name = "enchanted-locomotive", amount = 1 }
    },
}

-- Enchanted Cargo Wagon (produces enchanted-cargo-wagon item)
local cargo_wagon = {
    type = "recipe",
    name = "enchanted-cargo-wagon",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.0, b = 1.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.2, b = 1.0, a = 1.0 },
    },
    energy_required = 15,
    ingredients = {
        { type = "fluid", name = "enchanted-lava",  amount = 500 },
        { type = "item",  name = "iron-gear-wheel", amount = 200 },
        { type = "item",  name = "iron-chest",      amount = 5 },
        { type = "item",  name = "steel-plate",     amount = 30 },
    },
    results = {
        { type = "item", name = "enchanted-cargo-wagon", amount = 1 }
    },
}

-- Enchanted Fluid Wagon (produces enchanted-fluid-wagon item)
local fluid_wagon = {
    type = "recipe",
    name = "enchanted-fluid-wagon",
    category = "enchanting",
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.0, b = 1.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.2, b = 1.0, a = 1.0 },
    },
    energy_required = 15,
    ingredients = {
        { type = "fluid", name = "enchanted-lava",     amount = 500 },
        { type = "item",  name = "storage-tank",       amount = 1 },
        { type = "item",  name = "pipe",               amount = 100 },
        { type = "item",  name = "iron-gear-wheel",    amount = 200 },
        { type = "item",  name = "steel-plate",        amount = 30 },
    },
    results = {
        { type = "item", name = "enchanted-fluid-wagon", amount = 1 }
    },
}

return { locomotive, cargo_wagon, fluid_wagon }
