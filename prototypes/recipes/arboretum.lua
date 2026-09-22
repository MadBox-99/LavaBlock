-- Eight lamps, which is what is hanging under the eaves over the four beds.
return {
    type = "recipe",
    name = "arboretum",
    enabled = false,
    energy_required = 12,
    ingredients = {
        { type = "item", name = "grow-lamp",          amount = 8 },
        { type = "item", name = "steel-plate",        amount = 50 },
        { type = "item", name = "iron-gear-wheel",    amount = 30 },
        { type = "item", name = "electronic-circuit", amount = 25 },
        { type = "item", name = "pipe",               amount = 40 },
        { type = "item", name = "stone-brick",        amount = 60 },
    },
    results = {
        { type = "item", name = "arboretum", amount = 1 }
    },
}
