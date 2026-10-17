-- Ammonia from nitrogen and hydrogen, nitric acid from ammonia over
-- platinum, and nitrous oxide from the two.
--
-- Blue science. Nitric acid hands over the nitrogen, the Chlor-alkali
-- process the hydrogen, and Precious metals the platinum gauze. Rocket
-- fuel waits on it, because every rocket fuel now burns in nitrous oxide.
return {
    type = "technology",
    name = "ammonia-synthesis",
    -- Layered: the oil research with Space Age's ammonia over it.
    icons = {
        {
            icon = "__base__/graphics/technology/oil-processing.png",
            icon_size = 256,
        },
        {
            icon = "__space-age__/graphics/icons/fluid/ammonia.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "ammonia-synthesis" },
        { type = "unlock-recipe", recipe = "nitric-acid-from-ammonia" },
        { type = "unlock-recipe", recipe = "nitrous-oxide" },
    },
    prerequisites = { "nitric-acid", "chlor-alkali-process", "precious-metals" },
    unit = {
        count = 250,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-m",
}
