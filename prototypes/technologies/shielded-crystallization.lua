-- Where the gas line and the crystal line meet.
--
-- Three prerequisites, which is unusual here and deliberate: the recipe it
-- ends in wants purified lava from the centrifuge, argon out of the air
-- compressor and oxygen off water electrolysis, and there is no honest way
-- to hand that over before all three exist.
--
-- It also gives argon something to be. Until now the gas was a prototype
-- with a barrel recipe and no source in the game at all.
return {
    type = "technology",
    name = "shielded-crystallization",
    icon = "__LavaBlock__/graphics/technology/shielded-crystallization.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "gas-combiner" },
        { type = "unlock-recipe", recipe = "argon-extraction" },
        { type = "unlock-recipe", recipe = "shielding-gas" },
        { type = "unlock-recipe", recipe = "silica-crystallizing-shielded" },
    },
    prerequisites = {
        "refined-crystallization",
        "advanced-lava-cooling",
        "oxygen-processing",
    },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
        },
        time = 30
    },
    order = "a-a-c"
}
