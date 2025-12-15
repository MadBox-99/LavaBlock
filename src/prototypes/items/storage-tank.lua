local fluidTankRecipe = table.deepcopy(data.raw["recipe"]["storage-tank"])
local fluidTank = table.deepcopy(data.raw["item"]["storage-tank"])

fluidTankRecipe.ingredients = {
    { type = "item",  name = "iron-plate", amount = 50 }, -- pneumatic brake system
    { type = "fluid", name = "lava",       amount = 50000 }
}
fluidTankRecipe.category = "crafting-with-fluid"
fluidTankRecipe.energy_required = 30
fluidTankRecipe.enabled = false

fluidTank.weight = 1000 / 50 * kg

data.raw["recipe"]["storage-tank"] = fluidTankRecipe
data.raw["item"]["storage-tank"] = fluidTank
