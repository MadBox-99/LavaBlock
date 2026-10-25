-- The Downs cell: brine boiled down to salt, the salt melted, and a current
-- run through it - sodium collects at one electrode and chlorine at the
-- other. The arc furnace is the island's only building that passes the
-- current.
--
-- 100 brine for 20 molten sodium and 30 chlorine. Where the brine cell
-- gives caustic soda and hydrogen besides, this one gives the metal; the
-- chlorine is the same 30 either way.
return {
    type = "recipe",
    name = "sodium-electrolysis",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "fluid", name = "brine", amount = 100 },
    },
    results = {
        { type = "fluid", name = "molten-sodium", amount = 20, fluidbox_index = 1 },
        { type = "fluid", name = "chlorine",      amount = 30, fluidbox_index = 2 },
    },
    main_product = "molten-sodium",
    -- Fluid from fluid: productivity would make brine out of nothing.
    allow_productivity = false,
    subgroup = "lava-block-metal-melts",
    order = "m[melt]-i[molten-sodium]",
}
