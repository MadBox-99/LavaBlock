-- The pane poured straight into its steel frame, with no sheet of glass
-- in between.
--
-- 75 molten glass, the three glass the plain recipe takes at 25 each, so
-- it costs the same melt and saves only the casting step. That is all it
-- is for: a glasshouse build fed straight from the refinery.
return {
    type = "recipe",
    name = "glazed-panel-from-molten-glass",
    categories = { "crafting-with-fluid" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item",  name = "steel-plate",  amount = 1 },
        { type = "fluid", name = "molten-glass", amount = 75 },
    },
    results = {
        { type = "item", name = "glazed-panel", amount = 1 },
    },
    allow_productivity = true,
    -- Panels keep recycling into glass and steel.
    auto_recycle = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/glazed-panel.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-glass.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "z[lavablock]-f[glazed-panel]-b[molten-glass]",
}
