local locomotive = table.deepcopy(data.raw["recipe"]["locomotive"])

locomotive.ingredients = {
    { type = "item", name = "electronic-circuit", amount = 10 },
    { type = "item", name = "engine-unit",        amount = 20 },
    { type = "item", name = "iron-gear-wheel",    amount = 1000 }, -- piece(s) / real-wagon: 10000
    { type = "fluid", name = "lava",               amount = 100000 }
}
locomotive.category = "crafting-with-fluid"
locomotive.energy_required = 60
locomotive.results = {
    { type = "item", name = "locomotive", amount = 1 },
    { type = "item", name = "stone", amount = 50 }
}
locomotive.main_product = "locomotive"
--[[ 
local recipe = {
    type = "recipe",
    name = "locomotive",
    energy_required = 60,
    enabled = false,
    category = "crafting-with-fluid",
    ingredients =
    {
        { type = "item",  name = "electronic-circuit", amount = 10 },
        { type = "item",  name = "engine-unit",        amount = 20 },
        { type = "item",  name = "iron-gear-wheel",    amount = 1000 }, -- piece(s) / real-wagon: 10000
        { type = "fluid", name = "lava",               amount = 100000 }
    },
    results = {
        { type = "item", name = "locomotive", amount = 1 },
        { type = "item", name = "stone", amount = 50 }
    }
}  ]]
data.raw["recipe"]["locomotive"] = locomotive
