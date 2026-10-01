-- Carbon dioxide bubbled through the calcium solution: calcium carbonate
-- comes out of it as a fine sediment and is pressed into limestone. Half the
-- water comes back, clean enough to leach the next load of slag.
--
-- This is how limestone is made from steel slag in earnest, not a story put
-- on a recipe: the island has no limestone to quarry, and slag has calcium to
-- spare.
return {
    type = "recipe",
    name = "limestone-carbonation",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "fluid", name = "calcium-solution", amount = 100 },
        { type = "fluid", name = "carbon-dioxide",   amount = 50 },
    },
    results = {
        { type = "item",  name = "limestone", amount = 4 },
        { type = "fluid", name = "water",     amount = 50 },
    },
    main_product = "limestone",
    allow_productivity = true,
    subgroup = "lava-block-lime",
    order = "a[limestone]",
}
