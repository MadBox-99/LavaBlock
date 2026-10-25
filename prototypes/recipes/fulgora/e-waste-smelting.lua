-- E-waste smelted in the arc furnace, the way the big copper smelters take
-- in circuit boards: the resin burns off, the glass goes to slag, and the
-- copper comes out carrying the silver, gold and platinum with it. Cast
-- into anodes and refined, it leaves those behind as anode slime.
--
-- Five copper and two anode slime from ten e-waste. Copper electrorefining
-- gets one slime from ten plates, so e-waste is twenty times the richer
-- source, which is the whole reason anyone smelts circuit boards.
return {
    type = "recipe",
    name = "e-waste-smelting",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item", name = "e-waste", amount = 10 },
    },
    results = {
        { type = "item", name = "copper-plate", amount = 5 },
        { type = "item", name = "anode-slime",  amount = 2 },
    },
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/parts/e-waste.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/anode-slime.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 8, 8 },
        },
    },
    subgroup = "fulgora-processes",
    order = "a[trash]-c[e-waste-smelting]",
}
