local foundation_platform_productivity = {}
foundation_platform_productivity[1] = {
    type = "technology",
    name = "foundation-platform-productivity-1",
    icon = "__space-age__/graphics/icons/foundation.png",
    icon_size = 64,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "foundation-platform-nauvis",
            change = 0.1
        },
    },
    research_trigger = {
        type = "craft-item",
        item = "stone",
        count = 5000
    },
    prerequisites = { "automation-science-pack" },
    upgrade = true,
}
for x = 2, 30 do
    foundation_platform_productivity[x] = {
        type = "technology",
        name = "foundation-platform-productivity-" .. x,
        icon = "__space-age__/graphics/icons/foundation.png",
        icon_size = 64,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "foundation-platform-nauvis",
                change = 0.1
            },
        },
        research_trigger = {
            type = "craft-item",
            item = "foundation",
            count = (x + ((x * x) / (x + 2)) * (x / (x + 1)) + (5 / (x + 1)) * ((x * x - x) / x)) + x + 10
        },
        prerequisites = { "foundation-platform-productivity-" .. (x - 1) },
        upgrade = true,
    }
end

data:extend(foundation_platform_productivity)
