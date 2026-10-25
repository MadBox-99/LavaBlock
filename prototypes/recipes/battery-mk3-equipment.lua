-- Space Age's personal battery MK3, with lithium-ion cells in it. The MK2
-- batteries it is built from are the island's lead-acid kind; a suit's
-- last battery should be lithium.
--
-- Ten cells on top of the five MK2 batteries and ten supercapacitors, so
-- the MK3 battery now waits on Lithium-ion cells and comes after Aquilo.
local utils = require("lib.utils")

local recipe = data.raw.recipe["battery-mk3-equipment"]
if recipe then
    table.insert(recipe.ingredients,
        { type = "item", name = "lithium-ion-cell", amount = 10 })
end

-- Lithium-ion cells come from Lithium-ion cells.
utils.add_tech_prereq("battery-mk3-equipment", "lithium-ion-cells")
