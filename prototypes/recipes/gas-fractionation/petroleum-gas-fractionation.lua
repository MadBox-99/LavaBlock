-- Petroleum gas chilled and distilled in the refinery's column into what
-- it is made of: propane, which liquefies first, and ethane.
--
-- 100 petroleum gas for 50 of each. No productivity: one fluid split into
-- two.
return {
    type = "recipe",
    name = "petroleum-gas-fractionation",
    categories = { "oil-processing" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "fluid", name = "petroleum-gas", amount = 100 },
    },
    results = {
        { type = "fluid", name = "propane", amount = 50 },
        { type = "fluid", name = "ethane",  amount = 50 },
    },
    allow_productivity = false,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/gas/propane.png", icon_size = 64 },
        {
            icon = "__base__/graphics/icons/fluid/petroleum-gas.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "b[fluid-chemistry]-z[petroleum-gas-fractionation]",
}
