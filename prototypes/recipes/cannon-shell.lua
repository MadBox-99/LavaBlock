-- The vanilla cannon shells, in brass cases. Vanilla puts the charge in a
-- case of plastic; a tank gun's case is drawn brass, which seals the breech
-- as it swells under the firing and springs back so the case can be pulled.
--
-- Two brass plates in place of the two plastic bars, in both shells.
local utils = require("lib.utils")

for _, name in pairs({ "cannon-shell", "explosive-cannon-shell" }) do
    local recipe = data.raw.recipe[name]
    if recipe then
        for _, ingredient in pairs(recipe.ingredients) do
            if ingredient.name == "plastic-bar" then
                ingredient.name = "brass-plate"
            end
        end
    end
end

-- Brass comes from Brass, bronze and solder.
utils.add_tech_prereq("tank", "copper-alloys")
