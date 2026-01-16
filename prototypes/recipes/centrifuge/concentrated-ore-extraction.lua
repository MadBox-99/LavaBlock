-- Concentrated Ore Extraction from purified lava
-- More efficient than basic lava extraction recipes
return {
    type = "recipe",
    name = "concentrated-ore-extraction",
    category = "lava-centrifuge",
    icon = "__base__/graphics/icons/iron-ore.png",
    icon_size = 64,
    enabled = false,
    energy_required = 15,
    ingredients = {
        { type = "fluid", name = "purified-lava", amount = 2500 },
    },
    results = {
        { type = "item", name = "iron-ore",   amount = 50 },
        { type = "item", name = "copper-ore", amount = 50 },
    },
    main_product = "",
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.4, b = 0.2, a = 1.0 },
        secondary = { r = 0.6, g = 0.3, b = 0.1, a = 1.0 },
    },
    allow_productivity = true,
}
