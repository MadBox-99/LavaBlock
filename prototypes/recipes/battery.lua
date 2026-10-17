-- The vanilla battery, made a lead-acid battery: lead plates in sulfuric
-- acid, which is what the acid was always for. Vanilla builds it from an
-- iron and a copper plate.
--
-- The iron stays, as the case and the terminals; the copper becomes lead.
-- One lead plate is a third of a galena craft, so a crystallizer keeps a
-- chemical plant of batteries running.
local utils = require("lib.utils")

local recipe = data.raw.recipe["battery"]
recipe.ingredients = {
    { type = "fluid", name = "sulfuric-acid", amount = 20 },
    { type = "item",  name = "iron-plate",    amount = 1 },
    { type = "item",  name = "lead-plate",    amount = 1 },
}

-- Lead comes from Sulfide ores.
utils.add_tech_prereq("battery", "sulfide-ores")
