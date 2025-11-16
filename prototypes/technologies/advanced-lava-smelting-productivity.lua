local advanced_lava_smelting_productivity = {}
advanced_lava_smelting_productivity[1] = {
    type = "technology",
    name = "advanced-lava-smelting-productivity-1",
    icon = "__base__/graphics/technology/mining-productivity.png",
    icon_size = 256,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "iron-smelting-cooling",
            change = 0.1
        },
        {
            type = "change-recipe-productivity",
            recipe = "copper-smelting-cooling",
            change = 0.1
        },
    },
    research_trigger = {
        type = "craft-item",
        item = "iron-plate",
        count = 10000
    },
    prerequisites = { "advanced-lava-cooling" },
    upgrade = true,
}
for x = 2, 30 do
    advanced_lava_smelting_productivity[x] = {
        type = "technology",
        name = "advanced-lava-smelting-productivity-" .. x,
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-smelting-cooling",
                change = 0.1
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-smelting-cooling",
                change = 0.1
            },
        },
        research_trigger = {
            type = "craft-item",
            item = "iron-plate",
            count = (x * 1000) + ((x * x) / (x + 2)) * (x / (x + 1)) * 500 + x * 100
        },
        prerequisites = { "advanced-lava-smelting-productivity-" .. (x - 1) },
        upgrade = true,
    }
end

data:extend(advanced_lava_smelting_productivity)
