-- The eddy current separator, built on Fulgora as the recycler is: the
-- recipe asks for Fulgora's magnetic field, and the rotor's pole pieces are
-- holmium, which has the strongest magnetic moment of any element and is
-- what real high-field magnets use to concentrate their flux.
--
-- Neodymium magnets for the rotor itself, stainless steel for the drum and
-- the frame round it - a magnetic frame would drag on the rotor's field -
-- and processing units for the drive.
return {
    type = "recipe",
    name = "eddy-current-separator",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "holmium-plate",         amount = 20 },
        { type = "item", name = "neodymium-magnet",      amount = 10 },
        { type = "item", name = "stainless-steel-plate", amount = 20 },
        { type = "item", name = "processing-unit",       amount = 10 },
    },
    results = {
        { type = "item", name = "eddy-current-separator", amount = 1 },
    },
    surface_conditions = {
        { property = "magnetic-field", min = 99 },
    },
}
