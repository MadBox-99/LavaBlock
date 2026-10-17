-- The sulfur line that needs no oil: gas drawn off lava, split in the
-- refinery, and its two sulfur gases burnt to liquid sulfur or oxidised to
-- acid.
--
-- Blue science, after Oxygen processing, because the contact process
-- takes oxygen and electrolysis is where it comes from. Chemical science
-- already sits behind Sulfur processing and Oil processing, so the
-- refinery and the acid are both there by then. Concrete and Stone
-- crushing are prerequisites for sulfur concrete alone: concrete has to
-- mean something, and the gravel it binds comes from the crusher.
return {
    type = "technology",
    name = "volcanic-gas-processing",
    -- Layered, the way Oxygen processing is: no machine to show, and the
    -- gas itself is the new thing.
    icons = {
        {
            icon = "__base__/graphics/technology/sulfur-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/volcanic-gas.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "lava-degassing" },
        { type = "unlock-recipe", recipe = "volcanic-gas-fractionation" },
        { type = "unlock-recipe", recipe = "sulfur-recovering" },
        { type = "unlock-recipe", recipe = "sulfur-prilling" },
        { type = "unlock-recipe", recipe = "sulfuric-acid-from-sulfur-dioxide" },
        { type = "unlock-recipe", recipe = "sulfur-concrete" },
    },
    prerequisites = { "oxygen-processing", "concrete", "stone-crushing" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-b-h",
}
