-- Sphalerite leached by bacteria: zinc sulfide eaten down to zinc in
-- solution, the most soluble of the sulfide metals and the easiest for a
-- culture to take.
--
-- Six zinc from four sphalerite, where the arc furnace gets four. The
-- extra plates are the zinc that smelting loses to the fume and leaves in
-- the gangue; a culture gets nearly all of it.
--
-- Not five. With the reactor's time and the bacteria shipped from Gleba,
-- five came out level with smelting, and a route that needs another
-- planet has to be cheaper than one that does not.
--
-- Six seconds a run, not twenty. At twenty the reactor's own time cost more
-- than the furnace and acid it saves, and every bioleaching recipe made
-- dearer metal than the island's routes did.
return {
    type = "recipe",
    name = "sphalerite-bioleaching",
    categories = { "ore-bioleaching" },
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "item",  name = "sphalerite",        amount = 4 },
        { type = "item",  name = "leaching-bacteria", amount = 1 },
        { type = "fluid", name = "water",             amount = 100 },
    },
    results = {
        { type = "item", name = "zinc-plate", amount = 6 },
    },
    allow_productivity = true,
    -- Zinc recycles into zinc. Without this the recycler took this recipe
    -- as zinc's own and handed back sphalerite and bacteria.
    auto_recycle = false,
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
