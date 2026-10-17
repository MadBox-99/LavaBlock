-- Hydrogen burnt in chlorine, one to one, and the hydrogen chloride taken
-- up in water. The water is not a third input because the chemical plant
-- has two inlets; the plant is taken to absorb the gas into acid it has
-- already made, as a real absorption tower does.
--
-- 25 of each gas for 50 acid, one second. The brine cell makes the two
-- gases one for one, 6 a second each, so one refinery's worth of brine is a
-- quarter of this plant.
return {
    type = "recipe",
    name = "hydrochloric-acid",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "chlorine", amount = 25 },
        { type = "fluid", name = "hydrogen", amount = 25 },
    },
    results = {
        { type = "fluid", name = "hydrochloric-acid", amount = 50 },
    },
    allow_productivity = false,
    allow_quality = false,
    subgroup = "fluid-recipes",
    order = "d[chlor-alkali]-c[hydrochloric-acid]",
    crafting_machine_tint = {
        primary = { r = 0.71, g = 0.92, b = 0.35, a = 1.0 },
        secondary = { r = 0.80, g = 1.00, b = 0.50, a = 1.0 },
    },
}
