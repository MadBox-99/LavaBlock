-- Copper refined by electrolysis, and silver, gold and platinum parted out
-- of the slime it leaves.
--
-- Blue science. Nitric acid and the Chlor-alkali process hand over the two
-- acids aqua regia is mixed from; the copper's sulfuric acid is older than
-- either. Laser cutting waits on it for the silver in the wafer solar
-- panel, and EUV lithography for the gold in every microchip.
return {
    type = "technology",
    name = "precious-metals",
    icon = "__LavaBlock-graphics__/graphics/technology/precious-metals.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "copper-electrorefining" },
        { type = "unlock-recipe", recipe = "anode-slime-refining" },
    },
    prerequisites = { "nitric-acid", "chlor-alkali-process" },
    unit = {
        count = 250,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-l",
}
