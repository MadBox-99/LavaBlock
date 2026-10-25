-- Space Age's big mining drill, its bits of cemented carbide. A drill bit
-- of pure tungsten carbide shatters on the first hard rock; every real
-- carbide bit is the carbide bound in cobalt, which is what the isostatic
-- press makes.
--
-- Twenty cemented carbide in place of the twenty tungsten carbide, so the
-- big drill now waits on the press. That is the only reason Hot isostatic
-- pressing sits on the way to tungsten steel and metallurgic science.
local utils = require("lib.utils")

local recipe = data.raw.recipe["big-mining-drill"]
if recipe then
    for _, ingredient in pairs(recipe.ingredients) do
        if ingredient.name == "tungsten-carbide" then
            ingredient.name = "cemented-carbide"
        end
    end
end

-- Cemented carbide comes from Hot isostatic pressing.
utils.add_tech_prereq("big-mining-drill", "hot-isostatic-pressing")
