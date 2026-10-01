-- Processing units built on sapphire: one crystal circuit board and two
-- substrate plates stand in for the advanced circuits and most of the
-- electronic ones.
--
-- Two units a craft for ten electronic circuits and no advanced ones,
-- against vanilla's one for twenty electronic and two advanced. The crystal
-- side of the bill - a sapphire, half a ruby and a pyrite a unit - is about
-- five crystal-growing crafts, which is less machine time than the circuits
-- it saves and no plastic at all. It makes the crystal line a way to blue
-- circuits without an oil line behind them.
return {
    type = "recipe",
    name = "sapphire-processing-unit",
    categories = { "crafting-with-fluid", "electromagnetics" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "crystal-circuit-board", amount = 1 },
        { type = "item",  name = "sapphire-substrate",    amount = 2 },
        { type = "item",  name = "electronic-circuit",    amount = 10 },
        { type = "fluid", name = "sulfuric-acid",         amount = 5 },
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
            icon = "__LavaBlock-graphics__/graphics/icons/parts/sapphire-substrate.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "g[processing-unit]-b[sapphire]",
}
