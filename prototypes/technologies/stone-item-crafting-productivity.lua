local ore_clearing_productivity = {}
ore_clearing_productivity[1] = {
    type = "technology",
    name = "ore-clearing-productivity-1",
    icon = "__base__/graphics/icons/stone.png",
    icon_size = 64,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "ore-clearing",
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
for i = 2, 30 do
    ore_clearing_productivity[i] = {
        type = "technology",
        name = "ore-clearing-productivity-" .. i,
        icon = "__base__/graphics/icons/stone.png",
        icon_size = 64,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "ore-clearing",
                change = 0.1
            },
        },
        research_trigger = {
            type = "craft-item",
            item = "stone",
            count = 5 * i * (1 + (2 * i))
        },
        prerequisites = { "ore-clearing-productivity-" .. (i - 1) },
        upgrade = true,
    }
end



--[[ data:extend({

}) ]]
data:extend(ore_clearing_productivity)
