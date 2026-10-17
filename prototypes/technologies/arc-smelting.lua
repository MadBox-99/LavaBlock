-- The arc furnace, and steel melted in it.
--
-- Red and green: it is the island's mid-game smelter, and the metals and
-- alloys that follow it are what the blue-science era is built from.
-- Advanced material processing for the refractory work of the steel
-- furnace before it, Concrete for the pad it stands on, and Electric energy
-- distribution 1 because a 3 MW load wants big poles before it wants
-- anything else.
return {
    type = "technology",
    name = "arc-smelting",
    icon = "__LavaBlock-graphics__/graphics/technology/arc-smelting.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "arc-furnace" },
        { type = "unlock-recipe", recipe = "steel-arc-smelting" },
    },
    prerequisites = {
        "advanced-material-processing",
        "concrete",
        "electric-energy-distribution-1",
    },
    unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-c",
}
