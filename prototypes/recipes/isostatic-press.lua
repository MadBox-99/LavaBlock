-- The isostatic press, built on Vulcanus as the foundry is: the recipe
-- asks for Vulcanus's pressure, and the vessel's liner is tungsten carbide,
-- which only Vulcanus has the ore for. Superalloy for the furnace inside
-- the vessel, which has to hold its shape at 1300 degrees; motors for the
-- compressor and the chiller; processing units to run the pressure cycle.
--
-- Not tungsten plate. Tungsten steel is only researched after the big
-- mining drill is built, and the drill's bits now come out of this press.
return {
    type = "recipe",
    name = "isostatic-press",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "tungsten-carbide",    amount = 20 },
        { type = "item", name = "superalloy-plate",    amount = 10 },
        { type = "item", name = "electric-engine-unit", amount = 5 },
        { type = "item", name = "processing-unit",     amount = 10 },
    },
    results = {
        { type = "item", name = "isostatic-press", amount = 1 },
    },
    surface_conditions = {
        { property = "pressure", min = 4000, max = 4000 },
    },
}
