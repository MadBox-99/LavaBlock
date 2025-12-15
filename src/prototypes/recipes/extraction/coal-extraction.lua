local coal_extraction = {
    type = "recipe",
    name = "coal-extraction",
    energy_required = 4,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 1000 }
    },
    results = {
        { type = "item", name = "coal", amount = 5 }
    },
    icon = "__base__/graphics/icons/coal.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes"
}
return coal_extraction
