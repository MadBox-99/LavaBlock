-- Steel melted down in the arc furnace: iron plate and a little coal for
-- the carbon, refined under the arcs. Most of the world's steel is made
-- this way now, from scrap in electric furnaces.
--
-- The same five iron a steel as the furnace, plus half a coal. What it buys
-- is speed: one arc furnace makes half a steel a second, the work of four
-- steel furnaces. What it costs is power - 3 MW over two seconds is 6 MJ a
-- steel, against 1.44 MJ in an electric furnace - and the coal. A small
-- steel line stays in furnaces; a big one has to decide.
return {
    type = "recipe",
    name = "steel-arc-smelting",
    category = "arc-smelting",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "iron-plate", amount = 10 },
        { type = "item", name = "coal",       amount = 1 },
    },
    results = {
        { type = "item", name = "steel-plate", amount = 2 },
    },
    allow_productivity = true,
    -- The furnace recipe is the one steel recycles back through.
    auto_recycle = false,
    icons = {
        { icon = "__base__/graphics/icons/steel-plate.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/items/arc-furnace.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "d[steel-plate]-b[arc]",
}
