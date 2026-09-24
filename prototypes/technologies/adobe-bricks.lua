-- Behind stone crushing, because it eats that machine's gravel, and not
-- behind anything else: the whole point is a brick route that needs no
-- furnace, so gating it on smelting research would be backwards.
--
-- The reinforced recipe comes with it rather than in a technology of its
-- own. It needs wood, so the Arboretum already gates it in practice, and a
-- second technology would be a research cost for a recipe the player cannot
-- run yet anyway.
return {
    type = "technology",
    name = "adobe-bricks",
    -- Rendered from the same model at --tech-elev 40. At the default 30 the
    -- tub's own wall hides the mix and the product shot is an empty crock.
    icon = "__LavaBlock-graphics__/graphics/technology/pug-mill.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "pug-mill" },
        { type = "unlock-recipe", recipe = "adobe-bricks" },
        { type = "unlock-recipe", recipe = "adobe-bricks-reinforced" },
    },
    prerequisites = { "stone-crushing" },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    },
    order = "a-c-f"
}
