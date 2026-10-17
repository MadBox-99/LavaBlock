-- Fluorine split out of hydrofluoric acid, krypton and fluorine blended,
-- and a laser source that lases in the blend.
--
-- After Gas lasers, the laser sources it is an alternative to; Uranium
-- hexafluoride, which hands over the hydrofluoric acid; and Noble gases,
-- which hands over the krypton. It costs what Gas lasers costs.
return {
    type = "technology",
    name = "excimer-lasers",
    icons = {
        {
            icon = "__base__/graphics/technology/laser.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/excimer-gas.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "fluorine-electrolysis" },
        { type = "unlock-recipe", recipe = "excimer-gas" },
        { type = "unlock-recipe", recipe = "laser-source-excimer" },
    },
    prerequisites = { "gas-lasers", "uranium-hexafluoride", "noble-gases" },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
            { "production-science-pack", 1 },
        },
        time = 30,
    },
    order = "a-a-p",
}
