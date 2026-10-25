-- The bioleaching reactor, the leaching bacteria it runs on, and the four
-- ores they leach. Gleba's machine.
--
-- Agricultural science, because the reactor is built on Gleba from a
-- biochamber; Bacteria cultivation, because the culture is grown the way
-- Space Age grows its own. Superalloys hands over the pentlandite line and
-- the cobalt's use, Sulfide ores the sphalerite, and EUV lithography the
-- microchip, which is the only thing on the island that takes gold - the
-- pyrite recipe's product would be a dead end without it.
return {
    type = "technology",
    name = "bioleaching",
    icon = "__LavaBlock-graphics__/graphics/technology/bioleaching.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "bioleaching-reactor" },
        { type = "unlock-recipe", recipe = "leaching-bacteria" },
        { type = "unlock-recipe", recipe = "leaching-bacteria-cultivation" },
        { type = "unlock-recipe", recipe = "pentlandite-bioleaching" },
        { type = "unlock-recipe", recipe = "sphalerite-bioleaching" },
        { type = "unlock-recipe", recipe = "pyrite-biooxidizing" },
        { type = "unlock-recipe", recipe = "slag-bioleaching" },
    },
    prerequisites = {
        "agricultural-science-pack", "bacteria-cultivation", "superalloys",
        "sulfide-ores", "euv-lithography",
    },
    unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack",   1 },
            { "logistic-science-pack",     1 },
            { "chemical-science-pack",     1 },
            { "lava-science-pack",         1 },
            { "space-science-pack",        1 },
            { "agricultural-science-pack", 1 },
        },
        time = 60
    },
    order = "a-v-c",
}
