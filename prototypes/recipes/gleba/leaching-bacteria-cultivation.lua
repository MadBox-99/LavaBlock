-- Leaching bacteria grown on bioflux, four for one, as Space Age grows its
-- own. Gleba only: the culture has to be kept at Gleba's pressure while it
-- grows, though once grown it lasts long enough to be shipped.
return {
    type = "recipe",
    name = "leaching-bacteria-cultivation",
    categories = { "organic" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "leaching-bacteria", amount = 1 },
        { type = "item", name = "bioflux",           amount = 1 },
    },
    results = {
        { type = "item", name = "leaching-bacteria", amount = 4, reset_freshness_on_craft = true },
    },
    allow_productivity = true,
    auto_recycle = false,
    surface_conditions = {
        { property = "pressure", min = 2000, max = 2000 },
    },
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/items/leaching-bacteria.png", icon_size = 64 },
        { icon = "__space-age__/graphics/icons/bioflux.png", icon_size = 64, scale = 0.25, shift = { 8, 8 } },
    },
    subgroup = "agriculture-processes",
    order = "b[agriculture]-d[bacteria]-f[leaching-bacteria-cultivation]",
    crafting_machine_tint = {
        primary = { r = 0.80, g = 0.74, b = 0.20, a = 1 },
        secondary = { r = 0.62, g = 0.66, b = 0.22, a = 1 },
    },
}
