-- Early, and behind fluid handling rather than behind any of the mod's own
-- chains. The problem it solves - a pipe with nowhere to go - appears the
-- first time a player runs two fluid recipes at different rates, which on
-- this island is long before chemical science.
return {
    type = "technology",
    name = "fluid-quenching",
    -- Rendered from the same model at --tech-elev 42. The default 30 degrees
    -- is for a machine with a face on its side; from there this one's own
    -- kerb hides the melt and the product shot is a grey ring with nothing
    -- in it.
    icon = "__LavaBlock-graphics__/graphics/technology/quench-pit.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "quench-pit" },
    },
    prerequisites = { "fluid-handling" },
    unit = {
        count = 75,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-e"
}
