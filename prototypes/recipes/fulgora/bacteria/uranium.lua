local uranium_bacteria_recipe = {
    type = "recipe",
    name = "uranium-bacteria",
    icon = "__LavaBlock-graphics__/graphics/icons/items/uranium-bacteria.png",
    categories = { "organic", "crafting" },
    surface_conditions =
    {
        {
            property = "pressure",
            min = 2000,
            max = 2000
        }
    },
    subgroup = "agriculture-processes",
    order = "e[bacteria]-a[bacteria]-b[uranium]",
    enabled = false,
    allow_productivity = true,
    energy_required = 1,
    ingredients =
    {
        { type = "item", name = "jelly", amount = 3 },
    },
    results =
    {
        { type = "item", name = "uranium-bacteria", amount = 1, independent_probability = 0.01 },
        { type = "item", name = "spoilage",         amount = 1 }
    },
    main_product = "uranium-bacteria",
    crafting_machine_tint =
    {
        primary = { r = 60, g = 171, b = 56 },
        secondary = { r = 195, g = 245, b = 193 },
    }
}

local uranium_bacteria_cultivation_recipe = {
    type = "recipe",
    name = "uranium-bacteria-cultivation",
    icon = "__LavaBlock-graphics__/graphics/icons/items/uranium-bacteria-cultivation.png",
    categories = { "organic" },
    surface_conditions =
    {
        {
            property = "pressure",
            min = 2000,
            max = 2000
        }
    },
    subgroup = "agriculture-processes",
    order = "e[bacteria]-b[cultivation]-b[uranium]",
    enabled = false,
    allow_productivity = true,
    energy_required = 4,
    ingredients =
    {
        { type = "item", name = "uranium-bacteria", amount = 1 },
        { type = "item", name = "bioflux",          amount = 1 }
    },
    results =
    {
        { type = "item", name = "uranium-bacteria", amount = 4, always_fresh = true }
    },
    crafting_machine_tint =
    {
        primary = { r = 60, g = 171, b = 56 },
        secondary = { r = 195, g = 245, b = 193 },
    },
}

data:extend { uranium_bacteria_recipe, uranium_bacteria_cultivation_recipe }