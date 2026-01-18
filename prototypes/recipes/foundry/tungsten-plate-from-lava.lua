-- Tungsten Plate from Liquid Tungsten + Molten Iron (Foundry only)
return {
    type = "recipe",
    name = "tungsten-plate-from-lava",
    category = "lava-centrifuge",
    enabled = false,
    energy_required = 15,
    ingredients = {
        { type = "fluid", name = "liquid-tungsten", amount = 250 },
        { type = "fluid", name = "molten-iron",     amount = 100 },
    },
    results = {
        { type = "item", name = "tungsten-plate", amount = 5 },
    },
    crafting_machine_tint = {
        primary = { r = 0.5, g = 0.5, b = 0.6, a = 1.0 },
        secondary = { r = 0.4, g = 0.4, b = 0.5, a = 1.0 },
    },
    allow_productivity = true,
    order = "e-p-b-e",
}