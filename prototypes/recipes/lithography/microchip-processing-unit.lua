-- Processing units built on microchips: four chips stand in for the
-- advanced circuits and most of the electronic ones.
--
-- Two units a craft for four electronic circuits, against the sapphire
-- recipe's ten and vanilla's forty and four advanced. It is the cheapest of
-- the three on purpose: the chips behind it need the whole crystal line, a
-- tin line and a machine that eats laser sources.
return {
    type = "recipe",
    name = "microchip-processing-unit",
    category = "electronics-with-fluid",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "microchip",          amount = 4 },
        { type = "item",  name = "electronic-circuit", amount = 4 },
        { type = "fluid", name = "sulfuric-acid",      amount = 5 },
    },
    results = {
        { type = "item", name = "processing-unit", amount = 2 },
    },
    allow_productivity = true,
    -- Processing units keep recycling into the vanilla recipe's circuits.
    auto_recycle = false,
    icons = {
        { icon = "__base__/graphics/icons/processing-unit.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/microchip.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "g[processing-unit]-c[microchip]",
}
