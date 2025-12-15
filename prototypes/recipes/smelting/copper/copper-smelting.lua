local copper_smelting = {
    type = "recipe",
    name = "copper-smelting",
    energy_required = 3,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "lava",       amount = 5000 },
        { type = "item",  name = "copper-ore", amount = 5 }
    },
    surface_conditions = { { property = "pressure", min = 1000, max = 1000 }, { property = "gravity", min = 10, max = 10 } },
    results = {
        { type = "fluid", name = "molten-copper", amount = 50 }
    },
    main_product = "molten-copper",
    icon = "__LavaBlock__/graphics/icons/copper-lava-smelt.png",
    icon_size = 64,
    category = "oil-processing",
    subgroup = "fluid-recipes",
    allow_productivity = true,
    allow_quality = false,
}
return copper_smelting