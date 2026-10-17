-- Ilmenite grown and chlorinated, sodium won from brine, titanium reduced
-- with it, and Ti-6Al-4V made of the titanium, aluminium and vanadium.
--
-- Blue science. Light metals hands over the aluminium and the arc furnace
-- and, through the Chlor-alkali process, the brine and the chlorine;
-- Magnetite growing the magnetite the vanadium comes out of. The
-- exoskeleton and the Mk2 power armour wait on it.
return {
    type = "technology",
    name = "titanium-processing",
    -- Layered: the steel research with the alloy over it, as the alloy
    -- icons are themselves vanilla's steel recoloured.
    icons = {
        {
            icon = "__base__/graphics/technology/steel-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/titanium-alloy-plate.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "ilmenite-growing" },
        { type = "unlock-recipe", recipe = "ilmenite-chlorination" },
        { type = "unlock-recipe", recipe = "sodium-electrolysis" },
        { type = "unlock-recipe", recipe = "titanium-reduction" },
        { type = "unlock-recipe", recipe = "aluminium-casting" },
        { type = "unlock-recipe", recipe = "vanadium-smelting" },
        { type = "unlock-recipe", recipe = "vanadium-casting" },
        { type = "unlock-recipe", recipe = "molten-titanium-alloy" },
        { type = "unlock-recipe", recipe = "titanium-alloy-casting" },
    },
    prerequisites = { "light-metals", "magnetite-growing" },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-i",
}
