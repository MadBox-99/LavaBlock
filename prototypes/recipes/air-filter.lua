-- Cheap on purpose. The filter is not an upgrade you work towards, it is a
-- second box the air line has always needed and never had - splitting a job
-- off the compressor should not cost as much as the compressor did.
return {
    type = "recipe",
    name = "air-filter",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item", name = "steel-plate",       amount = 20 },
        { type = "item", name = "pipe",              amount = 15 },
        { type = "item", name = "iron-gear-wheel",   amount = 10 },
        { type = "item", name = "electronic-circuit", amount = 10 },
    },
    results = {
        { type = "item", name = "air-filter", amount = 1 }
    },
}
