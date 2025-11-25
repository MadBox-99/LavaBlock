local copper_smelting_cooling = {
    type = "recipe",
    name = "copper-smelting-cooling",
    energy_required = 4,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "molten-copper", amount = 20 },
        { type = "fluid", name = "water",         amount = 20 }
    },
    surface_conditions = { { property = "pressure", min = 1000, max = 1000 }, { property = "gravity", min = 10, max = 10 } },
    results = {
        { type = "item", name = "copper-plate", amount = 4 }
    },
    icon = "__LavaBlock__/graphics/icons/iron-lava-smelt.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    allow_productivity = true,
    allow_quality = false,
}
return copper_smelting_cooling
