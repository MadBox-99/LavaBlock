-- The vanilla lubricant, refined with propane. Lubricating oil is made by
-- dissolving the oil out of heavy residue with liquid propane, which leaves
-- the asphalt behind - propane deasphalting. Vanilla turns heavy oil into
-- lubricant one for one with nothing else.
--
-- Two propane in every ten heavy oil: one petroleum gas fractionation
-- craft keeps twenty-five lubricant crafts going.
local utils = require("lib.utils")

local recipe = data.raw.recipe["lubricant"]
table.insert(recipe.ingredients, { type = "fluid", name = "propane", amount = 2 })

-- Propane comes from Gas fractionation.
utils.add_tech_prereq("lubricant", "gas-fractionation")
