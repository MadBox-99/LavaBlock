-- Fischer-Tropsch synthesis: carbon monoxide and hydrogen, two of hydrogen
-- to one, built back up over a catalyst into liquid hydrocarbons. Germany
-- ran its war on it and South Africa still fuels its cars with it. The
-- Fuel Plant is the island's reactor for turning gas into fuel already.
--
-- 50 carbon monoxide and 100 hydrogen for 15 light oil, three seconds. The
-- number is set against the ethanol line it stands beside. Ten straw make
-- 50 methane, which reforms to exactly this, so ten straw are 15 light oil.
-- A rocket fuel is 110 light oil the vanilla way - ten solid fuel at ten
-- each, and ten more - so about 73 straw, where ethanol rocket fuel takes
-- 200 ethanol, 80 straw. Close enough that neither is the answer: one
-- needs oxygen, the other a reformer and a third of its hydrogen to find a
-- use for.
return {
    type = "recipe",
    name = "light-oil-synthesis",
    category = "fuel-synthesizing",
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "carbon-monoxide", amount = 50 },
        { type = "fluid", name = "hydrogen",        amount = 100 },
    },
    results = {
        { type = "fluid", name = "light-oil", amount = 15 },
    },
    -- Allowed, as on ethanol synthesis in the same machine: nothing turns
    -- light oil back into either gas.
    allow_productivity = true,
    allow_quality = false,
    always_show_products = true,
    icons = {
        {
            icon = "__base__/graphics/icons/fluid/light-oil.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/carbon-monoxide.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "b[ethanol]-i[light-oil-synthesis]",
    crafting_machine_tint = {
        primary = { r = 0.29, g = 0.33, b = 0.41, a = 1.0 },
        secondary = { r = 0.57, g = 0.33, b = 0.00, a = 1.0 },
    },
}
