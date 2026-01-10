-- Technology that disables the foundation-platform-nauvis recipe when researched
-- This serves as an end-game challenge for players

data:extend({
    {
        type = "technology",
        name = "foundation-platform-disable",
        icon = "__space-age__/graphics/icons/foundation.png",
        icon_size = 64,
        effects = {
            {
                type = "nothing",
                effect_description = {
                    "technology-effect.disable-recipe",
                    "foundation-platform-nauvis",
                    {"recipe-name.foundation-platform-nauvis"}
                }
            }
        },
        research_trigger = {
            type = "craft-item",
            item = "foundation",
            count = 5000
        },
        prerequisites = { "foundation-platform-productivity-30" },
    }
})