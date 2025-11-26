--require("util")
require("prototypes.recipe-category")
require("prototypes.item-subgroups")
require("prototypes.fluids")
require("prototypes.items")
require("prototypes.recipes")
require("prototypes.entities")
require("prototypes.technologies")
require("prototypes.islandGeneration")
require("helpers.functions")

remove_technology("electric-mining-drill")

if mods["space-age"] then
    local tech = data.raw.technology["space-platform-thruster"]
    table.insert(tech.effects, { type = "unlock-recipe", recipe = "burner-mining-drill" })
    table.insert(tech.effects, { type = "unlock-recipe", recipe = "electric-mining-drill" })
    table.insert(tech.effects, { type = "unlock-recipe", recipe = "pumpjack" })
    data.raw["fluid"]["lava"].auto_barrel = true
end