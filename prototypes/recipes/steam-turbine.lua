-- The vanilla steam turbine, with a generator in it. Vanilla asks for fifty
-- copper plates and nothing that makes electricity; a generator is magnets
-- turning past coils, so the copper becomes ten coils (forty plates of
-- copper in their windings) and five ferrite magnets join them.
--
-- And blades: five superalloy plates. The first stages of a turbine take
-- steam at 500 degrees, and their blades are nickel superalloy, as a jet
-- engine's are.
local utils = require("lib.utils")

local recipe = data.raw.recipe["steam-turbine"]
recipe.ingredients = {
    { type = "item", name = "iron-gear-wheel", amount = 50 },
    { type = "item", name = "pipe",            amount = 20 },
    { type = "item", name = "magnetic-coil",   amount = 10 },
    { type = "item", name = "ferrite-magnet",  amount = 5 },
    { type = "item", name = "superalloy-plate", amount = 5 },
}

-- Both technologies that hand the turbine over have to come after
-- Ferromagnetism, or one of them unlocks a recipe nothing can make yet.
-- Heating tower is Gleba's, and only exists with Space Age.
utils.add_tech_prereq("nuclear-power", "ferromagnetism")
utils.add_tech_prereq("heating-tower", "ferromagnetism")
-- And after Superalloys, for the blades.
utils.add_tech_prereq("nuclear-power", "superalloys")
utils.add_tech_prereq("heating-tower", "superalloys")
