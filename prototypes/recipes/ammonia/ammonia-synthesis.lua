-- The Haber-Bosch process: nitrogen and hydrogen, one to three, pressed
-- over an iron catalyst at red heat into ammonia. Half the nitrogen in
-- every person alive went through this reaction on its way into their
-- food.
--
-- 20 nitrogen and 60 hydrogen for 40 ammonia, the real ratio. Space Age's
-- ammonia, so it is the same fluid Aquilo's ocean is full of.
--
-- No productivity: gases into a gas.
return {
    type = "recipe",
    name = "ammonia-synthesis",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "fluid", name = "nitrogen", amount = 20 },
        { type = "fluid", name = "hydrogen", amount = 60 },
    },
    results = {
        { type = "fluid", name = "ammonia", amount = 40 },
    },
    allow_productivity = false,
    crafting_machine_tint = {
        primary = { r = 0.38, g = 0.50, b = 0.80, a = 1.0 },
        secondary = { r = 0.70, g = 0.80, b = 0.95, a = 1.0 },
    },
    subgroup = "lava-block-solutions",
    order = "o[ammonia]-a[ammonia-synthesis]",
}
