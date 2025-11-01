local fluidwagonRecipe = table.deepcopy(data.raw["recipe"]["fluid-wagon"])
local fluidwagon = table.deepcopy(data.raw["item-with-entity-data"]["fluid-wagon"])

fluidwagonRecipe.ingredients = {
    { type = "item",  name = "storage-tank",       amount = 3 },
    { type = "item",  name = "pipe",               amount = 500 },  -- piece(s) / real-wagon: 1000-2000
    { type = "item",  name = "electronic-circuit", amount = 10 },
    { type = "item",  name = "solar-panel",        amount = 1 },    -- piece(s) / real-wagon: 4000-8000
    { type = "item",  name = "iron-gear-wheel",    amount = 1000 }, -- piece(s) / real-wagon: 3000-6000
    { type = "fluid", name = "lava",               amount = 50000 }
}
fluidwagonRecipe.category = "crafting-with-fluid"
fluidwagonRecipe.energy_required = 30
fluidwagonRecipe.enabled = false
fluidwagon.weight = 1000 * kg
data.raw["recipe"]["fluid-wagon"] = fluidwagonRecipe
data.raw["item-with-entity-data"]["fluid-wagon"] = fluidwagon
