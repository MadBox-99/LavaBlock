-- Space Age's foundry recipe for low density structure, with duralumin in
-- it as the island's recipe has. Cast from molten iron and copper alone it
-- cost an eighth of the duralumin one, so after Vulcanus the duralumin was
-- never needed again.
--
-- Five duralumin plates, and half the molten copper: the duralumin is the
-- skin the copper stood in for. Still about half the price of the island's
-- recipe, which is what the foundry is for.
local utils = require("lib.utils")

local recipe = data.raw.recipe["casting-low-density-structure"]
if recipe then
    for _, ingredient in pairs(recipe.ingredients) do
        if ingredient.name == "molten-copper" then
            ingredient.amount = 125
        end
    end
    table.insert(recipe.ingredients, { type = "item", name = "duralumin-plate", amount = 5 })
end

-- Duralumin comes from Light metals.
utils.add_tech_prereq("foundry", "light-metals")
