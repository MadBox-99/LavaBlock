-- Blue algae on its own line, because it is the one strain that needs a feed
-- the garden's own technology does not provide.
--
-- Green and red live off water, lava and steam, all of which you have long
-- before the garden. Blue lives off air, and air needs the whole compressor
-- chain behind Advanced Lava Cooling. Unlocking it with the garden would put
-- a recipe in the list that nothing could feed for several technologies; so
-- it waits here, where both halves are actually in hand.
return {
    type = "technology",
    name = "nitrogen-fixation",
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/liquid-nitrogen.png",
            icon_size = 64,
            -- Halved with the source size, so the droplet still covers
            -- the same 128 units of the 256 technology frame.
            scale = 2.0,
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "algae-blue" },
        { type = "unlock-recipe", recipe = "nitrogen-fixation" },
    },
    prerequisites = { "bio-garden", "advanced-lava-cooling" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-h"
}
