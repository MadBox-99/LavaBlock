local calcite_synthesis_productivity =
{
    type = "technology",
    name = "calcite-synthesis-productivity-1",
    icon = "__space-age__/graphics/icons/calcite.png",
    icon_size = 64,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "calcite-synthesis",
            change = 0.1
        },
    },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
        },
        time = 15 --pinfuly slow
    },
    prerequisites = { "automation-science-pack" },
    upgrade = true,
}
local calcite_synthesis_productivity_1 =
{
    type = "technology",
    name = "calcite-synthesis-productivity-2",
    icon = "__space-age__/graphics/icons/calcite.png",
    icon_size = 64,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "calcite-synthesis",
            change = 0.1
        },
    },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    },
    prerequisites = {
        "calcite-synthesis-productivity-1",
        "logistic-science-pack",
    },
    upgrade = true,
}
local calcite_synthesis_productivity_2 =
{
    type = "technology",
    name = "calcite-synthesis-productivity-3",
    icon = "__space-age__/graphics/icons/calcite.png",
    icon_size = 64,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "calcite-synthesis",
            change = 0.1
        },
    },
    unit = {
        count = 1000,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    },
    prerequisites = {
        "calcite-synthesis-productivity-2",
    },

}


data:extend({
    calcite_synthesis_productivity,
    calcite_synthesis_productivity_1,
    calcite_synthesis_productivity_2,
})
