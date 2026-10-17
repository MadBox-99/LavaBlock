-- Magnetite smelted with aluminium in the arc furnace. Magnetite grown out
-- of basalt carries a little vanadium, as the titanomagnetite of real
-- basalts does - the world's main source of it - and aluminium, burning to
-- alumina, pulls it out: the thermite reaction.
--
-- Five magnetite and an aluminium plate for ten molten vanadium and three
-- iron plates, the iron the magnetite was mostly made of.
return {
    type = "recipe",
    name = "vanadium-smelting",
    category = "arc-smelting",
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "item", name = "magnetite",       amount = 5 },
        { type = "item", name = "aluminium-plate", amount = 1 },
    },
    results = {
        { type = "fluid", name = "molten-vanadium", amount = 10, fluidbox_index = 1 },
        { type = "item",  name = "iron-plate",      amount = 3 },
    },
    main_product = "molten-vanadium",
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-vanadium.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/magnetite.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "m[melt]-k[molten-vanadium]",
}
