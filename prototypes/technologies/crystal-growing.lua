-- Slag, and the five crystals the hearth grows out of it at random.
--
-- It needs the hearth (Lava crystallization), the sulfur that the pyrite
-- is made of (Oil processing hands over sulfur from lava), and the crusher,
-- because the crushing recipes that clear the surplus come with it. Without
-- the crusher a hearth rolling five results would stall on the first one
-- nobody takes.
--
-- The slag recipe is also handed over by Limestone processing, whichever of
-- the two comes first.
return {
    type = "technology",
    name = "crystal-growing",
    icon = "__LavaBlock-graphics__/graphics/technology/crystal-growing.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "lava-slag-skimming" },
        { type = "unlock-recipe", recipe = "crystal-growing" },
        { type = "unlock-recipe", recipe = "pyrite-crushing" },
        { type = "unlock-recipe", recipe = "olivine-crushing" },
        { type = "unlock-recipe", recipe = "ruby-crushing" },
        { type = "unlock-recipe", recipe = "sapphire-crushing" },
        { type = "unlock-recipe", recipe = "diamond-crushing" },
    },
    prerequisites = { "lava-crystallization", "stone-crushing", "oil-processing" },
    unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    },
    order = "a-a-d"
}
