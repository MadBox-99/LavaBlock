local brick_smelting_productivity = {}
brick_smelting_productivity[1] = {
    type = "technology",
    name = "brick-smelting-productivity-1",
    icon = "__base__/graphics/icons/stone.png",
    icon_size = 64,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "brick-smelting",
            change = 0.1
        },
    },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
        },
        time = 30
    },
    prerequisites = { "automation-science-pack" },
    upgrade = true,
}
for i = 2, 5 do
    brick_smelting_productivity[i] = {
        type = "technology",
        name = "brick-smelting-productivity-" .. i,
        icon = "__base__/graphics/icons/stone.png",
        icon_size = 64,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "brick-smelting",
                change = 0.1
            },
        },
        research_trigger = {
            type = "craft-item",
            item = "stone",
            count = 5 * i * (1 + (2 * i))
        },
        prerequisites = { "brick-smelting-productivity-" .. (i - 1) },
        upgrade = true,
    }
end

data:extend(brick_smelting_productivity)
