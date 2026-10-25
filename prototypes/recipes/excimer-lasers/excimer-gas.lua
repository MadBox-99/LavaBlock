-- Krypton with a tenth of fluorine, blended in the gas combiner: the fill
-- of a krypton fluoride excimer laser. 45 krypton and 5 fluorine for 50.
return {
    type = "recipe",
    name = "excimer-gas",
    categories = { "gas-combining" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "krypton",  amount = 45 },
        { type = "fluid", name = "fluorine", amount = 5 },
    },
    results = {
        { type = "fluid", name = "excimer-gas", amount = 50 },
    },
    allow_productivity = false,
    subgroup = "lava-block-noble-gases",
    order = "a[gas]-z[argon]-h[excimer-gas]",
}
