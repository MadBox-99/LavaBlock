-- Borax crystallised out of brine, and boron reduced out of it with
-- magnesium.
--
-- Blue science, after Light metals, which hands over the magnesium - and
-- the Chlor-alkali process's brine and the arc furnace with it. Nuclear
-- power waits on it, because every reactor's control rods are boron.
return {
    type = "technology",
    name = "boron-processing",
    icon = "__LavaBlock-graphics__/graphics/technology/boron-processing.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "borax-crystallizing" },
        { type = "unlock-recipe", recipe = "boron-reduction" },
    },
    prerequisites = { "light-metals" },
    unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-h",
}
