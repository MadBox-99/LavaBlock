-- Space Age's portable fusion reactor, with lithium-ion cells to carry the
-- suit between pulses. A fusion core does not throttle like a fission one;
-- something has to hold the charge, and in a suit that light it is
-- lithium.
--
-- Twenty cells, ten runs of the cell line. With the MK3 battery this is where
-- the cells go: both come after Aquilo, as the cells do.
local utils = require("lib.utils")

local recipe = data.raw.recipe["fusion-reactor-equipment"]
if recipe then
    table.insert(recipe.ingredients, { type = "item", name = "lithium-ion-cell", amount = 20 })
end

-- Lithium-ion cells come from Lithium-ion cells.
utils.add_tech_prereq("fusion-reactor-equipment", "lithium-ion-cells")
