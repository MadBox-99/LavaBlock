--require("util")
require("src.prototypes.recipe-category")
require("src.prototypes.item-groups")
require("src.prototypes.fluids")
require("src.prototypes.items")
require("src.prototypes.recipes")
require("src.prototypes.entities")
require("src.prototypes.technologies")
require("src.prototypes.islandGeneration")
require("helpers.functions")

remove_technology("electric-mining-drill")

if mods["space-age"] then
    local tech = data.raw.technology["space-platform-thruster"]
    table.insert(tech.effects, { type = "unlock-recipe", recipe = "burner-mining-drill" })
    table.insert(tech.effects, { type = "unlock-recipe", recipe = "electric-mining-drill" })
    table.insert(tech.effects, { type = "unlock-recipe", recipe = "pumpjack" })
    data.raw["fluid"]["lava"].auto_barrel = true
end