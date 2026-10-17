-- Ozone from oxygen by a silent discharge.
--
-- Blue science, after Oxygen processing, which hands over the oxygen. The
-- processing unit waits on it: its wafers are washed in ozone instead of
-- sulfuric acid.
return {
    type = "technology",
    name = "ozone-generation",
    icons = {
        {
            icon = "__base__/graphics/technology/oil-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/ozone.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "oxygen-ozonizing" },
    },
    prerequisites = { "oxygen-processing" },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-q",
}
