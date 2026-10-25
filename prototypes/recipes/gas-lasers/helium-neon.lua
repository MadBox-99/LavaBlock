-- Helium and neon, nine to one, blended in the gas combiner: the fill of a
-- helium-neon laser. The helium soaks up the discharge and hands its
-- energy to the neon, which is what lases; a tube of neon alone barely
-- does.
return {
    type = "recipe",
    name = "helium-neon",
    categories = { "gas-combining" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "helium", amount = 90 },
        { type = "fluid", name = "neon",   amount = 10 },
    },
    results = {
        { type = "fluid", name = "helium-neon", amount = 100 },
    },
    allow_productivity = false,
    subgroup = "lava-block-noble-gases",
    order = "a[gas]-z[argon]-f[helium-neon]",
}
