-- Rare Mineral Extraction recipes for Lava Centrifuge
-- Extract rare materials from purified lava

return {
    -- Uranium extraction from purified lava
    {
        type = "recipe",
        name = "uranium-from-lava",
        category = "lava-centrifuge",
        enabled = false,
        energy_required = 20,
        ingredients = {
            { type = "fluid", name = "purified-lava", amount = 5000 },
            { type = "fluid", name = "sulfuric-acid", amount = 100 },
        },
        results = {
            { type = "item", name = "uranium-ore", amount = 10 },
        },
        crafting_machine_tint = {
            primary = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 },
            secondary = { r = 0.2, g = 0.8, b = 0.2, a = 1.0 },
        },
        allow_productivity = true,
    },
    -- Hot Tungsten Ore extraction from purified lava (Space Age)
    {
        type = "recipe",
        name = "hot-tungsten-ore-from-lava",
        category = "lava-centrifuge",
        enabled = false,
        energy_required = 30,
        ingredients = {
            { type = "fluid", name = "purified-lava", amount = 10000 },
            { type = "fluid", name = "molten-iron",   amount = 500 },
            { type = "item",  name = "coal",          amount = 50 },
        },
        results = {
            { type = "item", name = "hot-tungsten-ore", amount = 40 },
        },
        crafting_machine_tint = {
            primary = { r = 0.5, g = 0.5, b = 0.6, a = 1.0 },
            secondary = { r = 0.4, g = 0.4, b = 0.5, a = 1.0 },
        },
        allow_productivity = true,
    },
    -- Hot Tungsten Ore to Liquid Tungsten (Space Age)
    {
        type = "recipe",
        name = "liquid-tungsten-from-hot-ore",
        category = "lava-centrifuge",
        enabled = false,
        energy_required = 20,
        ingredients = {
            { type = "item", name = "hot-tungsten-ore", amount = 10 },
        },
        results = {
            { type = "fluid", name = "liquid-tungsten", amount = 500 },
        },
        crafting_machine_tint = {
            primary = { r = 0.6, g = 0.6, b = 0.7, a = 1.0 },
            secondary = { r = 0.4, g = 0.4, b = 0.5, a = 1.0 },
        },
        allow_productivity = true,
    },
}
