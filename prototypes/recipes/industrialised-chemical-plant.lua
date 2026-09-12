local industrialised_chemical_plant = {
    type = "recipe",
    name = "industrialised-chemical-plant",
    enabled = false,
    energy_required = 5,
    -- Was `crafting_category = "chemical"`: not a RecipePrototype key, so it was
    -- silently ignored. Renaming it to `category = "chemical"` would be worse --
    -- the plant would only be craftable inside an industrialised chemical plant.
    -- The default "crafting" category is what this build recipe wants.
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