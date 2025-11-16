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
    local craft_count
    if x <= 20 then
        -- Levels 2-20: moderate growth (roughly 10k to 100k range)
        craft_count = math.floor(x * 1000 + (x * x * x) * 50)
    else
        -- Levels 21-30: exponential growth from ~500k to 2M
        local progress = (x - 20) / 10  -- 0.1 to 1.0
        craft_count = math.floor(500000 + (1500000 * progress * progress))
    end

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
            count = craft_count
        },
        prerequisites = { "advanced-lava-smelting-productivity-" .. (x - 1) },
        upgrade = true,
    }
end

data:extend(advanced_lava_smelting_productivity)
