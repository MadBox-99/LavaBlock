local lava_science_pack = {
    type = "recipe",
    name = "lava-science-pack",
    allow_productivity = true,
    enabled = false,
    crafting_machine_tint = {
        primary = { a = 1, b = 1, g = 0.186, r = 0.04 },
        quaternary = { a = 1, b = 0.5, g = 0.3, r = 0.1 },
        secondary = { a = 1, b = 1, g = 0.4, r = 0.2 },
        tertiary = { a = 1, b = 1, g = 0.651, r = 0.6 }
    },
    energy_required = 20,
    ingredients = {
        { type = "item", name = "iron-gear-wheel", amount = 2 },
        { type = "item", name = "lava-barrel", amount = 1 }
    },
    main_product = "lava-science-pack",
    results = {
        { type = "item", name = "lava-science-pack", amount = 1 }
    },
    surface_conditions = {
        { max = 300, min = 300, property = "pressure" }
    }
}
return lava_science_pack
