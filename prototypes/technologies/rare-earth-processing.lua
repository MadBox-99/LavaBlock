-- Monazite thrown out of purified lava by the centrifuge and cracked in
-- acid into cerium, neodymium, yttrium and phosphorus; neodymium magnets
-- made of them.
--
-- The lava pack's era, after the Lava centrifuge that throws the monazite
-- out, the Chlor-alkali process whose hydrochloric acid cracks it, Boron
-- processing for the magnets' boron and Alloy steels for their nickel,
-- which is cast into plate here for the first time. Laser cutting waits
-- on it for the cerium its lenses are polished with, Silicon refining for
-- the phosphorus its wafers are doped with, and the Mk2 power armour for
-- the magnets in its motors.
return {
    type = "technology",
    name = "rare-earth-processing",
    icon = "__LavaBlock-graphics__/graphics/technology/rare-earth-processing.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "monazite-separating" },
        { type = "unlock-recipe", recipe = "monazite-cracking" },
        { type = "unlock-recipe", recipe = "nickel-casting" },
        { type = "unlock-recipe", recipe = "neodymium-magnet" },
    },
    prerequisites = {
        "lava-centrifuge",
        "chlor-alkali-process",
        "boron-processing",
        "alloy-steels",
    },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
        },
        time = 30,
    },
    order = "a-a-j",
}
