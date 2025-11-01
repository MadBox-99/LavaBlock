local locomotiveRecipe = table.deepcopy(data.raw["recipe"]["locomotive"])
local locomotive = table.deepcopy(data.raw["item-with-entity-data"]["locomotive"])
locomotiveRecipe.ingredients = {
    { type = "item",  name = "electronic-circuit", amount = 10 },
    { type = "item",  name = "engine-unit",        amount = 20 },
    { type = "item",  name = "iron-gear-wheel",    amount = 1000 }, -- piece(s) / real-wagon: 10000
    { type = "fluid", name = "lava",               amount = 100000 }
}
locomotiveRecipe.category = "crafting-with-fluid"
locomotiveRecipe.energy_required = 60
locomotiveRecipe.results = {
    { type = "item", name = "locomotive", amount = 1 },
    { type = "item", name = "stone",      amount = 50 }
}
locomotiveRecipe.main_product = "locomotive"
locomotive.weight = 1000 * kg
data.raw["recipe"]["locomotive"] = locomotiveRecipe
data.raw["item-with-entity-data"]["locomotive"] = locomotive
