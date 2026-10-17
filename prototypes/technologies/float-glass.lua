-- Tin run off liquid, cast into plate, and laid down as the bath that
-- float glass cools on.
--
-- After Glass melting, for the molten glass, and after EUV lithography,
-- because that is where cassiterite first grows. So it costs what EUV
-- costs to research, production science and the lava pack: a late upgrade
-- for a base that is already making tin for chips.
return {
    type = "technology",
    name = "float-glass",
    icons = {
        {
            icon = "__base__/graphics/technology/advanced-material-processing-2.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-tin.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "cassiterite-melting" },
        { type = "unlock-recipe", recipe = "tin-casting" },
        { type = "unlock-recipe", recipe = "float-glass" },
    },
    prerequisites = { "glass-melting", "euv-lithography" },
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
    order = "a-a-c",
}
