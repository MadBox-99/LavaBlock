local iron_smelting_cooling = {
    type = "recipe",
    name = "iron-smelting-cooling",
    energy_required = 4,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "molten-iron", amount = 20, fluidbox_multiplier = 10 },
        { type = "fluid", name = "water",       amount = 20 }
    },
    surface_conditions = { { property = "pressure", min = 1000, max = 1000 }, { property = "gravity", min = 10, max = 10 } },
    results = {
        { type = "item", name = "iron-plate", amount = 4 }
    },
    main_product = "iron-plate",
    icon = "__LavaBlock__/graphics/icons/iron-lava-smelt.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    allow_productivity = true,
    allow_quality = false,
}
return iron_smelting_cooling
