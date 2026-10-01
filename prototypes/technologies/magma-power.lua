-- The top of the island's power ladder, and its version of fusion: a
-- reactor burning magma cells into plasma, and a fifteen-tile turbine
-- turning the plasma into 250 MW, four of them to a reactor.
--
-- After the geothermal turbine it grows out of, magnetite growing for the
-- coils, limestone processing for the salt, and utility science: this is a
-- rocket-silo-era machine, bigger than a nuclear reactor, and it should not
-- arrive before the player has had to build one.
return {
    type = "technology",
    name = "magma-power",
    icon = "__LavaBlock-graphics__/graphics/technology/magma-power.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "salt-melting" },
        { type = "unlock-recipe", recipe = "molten-salt-cooling" },
        { type = "unlock-recipe", recipe = "magma-cell" },
        { type = "unlock-recipe", recipe = "magma-reactor" },
        { type = "unlock-recipe", recipe = "magma-turbine" },
    },
    prerequisites = {
        "geo-thermal-turbine", "magnetite-growing", "limestone-processing",
        "production-science-pack", "utility-science-pack",
    },
    unit = {
        count = 1500,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
            { "production-science-pack", 1 },
            { "utility-science-pack",    1 },
        },
        time = 60
    },
    order = "a-q-z-a"
}
