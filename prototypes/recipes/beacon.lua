-- The vanilla beacon, with microchips in its transmitter. A beacon reaches
-- into the modules of every machine round it, and that is the island's
-- EUV chips' work; the circuits vanilla gives it stay for the rest.
--
-- Five microchips a beacon, a craft and a quarter on the lithography
-- machine. Effect transmission already needs production science, as EUV
-- lithography does, so it only waits on that research.
local utils = require("lib.utils")

local recipe = data.raw.recipe["beacon"]
table.insert(recipe.ingredients, { type = "item", name = "microchip", amount = 5 })

-- Microchips come from EUV lithography.
utils.add_tech_prereq("effect-transmission", "euv-lithography")
