local lava_smelting_productivity_technologies = {
    {
        type = "technology",
        name = "lava-smelting-productivity-1",
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "brick-smelting",
                change = 0.1
            }
        },
        prerequisites = { "advanced-lava-smelting" },
        unit =
        {
            count = 250,
            ingredients =
            {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 }
            },
            time = 60
        },
        upgrade = true
    },
    {
        type = "technology",
        name = "lava-smelting-productivity-2",
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "brick-smelting",
                change = 0.1
            }
        },
        prerequisites = { "lava-smelting-productivity-1" },
        unit = {
            count = 1000,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 }
            },
            time = 60
        },
        upgrade = true,
    },
    {
        type = "technology",
        name = "lava-smelting-productivity-3",
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "brick-smelting",
                change = 0.1
            }
        },
        prerequisites = { "lava-smelting-productivity-2" },
        unit = {
            count = 1500,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 }
            },
            time = 60
        },
        upgrade = true,
    },
    {
        type = "technology",
        name = "lava-smelting-productivity-4",
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-smelting",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "brick-smelting",
                change = 0.1
            }
        },
        prerequisites = { "lava-smelting-productivity-3" },
        unit = {
            count_formula = "2000*(L - 3)",
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 },
                { "space-science-pack",      1 }
            },
            time = 60
        },
        max_level = "infinite",
        upgrade = true,
    },
}

data:extend(
    lava_smelting_productivity_technologies
)
