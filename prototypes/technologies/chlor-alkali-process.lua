-- Brine from the rock, split three ways by a current, and what the three
-- products are for: hydrochloric acid, the ferric chloride it dissolves
-- iron into, circuit boards etched with it, and magnetite precipitated out
-- of it with the caustic soda.
--
-- Blue science, after Ferromagnetism, because magnetite precipitation hands
-- over magnetite and that technology is where magnetite first gets used.
-- Ferromagnetism already sits behind chemical science and the crystal line,
-- so the refinery and advanced circuits are both there by then. Stone
-- crushing is for the gravel the brine is leached from.
--
-- Chlorine comes earlier this way than from volcanic gas scrubbing, which
-- waits for the lava centrifuge. That is fine: the centrifuge is what
-- chlorine was for, and nothing else before it takes any.
return {
    type = "technology",
    name = "chlor-alkali-process",
    -- Layered, the way Oxygen processing is: a battery for the electrolysis
    -- and the brine it runs on.
    icons = {
        {
            icon = "__base__/graphics/technology/battery.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/brine.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "brine-leaching" },
        { type = "unlock-recipe", recipe = "brine-electrolysis" },
        { type = "unlock-recipe", recipe = "hydrochloric-acid" },
        { type = "unlock-recipe", recipe = "ferric-chloride" },
        { type = "unlock-recipe", recipe = "advanced-circuit-etched" },
        { type = "unlock-recipe", recipe = "magnetite-precipitation" },
    },
    prerequisites = { "ferromagnetism", "stone-crushing" },
    unit = {
        count = 250,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-f-c",
}
