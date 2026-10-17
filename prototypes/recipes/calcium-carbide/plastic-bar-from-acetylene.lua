-- Acetylene and hydrochloric acid joined into vinyl chloride and
-- polymerised: PVC the way it was made before oil was cheap, and the way
-- it is still made where coal is.
--
-- 30 acetylene and 30 acid for three plastic bars - a carbide, a third of
-- a coal-and-quicklime arc craft, against vanilla's 20 petroleum gas and a
-- coal for two.
return {
    type = "recipe",
    name = "plastic-bar-from-acetylene",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "acetylene",         amount = 30 },
        { type = "fluid", name = "hydrochloric-acid", amount = 30 },
    },
    results = {
        { type = "item", name = "plastic-bar", amount = 3 },
    },
    allow_productivity = true,
    -- Plastic recycles through the vanilla recipe.
    auto_recycle = false,
    icons = {
        { icon = "__base__/graphics/icons/plastic-bar.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/acetylene.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "f[plastic-bar]-c[acetylene]",
    crafting_machine_tint = {
        primary = { r = 0.94, g = 0.94, b = 0.70, a = 1.0 },
        secondary = { r = 0.80, g = 1.00, b = 0.50, a = 1.0 },
    },
}
