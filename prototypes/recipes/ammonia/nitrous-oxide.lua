-- Ammonia neutralised with nitric acid into ammonium nitrate, and the salt
-- heated gently until it falls apart into nitrous oxide and water - the
-- way it has been made since Davy breathed it in 1799.
--
-- 20 ammonia and 20 nitric acid for 20 nitrous oxide and 40 water, one
-- rocket fuel's worth.
return {
    type = "recipe",
    name = "nitrous-oxide",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "ammonia",     amount = 20 },
        { type = "fluid", name = "nitric-acid", amount = 20 },
    },
    results = {
        { type = "fluid", name = "nitrous-oxide", amount = 20 },
        { type = "fluid", name = "water",         amount = 40 },
    },
    main_product = "nitrous-oxide",
    allow_productivity = false,
    crafting_machine_tint = {
        primary = { r = 0.78, g = 0.80, b = 0.86, a = 1.0 },
        secondary = { r = 0.95, g = 0.80, b = 0.40, a = 1.0 },
    },
    subgroup = "lava-block-solutions",
    order = "o[ammonia]-c[nitrous-oxide]",
}
