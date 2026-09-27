-- The column's one recipe: boil the wash, take the ethanol off the top and
-- the water off the bottom.
--
-- The steam is the reboiler's heat, not an ingredient that ends up in the
-- product - without heat in at the bottom nothing goes up a column. Twenty
-- steam is about 29 lava.
--
-- Three quarters of the wash comes back out as water. In a real distillery
-- that is the stillage and it is the biggest stream in the plant; here it is
-- clean enough to pipe straight back to the fermentation tanks, so a base
-- that closes the loop only tops up what leaves as ethanol.
--
-- One column eats a hundred wash every five seconds, which is the output of
-- four tanks on straw or wood.
return {
    type = "recipe",
    name = "wash-distillation",
    category = "wash-distilling",
    subgroup = "fluid-recipes",
    order = "b[ethanol]-d[wash-distillation]",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "fluid", name = "fermented-wash", amount = 100 },
        { type = "fluid", name = "steam",          amount = 20 },
    },
    results = {
        { type = "fluid", name = "ethanol", amount = 25 },
        { type = "fluid", name = "water",   amount = 75 },
    },
    main_product = "ethanol",
    -- Separation, not growth: productivity here would be ethanol out of
    -- nothing, and quality does nothing on a fluid-only recipe.
    allow_productivity = false,
    allow_quality = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/ethanol.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/fermented-wash.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
}
