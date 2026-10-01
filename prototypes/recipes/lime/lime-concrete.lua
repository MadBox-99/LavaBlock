-- Where the lime line ends: concrete, bound with lime instead of cement.
--
-- It makes the vanilla concrete, so it needs nothing new downstream -
-- everything that already takes concrete takes this. It gives 15 for the
-- vanilla recipe's 10 and needs no iron ore and no brick, which is what a
-- seven-step chain has to offer against a one-step recipe to be worth
-- building at all.
return {
    type = "recipe",
    name = "lime-concrete",
    categories = { "crafting-with-fluid" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "lime-mortar",   amount = 3 },
        { type = "item",  name = "basalt-gravel", amount = 3 },
        { type = "fluid", name = "water",         amount = 50 },
    },
    results = {
        { type = "item", name = "concrete", amount = 15 },
    },
    allow_productivity = true,
    -- Concrete keeps recycling into brick and iron ore. Without this the
    -- recycler would take this recipe as concrete's and hand back mortar.
    auto_recycle = false,
    icons = {
        { icon = "__base__/graphics/icons/concrete.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/lime-mortar.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-lime",
    order = "e[lime-concrete]",
}
