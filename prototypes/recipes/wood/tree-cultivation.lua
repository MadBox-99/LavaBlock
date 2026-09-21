-- Tree Cultivation: what the arboretum is for.
--
-- Wood had no real source on the lava island. The old wood-extraction recipe
-- produced a log every 15 seconds out of nothing at all, which was a
-- placeholder rather than a mechanic, and the arboretum technology switches it
-- off. From then on timber is grown: a seed and water in, eight logs out.
--
-- Outdoors a tree plant takes ten minutes to yield four logs on a single tile,
-- and the island has nowhere to put one. Indoors, under lamps and irrigation,
-- it is much faster and costs power and water instead of land.
--
-- The seed half of the loop is Space Age's own wood-processing (2 wood -> 1
-- seed), which the arboretum can also run, so one building closes the cycle.
-- Eight logs a seed against two logs a seed means an orchard grows rather than
-- merely sustains itself, which is the point of planting one.
return {
    type = "recipe",
    name = "tree-cultivation",
    category = "arboretum",
    subgroup = "raw-material",
    order = "a[wood]-b[tree-cultivation]",
    enabled = false,
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "tree-seed", amount = 1 },
        { type = "fluid", name = "water",     amount = 200 },
    },
    results = {
        { type = "item", name = "wood", amount = 8 },
    },
    allow_productivity = true,
    icons = {
        { icon = "__base__/graphics/icons/wood.png", icon_size = 64 },
        {
            icon = "__space-age__/graphics/icons/tree-seed.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.29, g = 0.62, b = 0.24, a = 1.0 },
        secondary = { r = 0.55, g = 0.80, b = 0.35, a = 1.0 },
    },
}
