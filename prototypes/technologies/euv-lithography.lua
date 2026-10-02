-- The lithography machine, the laser source it burns through, the tin line
-- that feeds both, and the chips and what they are for.
--
-- Everything it hands over has a use inside the same research: the
-- cassiterite is smelted to tin, the tin goes into laser sources and into
-- every chip, and the chips into processing units. Laser cutting is behind
-- it for the wafers and the lenses, Magnetite growing for the stage
-- magnets, Chlorinated purification for the chlorine the cassiterite grows
-- from, and production science because this is a factory-of-factories
-- machine and should not arrive before the player has had to build one.
return {
    type = "technology",
    name = "euv-lithography",
    icon = "__LavaBlock-graphics__/graphics/technology/euv-lithography.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "cassiterite-growing" },
        { type = "unlock-recipe", recipe = "tin-plate" },
        { type = "unlock-recipe", recipe = "laser-source" },
        { type = "unlock-recipe", recipe = "lithography-machine" },
        { type = "unlock-recipe", recipe = "microchip" },
        { type = "unlock-recipe", recipe = "microchip-processing-unit" },
    },
    prerequisites = {
        "laser-cutting", "magnetite-growing", "chlorinated-purification",
        "production-science-pack",
    },
    unit = {
        count = 750,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
            { "production-science-pack", 1 },
        },
        time = 60
    },
    order = "a-a-h"
}
