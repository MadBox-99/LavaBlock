-- Chromite reduced with coal in the arc furnace. Chromite is iron chromium
-- oxide, so iron comes out too: twenty molten chromium and an iron plate
-- for four ore. Real chromite is smelted to ferrochrome, iron and chromium
-- together; here the iron is drawn off as plate so that nichrome can have
-- its chromium without it.
--
-- Chromium melts at 1907 degrees, past anything but an arc.
return {
    type = "recipe",
    name = "chromite-smelting",
    category = "arc-smelting",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "chromite", amount = 4 },
        { type = "item", name = "coal",     amount = 1 },
    },
    results = {
        { type = "fluid", name = "molten-chromium", amount = 20, fluidbox_index = 1 },
        { type = "item",  name = "iron-plate",      amount = 1 },
    },
    main_product = "molten-chromium",
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-chromium.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/chromite.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "m[melt]-d[molten-chromium]",
}
