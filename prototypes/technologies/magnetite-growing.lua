-- The one crystal grown from metal. It follows Advanced lava smelting,
-- which is where molten iron first exists on the island, and Crystal
-- growing, which hands over the slag.
return {
    type = "technology",
    name = "magnetite-growing",
    icon = "__LavaBlock-graphics__/graphics/technology/magnetite-growing.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "magnetite-growing" },
    },
    prerequisites = { "crystal-growing", "advanced-lava-smelting" },
    unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-a-f"
}
