-- Ethane cracked with steam at 850 degrees: a hydrogen comes off each
-- molecule and leaves ethylene. Most of the world's ethylene is made this
-- way, and in the United States nearly all of it.
--
-- 40 ethane and 20 steam for 30 ethylene and 30 hydrogen. Ethylene from
-- ethanol takes 50 ethanol for 50; this is the oil man's way to the same
-- plastic.
return {
    type = "recipe",
    name = "ethane-cracking",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "ethane", amount = 40 },
        { type = "fluid", name = "steam",  amount = 20 },
    },
    results = {
        { type = "fluid", name = "ethylene", amount = 30 },
        { type = "fluid", name = "hydrogen", amount = 30 },
    },
    main_product = "ethylene",
    allow_productivity = false,
    crafting_machine_tint = {
        primary = { r = 0.70, g = 0.86, b = 0.94, a = 1.0 },
        secondary = { r = 1.00, g = 0.80, b = 0.85, a = 1.0 },
    },
    subgroup = "lava-block-organics",
    order = "b[fluid-chemistry]-z[ethane-cracking]",
}
