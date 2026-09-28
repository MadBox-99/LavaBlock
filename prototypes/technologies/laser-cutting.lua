-- The laser cutter, the quartz its lenses are cast from, and the two
-- things it cuts and what they are for.
--
-- Everything it hands over has a use inside the same research: the quartz
-- goes into lenses, the lenses into the cutter, the wafers into solar panels
-- and the substrate into processing units. Processing unit and Solar energy
-- are prerequisites for that reason - a second recipe for a thing the player
-- cannot make yet would be one more recipe doing nothing in the menu.
return {
    type = "technology",
    name = "laser-cutting",
    icon = "__LavaBlock-graphics__/graphics/technology/laser-cutting.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "quartz-melting" },
        { type = "unlock-recipe", recipe = "quartz-lens" },
        { type = "unlock-recipe", recipe = "laser-cutter" },
        { type = "unlock-recipe", recipe = "silicon-wafer-cutting" },
        { type = "unlock-recipe", recipe = "sapphire-substrate-cutting" },
        { type = "unlock-recipe", recipe = "solar-panel-from-wafers" },
        { type = "unlock-recipe", recipe = "sapphire-processing-unit" },
    },
    prerequisites = { "crystal-circuit-board", "processing-unit", "solar-energy" },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-a-g"
}
