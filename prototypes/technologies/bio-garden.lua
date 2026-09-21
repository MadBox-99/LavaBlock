-- Follows the arboretum: you learn to grow things, then you learn to grow the
-- things that are not trees. Green and red algae, and the two substances
-- pressed back out of them. Blue waits for [nitrogen-fixation], which is
-- where the air to feed it finally exists.
return {
    type = "technology",
    name = "bio-garden",
    icon = "__space-age__/graphics/technology/bioflux.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "bio-garden" },
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
