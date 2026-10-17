-- Aluminium and magnesium, both won by electricity, and duralumin made of
-- them.
--
-- Blue science. The Chlor-alkali process hands over the caustic soda the
-- alumina is leached with and the brine the magnesium comes out of;
-- Limestone processing the slaked lime that precipitates it; Arc smelting
-- the furnace both are smelted in. Low density structure waits on it.
return {
    type = "technology",
    name = "light-metals",
    icon = "__LavaBlock-graphics__/graphics/technology/light-metals.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "alumina-leaching" },
        { type = "unlock-recipe", recipe = "aluminium-smelting" },
        { type = "unlock-recipe", recipe = "magnesium-electrolysis" },
        { type = "unlock-recipe", recipe = "magnesium-casting" },
        { type = "unlock-recipe", recipe = "molten-duralumin" },
        { type = "unlock-recipe", recipe = "duralumin-casting" },
    },
    prerequisites = { "arc-smelting", "chlor-alkali-process", "limestone-processing" },
    unit = {
        count = 250,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-g",
}
