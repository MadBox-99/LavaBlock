-- Sphalerite leached by bacteria: zinc sulfide eaten down to zinc in
-- solution, the most soluble of the sulfide metals and the easiest for a
-- culture to take.
--
-- Five zinc from four sphalerite, where the arc furnace gets four. The
-- extra plate is the zinc that smelting loses to the fume.
return {
    type = "recipe",
    name = "sphalerite-bioleaching",
    categories = { "ore-bioleaching" },
    enabled = false,
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "sphalerite",        amount = 4 },
        { type = "item",  name = "leaching-bacteria", amount = 1 },
        { type = "fluid", name = "water",             amount = 100 },
    },
    results = {
        { type = "item", name = "zinc-plate", amount = 5 },
    },
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/parts/zinc-plate.png", icon_size = 64 },
        { icon = "__LavaBlock-graphics__/graphics/icons/items/leaching-bacteria.png", icon_size = 64, scale = 0.25, shift = { -8, -8 } },
    },
    subgroup = "agriculture-processes",
    order = "b[agriculture]-d[bacteria]-g[bioleaching]-b[sphalerite]",
    crafting_machine_tint = {
        -- Zinc sulfate is all but colourless; a pale straw, so it still
        -- reads as liquor.
        primary = { r = 0.78, g = 0.74, b = 0.52, a = 1 },
        secondary = { r = 0.60, g = 0.58, b = 0.44, a = 1 },
    },
}
