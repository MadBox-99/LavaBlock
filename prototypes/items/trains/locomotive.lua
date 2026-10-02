local locomotiveRecipe = table.deepcopy(data.raw["recipe"]["locomotive"])
local locomotive = table.deepcopy(data.raw["item-with-entity-data"]["locomotive"])
locomotiveRecipe.ingredients = {
    { type = "item",  name = "electronic-circuit", amount = 10 },
    { type = "item",  name = "engine-unit",        amount = 20 },
    { type = "item",  name = "iron-gear-wheel",    amount = 1000 }, -- piece(s) / real-wagon: 10000
    { type = "item",  name = "condenser-coil",     amount = 4 },    -- engine cooling
    { type = "item",  name = "pump",               amount = 2 },    -- coolant and fuel
    { type = "fluid", name = "lava",               amount = 100000 }
}
-- Only the train factory builds rolling stock; red on its track.
locomotiveRecipe.category = "rolling-stock-assembling"
locomotiveRecipe.crafting_machine_tint = {
    primary = { r = 0.78, g = 0.18, b = 0.10, a = 1.0 },
}
locomotiveRecipe.energy_required = 60
locomotiveRecipe.results = {
    { type = "item", name = "locomotive", amount = 1 },
    { type = "item", name = "stone",      amount = 50 }
}
locomotiveRecipe.main_product = "locomotive"
locomotive.weight = 1000 * kg
data.raw["recipe"]["locomotive"] = locomotiveRecipe
data.raw["item-with-entity-data"]["locomotive"] = locomotive
