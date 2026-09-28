-- The first step of the lime line: water run through slag carries its
-- calcium away, and what is left behind is gravel.
--
-- The gravel is the rest of the slag, and it is not waste - it goes straight
-- back into the mortar at the far end of the same line, or to the crusher
-- for stone.
return {
    type = "recipe",
    name = "lava-slag-leaching",
    category = "chemistry",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "lava-slag", amount = 5 },
        { type = "fluid", name = "water",     amount = 100 },
    },
    results = {
        { type = "fluid", name = "calcium-solution", amount = 100 },
        { type = "item",  name = "basalt-gravel",    amount = 1 },
    },
    main_product = "calcium-solution",
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/fluid/calcium-solution.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/lava-slag.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-lime",
    order = "0[a-leaching]",
}
