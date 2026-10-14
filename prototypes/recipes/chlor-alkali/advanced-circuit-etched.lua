-- An advanced circuit on an etched board. Vanilla wires its board by hand
-- from copper cable on two plastic bars; this one lays copper over the
-- whole of one bar and lets ferric chloride eat away everything that is
-- not a track, which is how every circuit board is really made.
--
-- The copper is the same - two plates, against four cables that are two
-- plates - and the second plastic bar becomes 10 ferric chloride. A bar is
-- 10 petroleum gas and half a coal, the oil line on this island; 10 ferric
-- chloride is half an iron plate and a little brine. So it is cheaper, and
-- the price is the chlor-alkali line behind it.
return {
    type = "recipe",
    name = "advanced-circuit-etched",
    category = "electronics-with-fluid",
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "item",  name = "electronic-circuit", amount = 2 },
        { type = "item",  name = "plastic-bar",        amount = 1 },
        { type = "item",  name = "copper-plate",       amount = 2 },
        { type = "fluid", name = "ferric-chloride",    amount = 10 },
    },
    results = {
        { type = "item", name = "advanced-circuit", amount = 1 },
    },
    allow_productivity = true,
    -- Advanced circuits keep recycling into their vanilla ingredients.
    auto_recycle = false,
    icons = {
        {
            icon = "__base__/graphics/icons/advanced-circuit.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/ferric-chloride.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "b[circuits]-b[advanced-circuit]-e[etched]",
}
