-- Cobalt leached out of pentlandite, and the nickel superalloy made of
-- nickel, chromium, cobalt, aluminium and yttrium.
--
-- The lava pack's era. Alloy steels hands over the molten nickel and
-- chromium, Titanium processing the aluminium plate and Rare earth
-- processing the yttrium. The thruster waits on it, and with it every
-- space platform.
return {
    type = "technology",
    name = "superalloys",
    -- Layered: the steel research with the alloy over it, as the alloy
    -- icons are themselves vanilla's steel recoloured.
    icons = {
        {
            icon = "__base__/graphics/technology/steel-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/superalloy-plate.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "pentlandite-leaching" },
        { type = "unlock-recipe", recipe = "molten-superalloy" },
        { type = "unlock-recipe", recipe = "superalloy-casting" },
    },
    prerequisites = { "alloy-steels", "titanium-processing", "rare-earth-processing" },
    unit = {
        count = 400,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
        },
        time = 30,
    },
    order = "a-a-k",
}
