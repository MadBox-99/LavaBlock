-- The growing half, split out of [bio-garden].
--
-- Follows the arboretum: you learn to grow trees, then you learn to grow the
-- things that are not trees. This hands over the tank, the columns it is
-- built from, and the two strains that can be raised without an air line -
-- green on mineral water and red on hot water. Blue waits for
-- [nitrogen-fixation], which is where the air to feed it finally exists.
--
-- Nothing here presses the harvest. That is the bio garden's job and its own
-- research, which follows this one: until the tank is running there is no
-- culture to press, and handing a player both buildings at once left them
-- with no idea which to put down first.
return {
    type = "technology",
    name = "algae-cultivation",
    icon = "__LavaBlock__/graphics/technology/algae-cultivation.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "culture-column" },
        { type = "unlock-recipe", recipe = "algae-tank" },
        { type = "unlock-recipe", recipe = "algae-green" },
        { type = "unlock-recipe", recipe = "algae-red" },
    },
    prerequisites = { "arboretum", "chemical-science-pack" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-ea"
}
