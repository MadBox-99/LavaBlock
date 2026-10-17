-- Galena and sphalerite grown on the crystal hearth, smelted to molten
-- lead and zinc in the arc furnace, and cast into plate.
--
-- Red and green, after Crystal growing, which hands over the hearth, the
-- slag and the sulfur these grow from, and Arc smelting, which hands over
-- the furnace. It has to come that early: Battery now waits on it, because
-- every battery is built on a lead plate. The zinc waits for brass.
return {
    type = "technology",
    name = "sulfide-ores",
    icon = "__LavaBlock-graphics__/graphics/technology/sulfide-ores.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "galena-growing" },
        { type = "unlock-recipe", recipe = "sphalerite-growing" },
        { type = "unlock-recipe", recipe = "galena-smelting" },
        { type = "unlock-recipe", recipe = "sphalerite-smelting" },
        { type = "unlock-recipe", recipe = "lead-casting" },
        { type = "unlock-recipe", recipe = "zinc-casting" },
    },
    prerequisites = { "crystal-growing", "arc-smelting" },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-d",
}
