-- Potash crystallised out of brine, NPK fertiliser, and trees and algae
-- grown with it.
--
-- The lava pack's era, after Ammonia synthesis for the nitrogen, Rare
-- earth processing for the phosphorus - the monazite gives it up - and
-- Algae cultivation, which comes after the Arboretum, for the two
-- harvests it feeds.
return {
    type = "technology",
    name = "fertilizer",
    icon = "__LavaBlock-graphics__/graphics/technology/fertilizer.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "potash-crystallizing" },
        { type = "unlock-recipe", recipe = "fertilizer" },
        { type = "unlock-recipe", recipe = "tree-cultivation-fertilized" },
        { type = "unlock-recipe", recipe = "algae-green-fertilized" },
    },
    prerequisites = { "ammonia-synthesis", "rare-earth-processing", "algae-cultivation" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
        },
        time = 30,
    },
    order = "a-a-n",
}
