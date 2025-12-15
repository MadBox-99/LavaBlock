local cargowagonRecipe = table.deepcopy(data.raw["recipe"]["cargo-wagon"])
local cargowagon = table.deepcopy(data.raw["item-with-entity-data"]["cargo-wagon"])

cargowagonRecipe.ingredients = {
    { type = "item",  name = "pipe",            amount = 100 },  -- pneumatic brake system
    { type = "item",  name = "engine-unit",     amount = 4 },    -- axle bearings, bogie parts
    { type = "item",  name = "iron-gear-wheel", amount = 1000 }, -- iron gear wheel
    { type = "item",  name = "iron-chest",      amount = 10 },   -- internal stowage + fittings
    { type = "fluid", name = "lava",            amount = 50000 }
}
cargowagonRecipe.category = "crafting-with-fluid"
cargowagonRecipe.energy_required = 30
cargowagonRecipe.enabled = false

cargowagon.weight = 1000 * kg
data.raw["recipe"]["cargo-wagon"] = cargowagonRecipe
data.raw["item-with-entity-data"]["cargo-wagon"] = cargowagon
