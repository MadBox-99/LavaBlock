-- Magnets, coils and ferrofluid: the coil winder, what it winds, and the
-- three things built out of magnetite and copper.
--
-- After Magnetite growing, because every magnet and every drop of
-- ferrofluid is magnetite, and after Lubricant, because ferrofluid is
-- carried in it and transformers are filled with it. Blue science and no
-- lava pack, so it does not ask more than the two it follows - and it has
-- to come early, because Electric engine now waits on it.
return {
    type = "technology",
    name = "ferromagnetism",
    icon = "__LavaBlock-graphics__/graphics/technology/ferromagnetism.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "coil-winder" },
        { type = "unlock-recipe", recipe = "magnetic-coil" },
        { type = "unlock-recipe", recipe = "ferrite-magnet" },
        { type = "unlock-recipe", recipe = "ferrofluid" },
        { type = "unlock-recipe", recipe = "transformer" },
    },
    prerequisites = { "magnetite-growing", "lubricant" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-a-f-b"
}
