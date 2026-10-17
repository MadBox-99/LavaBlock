-- The vanilla express belt, splitter and underground run on bronze
-- bushings. Vanilla builds the fastest belt out of the same iron gears as
-- the slowest; rollers turning that fast run in bronze, which carries the
-- oil the recipe already pours in.
--
-- Half a bronze plate for every gear: five for the belt's ten, forty for
-- the underground pair's eighty and five for the splitter's ten. A bronze
-- plate is nine tenths of a copper plate, so the iron the gears took is
-- now copper, with a little tin.
local utils = require("lib.utils")

for _, name in pairs({ "express-transport-belt", "express-underground-belt", "express-splitter" }) do
    local recipe = data.raw.recipe[name]
    if recipe then
        for _, ingredient in pairs(recipe.ingredients) do
            if ingredient.name == "iron-gear-wheel" then
                ingredient.name = "bronze-plate"
                ingredient.amount = math.floor(ingredient.amount / 2)
            end
        end
    end
end

-- Bronze comes from Brass, bronze and solder.
utils.add_tech_prereq("logistics-3", "copper-alloys")
