-- Radon held in a tank while it decays. Every radon atom that goes gives off
-- four alpha particles on its way down to lead, and each alpha particle is
-- a helium atom waiting for its electrons; the lead settles at the bottom.
--
-- 50 radon for 100 helium in thirty seconds - a long hold, as a real
-- decay is - and a lead plate one craft in four.
return {
    type = "recipe",
    name = "radon-decaying",
    category = "chemistry",
    enabled = false,
    energy_required = 30,
    ingredients = {
        { type = "fluid", name = "radon", amount = 50 },
    },
    results = {
        { type = "fluid", name = "helium",     amount = 100 },
        { type = "item",  name = "lead-plate", amount = 1, probability = 0.25 },
    },
    main_product = "helium",
    allow_productivity = false,
    crafting_machine_tint = {
        primary = { r = 0.98, g = 0.86, b = 0.62, a = 1.0 },
        secondary = { r = 0.86, g = 0.47, b = 0.47, a = 1.0 },
    },
    subgroup = "fluid-recipes",
    order = "a[gas]-z[argon]-e[helium]",
}
