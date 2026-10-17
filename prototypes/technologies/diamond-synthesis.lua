-- Diamond grown from gas on the crystal hearth, one at a time and on
-- demand, instead of rolled for one craft in twenty.
--
-- After Biogas, for the methane and the hydrogen, and Crystal growing,
-- which is where the hearth and diamonds first come from. Chemical science,
-- like both of them.
return {
    type = "technology",
    name = "diamond-synthesis",
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/technology/crystal-growing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/methane.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "diamond-depositing" },
    },
    prerequisites = { "biogas", "crystal-growing" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-b-k",
}
