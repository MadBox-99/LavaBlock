-- Follows the arboretum: you learn to grow things, then you learn to grow the
-- things that are not trees. Two buildings, because growing and pressing are
-- different jobs: the algae tank raises the culture, the bio garden presses
-- the harvest and scrubs the air while it does. Green and red algae, and the
-- two substances pressed back out of them; blue waits for
-- [nitrogen-fixation], which is where the air to feed it finally exists.
return {
    type = "technology",
    name = "bio-garden",
    icon = "__LavaBlock__/graphics/technology/bio-garden.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "bio-garden" },
        { type = "unlock-recipe", recipe = "algae-tank" },
        { type = "unlock-recipe", recipe = "algae-green" },
        { type = "unlock-recipe", recipe = "algae-red" },
        { type = "unlock-recipe", recipe = "algae-fibre-pressing" },
        { type = "unlock-recipe", recipe = "calcite-precipitation" },
    },
    prerequisites = { "arboretum", "chemical-science-pack" },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-f"
}
