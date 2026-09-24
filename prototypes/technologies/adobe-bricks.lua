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
    -- Placeholder technology icon, like the machine's. See the entity file.
    icon = "__base__/graphics/icons/stone-brick.png",
    icon_size = 64,
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
