-- Soda-lime glass: silica fluxed with quicklime, melted in the refinery and
-- poured, a quarter less silica a glass than the furnace takes.
--
-- Red and green, like the glass it stands beside. Lava crystallization is
-- where the silica and the glazed panel come from, Limestone processing is
-- where the quicklime does, and Oil processing hands over the refinery the
-- melt is made in.
return {
    type = "technology",
    name = "glass-melting",
    -- Layered: the furnace research with the melt over it.
    icons = {
        {
            icon = "__base__/graphics/technology/advanced-material-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-glass.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "glass-melting" },
        { type = "unlock-recipe", recipe = "glass-casting" },
        { type = "unlock-recipe", recipe = "glazed-panel-from-molten-glass" },
    },
    prerequisites = { "lava-crystallization", "limestone-processing", "oil-processing" },
    unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-b",
}
