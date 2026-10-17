-- Nickel, chromium and manganese, and the steels made with them: stainless
-- steel, manganese steel and nichrome.
--
-- Blue science. The nickel ore grows out of molten iron, which is Advanced
-- lava smelting's; the chromium ore and the stainless steel both want
-- oxygen, which is Oxygen processing's; Crystal growing is the hearth and
-- the slag, and Arc smelting the furnace everything here is smelted in.
-- Nuclear power, the electric furnace and the tank all wait on it.
return {
    type = "technology",
    name = "alloy-steels",
    -- Layered: the steel research with the alloy over it, as the alloy
    -- icons are themselves vanilla's steel recoloured.
    icons = {
        {
            icon = "__base__/graphics/technology/steel-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/stainless-steel-plate.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "pentlandite-growing" },
        { type = "unlock-recipe", recipe = "pentlandite-smelting" },
        { type = "unlock-recipe", recipe = "chromite-growing" },
        { type = "unlock-recipe", recipe = "chromite-smelting" },
        { type = "unlock-recipe", recipe = "manganese-smelting" },
        { type = "unlock-recipe", recipe = "manganese-casting" },
        { type = "unlock-recipe", recipe = "molten-stainless-steel" },
        { type = "unlock-recipe", recipe = "stainless-steel-casting" },
        { type = "unlock-recipe", recipe = "molten-manganese-steel" },
        { type = "unlock-recipe", recipe = "manganese-steel-casting" },
        { type = "unlock-recipe", recipe = "molten-nichrome" },
        { type = "unlock-recipe", recipe = "nichrome-wire" },
    },
    prerequisites = {
        "arc-smelting",
        "crystal-growing",
        "advanced-lava-smelting",
        "oxygen-processing",
    },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-e",
}
