-- Calcium carbide fused in the arc furnace, acetylene from it, and PVC
-- from the acetylene.
--
-- Blue science. Arc smelting hands over the furnace, Limestone processing
-- the quicklime, and the Chlor-alkali process the hydrochloric acid the
-- PVC is made with.
return {
    type = "technology",
    name = "calcium-carbide",
    icons = {
        {
            icon = "__base__/graphics/technology/plastics.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/acetylene.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "calcium-carbide" },
        { type = "unlock-recipe", recipe = "acetylene-generation" },
        { type = "unlock-recipe", recipe = "plastic-bar-from-acetylene" },
    },
    prerequisites = { "arc-smelting", "limestone-processing", "chlor-alkali-process" },
    unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-s",
}
