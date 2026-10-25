-- The fermentation line: the tank, the column and all three feeds.
--
-- Behind the Arboretum and nothing else, because straw and wood both come
-- from there and a fuel line with no feed would be research for nothing.
-- Not the algae feed: Algae cultivation is blue science and this is red and
-- green, so it sat in the menu with nothing to pour in. Algae cultivation
-- now comes after this and hands it over with the algae, so the tank is
-- still researched only once.
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
