-- The vanilla heat exchanger, built of stainless steel. Its tubes sit in
-- boiling water at five hundred degrees for as long as the reactor runs,
-- which is the one job ordinary steel rusts through; real steam generators
-- are stainless or nickel alloy for that reason.
--
-- Ten stainless plates in place of the ten steel plates: seven steel, two
-- chromium and one nickel.
local utils = require("lib.utils")

local recipe = data.raw.recipe["heat-exchanger"]
recipe.ingredients = {
    { type = "item", name = "stainless-steel-plate", amount = 10 },
    { type = "item", name = "copper-plate",          amount = 100 },
    { type = "item", name = "pipe",                  amount = 10 },
}

-- Stainless steel comes from Alloy steels. Space Age hands the heat
-- exchanger over on Gleba as well, with the heating tower.
utils.add_tech_prereq("nuclear-power", "alloy-steels")
utils.add_tech_prereq("heating-tower", "alloy-steels")
