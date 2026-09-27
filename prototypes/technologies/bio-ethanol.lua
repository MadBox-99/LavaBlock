-- The fermentation line: the tank, the column and all three feeds.
--
-- Behind the Arboretum and nothing else, because straw and wood both come
-- from there and a fuel line with no feed would be research for nothing.
-- The algae recipe comes with it rather than behind the algae technology:
-- it is one more thing to pour into the same tank, and a player who has the
-- algae already should not have to research the tank twice.
return {
    type = "technology",
    name = "bio-ethanol",
    icon = "__LavaBlock-graphics__/graphics/technology/bio-ethanol.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "fermentation-tank" },
        { type = "unlock-recipe", recipe = "distillation-column" },
        { type = "unlock-recipe", recipe = "straw-fermentation" },
        { type = "unlock-recipe", recipe = "wood-fermentation" },
        { type = "unlock-recipe", recipe = "algae-fermentation" },
        { type = "unlock-recipe", recipe = "wash-distillation" },
    },
    prerequisites = { "arboretum" },
    unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-h"
}
