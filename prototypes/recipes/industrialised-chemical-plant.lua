local industrialised_chemical_plant = {
    type = "recipe",
    name = "industrialised-chemical-plant",
    enabled = false,
    energy_required = 5,
    crafting_category = "chemical",
    ingredients = {
        { type = "item", name = "biochamber",       amount = 1 },
        { type = "item", name = "steel-plate",      amount = 50 },
        { type = "item", name = "advanced-circuit", amount = 20 },
        { type = "item", name = "pipe",             amount = 30 }
    },
    results = {
        { type = "item", name = "industrialised-chemical-plant", amount = 1 }
    }
}
return industrialised_chemical_plant