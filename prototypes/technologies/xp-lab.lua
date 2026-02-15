return {
    type = "technology",
    name = "xp-lab",
    localised_description =
    "Automation is the law, but manual practice never hurts. Sometimes the old ways teach us new tricks.",
    icons = {
        {
            icon = "__base__/graphics/icons/lab.png",
            icon_size = 64,
            tint = { r = 0.7, g = 0.3, b = 1.0, a = 1 }
        }
    },
    effects = {
        { type = "unlock-recipe", recipe = "xp-lab" },
    },
    research_trigger = {
        type = "craft-item",
        item = "iron-gear-wheel",
        count = 50
    },
    order = "a-h-a"
}