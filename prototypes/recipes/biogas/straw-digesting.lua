-- Straw left to rot in a sealed tank, with no air, until the bacteria have
-- turned it to biogas. The fermentation tank is a sealed tank that holds a
-- warm brew, which is all a digester is.
--
-- Ten straw and 50 water for 50 methane, twenty seconds, the same straw and
-- time as fermenting it to wash. What comes out the other end is set by the
-- light oil it ends as: see light oil synthesis.
return {
    type = "recipe",
    name = "straw-digesting",
    categories = { "biomass-fermenting" },
    enabled = false,
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "straw", amount = 10 },
        { type = "fluid", name = "water", amount = 50 },
    },
    results = {
        { type = "fluid", name = "methane", amount = 50 },
    },
    -- A better-kept digester really does turn more of its feed to gas, the
    -- argument the fermentation recipes make.
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/methane.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/straw.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "b[ethanol]-f[straw-digesting]",
    crafting_machine_tint = {
        primary = { r = 0.80, g = 0.66, b = 0.30, a = 1.0 },
        secondary = { r = 0.96, g = 0.59, b = 0.20, a = 1.0 },
    },
}
