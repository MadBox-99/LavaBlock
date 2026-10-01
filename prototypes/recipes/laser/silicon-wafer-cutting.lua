-- A silica crystal sliced into two wafers. The tint is the blank on the
-- cutter's bed: dark silicon grey.
return {
    type = "recipe",
    name = "silicon-wafer-cutting",
    categories = { "laser-cutting" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item", name = "silica-crystal", amount = 1 },
    },
    results = {
        { type = "item", name = "silicon-wafer", amount = 2 },
    },
    main_product = "silicon-wafer",
    crafting_machine_tint = {
        primary = { r = 0.42, g = 0.44, b = 0.52, a = 1.0 },
    },
    allow_productivity = true,
}
