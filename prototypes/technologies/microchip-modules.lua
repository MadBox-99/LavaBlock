-- First-tier modules built on microchips instead of advanced circuits.
--
-- Its own research rather than three more lines in EUV lithography, so it
-- can wait for all three module technologies: unlocked any earlier, a chip
-- recipe would hand out a module the player has not researched yet.
return {
    type = "technology",
    name = "microchip-modules",
    -- Layered rather than rendered, the way Chlorinated purification is: it
    -- hands over recipes and no machine.
    icons = {
        {
            icon = "__base__/graphics/technology/module.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/microchip.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "microchip-speed-module" },
        { type = "unlock-recipe", recipe = "microchip-efficiency-module" },
        { type = "unlock-recipe", recipe = "microchip-productivity-module" },
    },
    prerequisites = {
        "euv-lithography", "speed-module", "efficiency-module",
        "productivity-module",
    },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
            { "production-science-pack", 1 },
        },
        time = 30
    },
    order = "i-d"
}
