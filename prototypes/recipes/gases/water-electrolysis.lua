-- Water electrolysis: where the island's oxygen comes from.
--
-- Oxygen used to be a side effect of the bio garden, which made the one
-- building that grows things also the gas plant. Splitting water with a
-- current is the ordinary industrial answer and it belongs in a chemical
-- plant, so the garden can go back to growing and the smelters can be fed
-- oxygen without a greenhouse in the way.
--
-- 100 water for 100 oxygen, the same ratio the garden ran at, so nothing
-- downstream has to be re-tuned. The cost moved from a 150 kW greenhouse to
-- the chemical plant's own draw, which is the point: electrolysis is paid
-- for in electricity.
return {
    type = "recipe",
    name = "water-electrolysis",
    category = "chemistry",
    subgroup = "fluid-recipes",
    order = "a[fluid-chemistry]-f[water-electrolysis]",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "water", amount = 100 },
    },
    results = {
        { type = "fluid", name = "oxygen", amount = 100 },
    },
    -- One fluid into another: productivity would be free matter, and quality
    -- does nothing on a fluid-only recipe.
    allow_productivity = false,
    allow_quality = false,
    always_show_products = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/oxygen.png",
            icon_size = 64,
        },
        {
            icon = "__base__/graphics/icons/fluid/water.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.30, g = 0.64, b = 1.00, a = 1.0 },
        secondary = { r = 0.72, g = 0.88, b = 1.00, a = 1.0 },
    },
}
