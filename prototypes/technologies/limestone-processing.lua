-- The whole lime line in one research, slag to concrete.
--
-- One and not two because every step between the ends is an intermediate
-- with exactly one use - the next step. Split anywhere, the first half
-- would hand over a product that nothing can take until the second half is
-- researched, which is the thing this mod has been pulling out of its tech
-- tree.
--
-- The pug mill (Adobe bricks) mixes the mortar, and Concrete has to exist
-- before a second way of making it means anything. The slag recipe is also
-- handed over by Crystal growing, whichever of the two comes first.
return {
    type = "technology",
    name = "limestone-processing",
    icon = "__LavaBlock-graphics__/graphics/technology/limestone-processing.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "lava-slag-skimming" },
        { type = "unlock-recipe", recipe = "lava-slag-leaching" },
        { type = "unlock-recipe", recipe = "coal-combustion" },
        { type = "unlock-recipe", recipe = "limestone-carbonation" },
        { type = "unlock-recipe", recipe = "limestone-calcination" },
        { type = "unlock-recipe", recipe = "lime-slaking" },
        { type = "unlock-recipe", recipe = "lime-mortar" },
        { type = "unlock-recipe", recipe = "lime-concrete" },
    },
    prerequisites = { "adobe-bricks", "concrete" },
    unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    },
    order = "a-c-g"
}
