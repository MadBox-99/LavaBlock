-- The vanilla electric furnace, given the heating elements it never had.
-- An electric resistance furnace is wound with nichrome wire - nothing
-- else glows red-hot for years without scaling through - and vanilla builds
-- one from steel, circuits and brick alone.
--
-- Ten wire is two plates of nickel-chromium per furnace.
local utils = require("lib.utils")

local recipe = data.raw.recipe["electric-furnace"]
table.insert(recipe.ingredients,
    { type = "item", name = "nichrome-wire", amount = 10 })

-- Nichrome comes from Alloy steels.
utils.add_tech_prereq("advanced-material-processing-2", "alloy-steels")
