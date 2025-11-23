local geo_thermal_turbine_recipe = {
    type = "recipe",
    name = "geo-thermal-turbine",
    ingredients = {
        { type = "item",  name = "steel-plate",        amount = 100 },
        { type = "item",  name = "iron-gear-wheel",    amount = 50 },
        { type = "item",  name = "electronic-circuit", amount = 20 },
        { type = "fluid", name = "lava",               amount = 10000 }
    },
    results = { { type = "item", name = "geo-thermal-turbine", amount = 1 } },
    energy_required = 20,
    enabled = true,
    category = "crafting-with-fluid"
}
return geo_thermal_turbine_recipe