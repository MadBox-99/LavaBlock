-- Eight lamps, which is what is hanging under the eaves over the four beds,
-- and twelve glazed panels, which is the glasshouse they hang inside. The
-- plate count comes down by the same weight of steel the panels carry, so
-- the building is a step longer to reach and no dearer once you are there.
return {
    type = "recipe",
    name = "arboretum",
    enabled = false,
    energy_required = 12,
    ingredients = {
        { type = "item", name = "grow-lamp",          amount = 8 },
        { type = "item", name = "glazed-panel",       amount = 12 },
        { type = "item", name = "steel-plate",        amount = 38 },
        { type = "item", name = "iron-gear-wheel",    amount = 30 },
        { type = "item", name = "electronic-circuit", amount = 25 },
        { type = "item", name = "pipe",               amount = 40 },
        { type = "item", name = "stone-brick",        amount = 60 },
    },
    results = {
        { type = "item", name = "arboretum", amount = 1 }
    },
}
