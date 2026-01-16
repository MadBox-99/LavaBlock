-- Lava Purification: Clean lava for better recipes
-- 1000 lava -> 500 purified lava (50% yield, but higher quality)
return {
    type = "recipe",
    name = "lava-purification",
    category = "lava-centrifuge",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "fluid", name = "lava", amount = 1000 },
    },
    results = {
        { type = "fluid", name = "purified-lava", amount = 500 }
    },
    crafting_machine_tint = {
        primary = { r = 1.0, g = 0.6, b = 0.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.8, b = 0.2, a = 1.0 },
    },
    allow_productivity = true,
}
