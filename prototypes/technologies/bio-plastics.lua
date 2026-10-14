-- Plastic from straw: ethanol dehydrated to ethylene, and the ethylene
-- made into PVC with hydrochloric acid.
--
-- After Bio-ethanol, for the ethanol, Plastics, so that the bar has its
-- uses, and the Chlor-alkali process, for the acid. The last of these is
-- chemical science, so this is too.
return {
    type = "technology",
    name = "bio-plastics",
    icons = {
        {
            icon = "__base__/graphics/technology/plastics.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/ethylene.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "ethanol-dehydration" },
        { type = "unlock-recipe", recipe = "plastic-bar-from-ethylene" },
    },
    prerequisites = { "bio-ethanol", "plastics", "chlor-alkali-process" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-b-m",
}
