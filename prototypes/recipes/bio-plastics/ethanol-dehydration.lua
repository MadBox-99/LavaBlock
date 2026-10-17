-- Ethanol passed over hot alumina, which strips the water out of it and
-- leaves ethylene: C2H5OH -> C2H4 + H2O. It is ethanol synthesis run
-- backwards, which is why it runs in a chemical plant and not in the Fuel
-- Plant that does the forward reaction.
--
-- 50 ethanol for 50 ethylene and 25 water, two seconds. Fifty ethanol is
-- twenty straw through the fermentation line.
return {
    type = "recipe",
    name = "ethanol-dehydration",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "ethanol", amount = 50 },
    },
    results = {
        { type = "fluid", name = "ethylene", amount = 50 },
        { type = "fluid", name = "water",    amount = 25 },
    },
    main_product = "ethylene",
    -- Fluid into fluid, as on the reformer. The plastic recipe takes
    -- productivity, and one bonus on the line is enough.
    allow_productivity = false,
    allow_quality = false,
    subgroup = "fluid-recipes",
    order = "b[ethanol]-j[ethanol-dehydration]",
    crafting_machine_tint = {
        primary = { r = 0.94, g = 0.51, b = 0.75, a = 1.0 },
        secondary = { r = 0.82, g = 0.78, b = 0.56, a = 1.0 },
    },
}
