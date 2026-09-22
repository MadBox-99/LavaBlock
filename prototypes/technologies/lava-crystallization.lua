-- Glass, and the hearth that starts it.
--
-- This sits in front of the arboretum rather than beside it, which is a
-- change to an existing path: the glasshouses are walled in glazed panels
-- now, so the machine that makes glass has to come first. It is deliberately
-- cheap for that reason - 75 on red and green, no new science pack - because
-- a prerequisite added in front of an existing research should lengthen the
-- road, not put a toll on it.
return {
    type = "technology",
    name = "lava-crystallization",
    icon = "__LavaBlock__/graphics/technology/lava-crystallization.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "crystallizer" },
        { type = "unlock-recipe", recipe = "silica-crystallizing" },
        { type = "unlock-recipe", recipe = "glass" },
        { type = "unlock-recipe", recipe = "glazed-panel" },
    },
    prerequisites = { "logistic-science-pack" },
    unit = {
        count = 75,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    },
    order = "a-a-a"
}
