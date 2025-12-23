local sulfur_lava = {
    type = "recipe",
    name = "sulfur-lava",
    energy_required = 1,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "petroleum-gas", amount = 30 },
        { type = "fluid", name = "lava",          amount = 1000 }
    },
    results = {
        { type = "item", name = "sulfur", amount = 2 }
    },
    icon = "__base__/graphics/icons/sulfur.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    surface_conditions = { { property = "pressure", min = 1000, max = 1000 }, { property = "gravity", min = 10, max = 10 } },
}
return sulfur_lava
