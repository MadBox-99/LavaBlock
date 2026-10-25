-- Fischer-Tropsch synthesis: carbon monoxide and hydrogen, two of hydrogen
-- to one, built back up over a catalyst into liquid hydrocarbons. Germany
-- ran its war on it and South Africa still fuels its cars with it. The
-- Fuel Plant is the island's reactor for turning gas into fuel already.
--
-- 50 carbon monoxide and 100 hydrogen for 60 light oil, three seconds. The
-- number is set against the ethanol line it stands beside. Ten straw make
-- 50 methane, which reforms to exactly this, so ten straw are 60 light oil.
-- A rocket fuel is 110 light oil the vanilla way - ten solid fuel at ten
-- each, and ten more - so about 18 straw, where ethanol rocket fuel takes
-- 50 ethanol, 20 straw. Close enough that neither is the answer: one
-- needs oxygen, the other a reformer and a third of its hydrogen to find a
-- use for.
--
-- Not 15. The reformer, the gases and the Fuel Plant made light oil three
-- and a half times dearer than cracking heavy oil from crude; at 60 it is
-- a little cheaper than cracking before space, which is when the island
-- has no other light oil.
return {
    type = "recipe",
    name = "light-oil-synthesis",
    categories = { "fuel-synthesizing" },
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "carbon-monoxide", amount = 50 },
        { type = "fluid", name = "hydrogen",        amount = 100 },
    },
    results = {
        { type = "fluid", name = "light-oil", amount = 60 },
    },
    -- Allowed, as on ethanol synthesis in the same machine: nothing turns
    -- light oil back into either gas.
    allow_productivity = true,
    allow_quality = false,
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
    subgroup = "lava-block-organics",
    order = "b[ethanol]-i[light-oil-synthesis]",
    crafting_machine_tint = {
        primary = { r = 0.29, g = 0.33, b = 0.41, a = 1.0 },
        secondary = { r = 0.57, g = 0.33, b = 0.00, a = 1.0 },
    },
}
