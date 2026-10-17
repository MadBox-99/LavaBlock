-- Pentlandite smelted in the arc furnace with oxygen blown through it: the
-- iron and the sulfur burn off, the sulfur leaving as sulfur dioxide up
-- the fume offtake, and what runs out of the tap is nickel.
--
-- Six ore for thirty molten nickel, three plates' worth. The sulfur
-- dioxide is worth catching: the volcanic gas line turns it into sulfuric
-- acid.
return {
    type = "recipe",
    name = "pentlandite-smelting",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "item",  name = "pentlandite", amount = 6 },
        { type = "fluid", name = "oxygen",      amount = 40 },
    },
    results = {
        { type = "fluid", name = "molten-nickel",  amount = 30, fluidbox_index = 1 },
        { type = "fluid", name = "sulfur-dioxide", amount = 30, fluidbox_index = 2 },
    },
    main_product = "molten-nickel",
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-nickel.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/pentlandite.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "m[melt]-c[molten-nickel]",
}
