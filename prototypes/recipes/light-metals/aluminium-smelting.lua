-- The Hall-Heroult process: alumina dissolved in a molten salt bath and
-- split by a heavy current, the aluminium settling to the bottom and the
-- oxygen burning the carbon anodes away as carbon dioxide. The industry
-- calls these plants smelters, and the arc furnace is the island's only
-- building that can pass the current.
--
-- Four alumina for twenty molten aluminium, two plates' worth - about the
-- real two to one - and a coal for the anodes. The carbon dioxide leaves
-- up the offtake, and the lime line takes it back into limestone.
return {
    type = "recipe",
    name = "aluminium-smelting",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "alumina", amount = 4 },
        { type = "item", name = "coal",    amount = 1 },
    },
    results = {
        { type = "fluid", name = "molten-aluminium", amount = 20, fluidbox_index = 1 },
        { type = "fluid", name = "carbon-dioxide",   amount = 20, fluidbox_index = 2 },
    },
    main_product = "molten-aluminium",
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-aluminium.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/alumina.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-metal-melts",
    order = "m[melt]-f[molten-aluminium]",
}
