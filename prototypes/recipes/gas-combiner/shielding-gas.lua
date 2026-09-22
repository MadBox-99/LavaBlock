-- Argon and a measured trace of oxygen, blended.
--
-- Nine parts to one, which is roughly the real ratio for a crystal-growing
-- atmosphere and also the ratio that makes argon the thing you queue for:
-- oxygen already comes off water electrolysis in quantity, argon has to be
-- squeezed out of air twenty units at a time.
return {
    type = "recipe",
    name = "shielding-gas",
    category = "gas-combining",
    subgroup = "fluid-recipes",
    order = "a[gas]-z[argon]-a[shielding-gas]",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "fluid", name = "argon",  amount = 90 },
        { type = "fluid", name = "oxygen", amount = 10 },
    },
    results = {
        { type = "fluid", name = "shielding-gas", amount = 100 }
    },
    allow_productivity = true,
}
