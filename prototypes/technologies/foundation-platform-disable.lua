-- Technology that disables the foundation-platform-nauvis recipe when researched
-- This serves as an end-game challenge for players

-- Number of foundation crafts before the recipe is disabled (configurable startup setting)
local foundation_limit = settings.startup["lava-block-foundation-limit"].value

data:extend({
    {
        type = "technology",
        name = "foundation-platform-disable",
        localised_description =
        "[color=orange]⚠️ Warning: Mass production changes everything. The easy path may not remain forever. Plan accordingly.[/color]",
        icon = "__space-age__/graphics/icons/foundation.png",
        icon_size = 64,
        effects = {
            {
                type = "nothing",
                effect_description = {
                    "technology-effect.disable-recipe",
                    "foundation-catalyst",
                    { "recipe-name.foundation-catalyst" }
                }
            }
        },
        research_trigger = {
            type = "craft-item",
            item = "foundation",
            count = foundation_limit
        },
    }
})