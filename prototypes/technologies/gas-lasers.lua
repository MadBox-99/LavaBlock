-- Neon out of the air, helium out of the radon uranium ore gives off, and
-- a laser source that lases in a tube of the two instead of a ruby rod.
--
-- After EUV lithography, which is where the laser source comes from and
-- what it is for, Advanced lava cooling, which hands over the air
-- compressor the neon is separated on, and Uranium processing for the ore
-- the radon seeps out of. It costs what EUV costs.
return {
    type = "technology",
    name = "gas-lasers",
    icons = {
        {
            icon = "__base__/graphics/technology/laser.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/neon.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "neon-extraction" },
        { type = "unlock-recipe", recipe = "radon-emanation" },
        { type = "unlock-recipe", recipe = "radon-decaying" },
        { type = "unlock-recipe", recipe = "helium-neon" },
        { type = "unlock-recipe", recipe = "laser-source-neon" },
    },
    prerequisites = { "euv-lithography", "advanced-lava-cooling", "uranium-processing" },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
            { "production-science-pack", 1 },
        },
        time = 30,
    },
    order = "a-a-e",
}
