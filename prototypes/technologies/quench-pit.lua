-- Early, and behind fluid handling rather than behind any of the mod's own
-- chains. The problem it solves - a pipe with nowhere to go - appears the
-- first time a player runs two fluid recipes at different rates, which on
-- this island is long before chemical science.
return {
    type = "technology",
    name = "fluid-quenching",
    -- Placeholder technology icon, like the machine's. See the entity file.
    icon = "__base__/graphics/technology/fluid-handling.png",
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
