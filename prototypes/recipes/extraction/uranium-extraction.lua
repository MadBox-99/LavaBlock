local uranium_extraction = {
    type = "recipe",
    name = "uranium-extraction",
    energy_required = 10,
    enabled = false,
    ingredients = {
        { type = "item",  name = "stone",         amount = 10 },
        { type = "fluid", name = "sulfuric-acid", amount = 20 }
    },
    results = {
        { type = "item", name = "uranium-ore", amount = 3 }
    },
    icons = {
        {
            icon = "__base__/graphics/icons/uranium-ore.png"
        },
        {
            icon = "__base__/graphics/icons/fluid/sulfuric-acid.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    allow_productivity = true
}
return uranium_extraction