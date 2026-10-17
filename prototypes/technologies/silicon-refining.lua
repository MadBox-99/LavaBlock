-- Silicon reduced out of silica and grown into boules on the crystal
-- hearth: three wafers to a crystal where the laser cutter gets two.
--
-- After Laser cutting, because that is where wafers start and where they
-- are first used, and after Shielded crystallization, because the puller
-- grows under argon and that technology is where argon comes from. Rare
-- earth processing hands over the phosphorus the wafers are doped with.
-- The lava pack comes with it.
return {
    type = "technology",
    name = "silicon-refining",
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/technology/laser-cutting.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-silicon.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "silica-reduction" },
        { type = "unlock-recipe", recipe = "silicon-wafer-pulling" },
    },
    prerequisites = { "laser-cutting", "shielded-crystallization", "rare-earth-processing" },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
        },
        time = 30,
    },
    order = "a-a-d",
}
