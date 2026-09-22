-- The purified-lava pass on the hearth.
--
-- It waits for the centrifuge because it is made of the centrifuge's output,
-- and there is nothing to research until that building exists. Nothing new
-- to build here: one recipe, on a machine the player has been running since
-- before the first glasshouse.
return {
    type = "technology",
    name = "refined-crystallization",
    icon = "__LavaBlock__/graphics/technology/refined-crystallization.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "silica-crystallizing-purified" },
    },
    prerequisites = { "lava-crystallization", "lava-centrifuge" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
        },
        time = 30
    },
    order = "a-a-b"
}
