local iron_extraction = {
    type = "recipe",
    name = "iron-extraction",
    energy_required = 4,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 1000 },
    },
    results = {
        { type = "item", name = "iron-ore", amount = 5 }
    },
    icons = {
        {
            icon = "__base__/graphics/icons/iron-ore.png"
        },
        {
            icon = "__space-age__/graphics/icons/fluid/lava.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
}
return iron_extraction