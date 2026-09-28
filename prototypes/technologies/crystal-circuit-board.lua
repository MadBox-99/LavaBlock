-- The board the crystal line is building towards.
--
-- On chemical science although the recipe needs nothing from it: nothing
-- uses the board yet, and what will is meant to be mid-game electronics.
-- Putting the board on red and green would have it sitting in chests from
-- the first hour.
return {
    type = "technology",
    name = "crystal-circuit-board",
    icon = "__LavaBlock-graphics__/graphics/technology/crystal-circuit-board.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "crystal-circuit-board" },
    },
    prerequisites = { "crystal-growing", "chemical-science-pack" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-a-e"
}
