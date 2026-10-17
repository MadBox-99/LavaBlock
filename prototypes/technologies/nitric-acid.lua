-- Nitrogen sieved out of compressed air, burnt with oxygen in an arc to
-- nitric acid, and the acid used to nitrate explosives.
--
-- After the Air cooler, which is where compressed air and the air filter
-- come from, Oxygen processing for the oxygen, and Explosives, because that
-- is what the acid is for. The Air cooler takes the lava pack; this is
-- researched on chemical science alone, like Oxygen processing.
return {
    type = "technology",
    name = "nitric-acid",
    icons = {
        {
            icon = "__base__/graphics/technology/explosives.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/nitric-acid.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "nitrogen-adsorption" },
        { type = "unlock-recipe", recipe = "nitric-acid" },
        { type = "unlock-recipe", recipe = "explosives-nitrated" },
    },
    prerequisites = { "air-cooler", "oxygen-processing", "explosives" },
    unit = {
        count = 250,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-b-l",
}
