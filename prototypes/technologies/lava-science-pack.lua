local lava_science_pack_technology = {
    type = "technology",
    name = "lava-science-pack",
    icon = "__LavaBlock__/graphics/icons/lava-science-pack.png",
    icon_size = 64,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "lava-science-pack"
        }
    },
    prerequisites = { "steel-processing", "fluid-handling" },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack", 1 }
        },
        time = 30
    },
    order = "c-a"
}
return lava_science_pack_technology
