-- Brass, bronze and solder: copper alloyed with zinc and with tin, and tin
-- with lead.
--
-- Blue science. Sulfide ores hands over the lead and the zinc, Arc smelting
-- the furnace, and Advanced lava smelting the molten copper brass and
-- bronze are made from; the tin's cassiterite grows from chlorine, so the
-- Chlor-alkali process - the first chlorine there is without the lava
-- centrifuge - comes before it, and the cassiterite and tin recipes are
-- unlocked here as well as by EUV lithography. The processing unit, the
-- tank's shells and the express belts wait on it.
return {
    type = "technology",
    name = "copper-alloys",
    -- Layered: the steel research with the alloy over it, as the alloy
    -- icons are themselves vanilla's steel recoloured.
    icons = {
        {
            icon = "__base__/graphics/technology/steel-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/brass-plate.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "cassiterite-growing" },
        { type = "unlock-recipe", recipe = "tin-plate" },
        { type = "unlock-recipe", recipe = "molten-brass" },
        { type = "unlock-recipe", recipe = "brass-casting" },
        { type = "unlock-recipe", recipe = "molten-bronze" },
        { type = "unlock-recipe", recipe = "bronze-casting" },
        { type = "unlock-recipe", recipe = "molten-solder" },
        { type = "unlock-recipe", recipe = "solder" },
    },
    prerequisites = { "arc-smelting", "sulfide-ores", "chlor-alkali-process", "advanced-lava-smelting" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-f",
}
