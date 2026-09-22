-- Gated behind calcite-processing-on-lava-block, which is where the island
-- gets steam condensation in the first place: this technology is the answer to
-- the ratio that recipe leaves you with, so it should not be reachable before
-- the player has felt the problem.
return {
    type = "technology",
    name = "water-condenser",
    icon = "__LavaBlock__/graphics/technology/water-condenser.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "condenser-coil" },
        { type = "unlock-recipe", recipe = "water-condenser" },
        { type = "unlock-recipe", recipe = "steam-condensing" },
    },
    prerequisites = { "calcite-processing-on-lava-block", "chemical-science-pack" },
    unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-d"
}
