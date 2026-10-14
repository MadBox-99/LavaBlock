-- The Birkeland-Eyde process: nitrogen and oxygen through an electric arc
-- at 3000 degrees, which forces them into nitric oxide, and the oxide
-- washed into water as acid. Norway ran it on hydropower for twenty years
-- before cheaper ammonia replaced it. The water is not a third input
-- because the chemical plant has two inlets; the plant washes the oxide
-- into acid it has already made, as an absorption tower does.
--
-- 20 nitrogen and 50 oxygen for 40 acid - two and a half oxygen to a
-- nitrogen, as the equation wants - in eight seconds. The arc is what the
-- real process was known for eating, and eight seconds of a chemical plant
-- is how this one is made to eat it: one plant makes five acid a second.
return {
    type = "recipe",
    name = "nitric-acid",
    category = "chemistry",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "fluid", name = "nitrogen", amount = 20 },
        { type = "fluid", name = "oxygen",   amount = 50 },
    },
    results = {
        { type = "fluid", name = "nitric-acid", amount = 40 },
    },
    allow_productivity = false,
    allow_quality = false,
    subgroup = "fluid-recipes",
    order = "a[gas]-b[nitrogen]-b[nitric-acid]",
    crafting_machine_tint = {
        primary = { r = 0.98, g = 0.47, b = 0.35, a = 1.0 },
        secondary = { r = 0.16, g = 0.69, b = 0.65, a = 1.0 },
    },
}
