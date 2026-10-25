-- Concrete bound with sulfur instead of cement: hot sulfur stirred through
-- gravel, set in the mould as it cools. It is real, and it is what you
-- build with where water is short - it needs none, and it cures in hours
-- instead of weeks.
--
-- Ten molten sulfur and five gravel make 16 concrete, against vanilla's
-- five brick, iron ore and 100 water for ten, and lime concrete's 16 from a
-- seven-step chain. Ten units is two sulfur's worth, so it spends the
-- line's product on a bulk material; that is its price.
--
-- Real sulfur concrete is a fifth sulfur and the rest aggregate. Twenty
-- units for ten concrete was nearly all binder, and made concrete three
-- quarters dearer than the vanilla recipe; this is about a tenth cheaper.
return {
    type = "recipe",
    name = "sulfur-concrete",
    categories = { "crafting-with-fluid" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "basalt-gravel", amount = 5 },
        { type = "fluid", name = "molten-sulfur", amount = 10 },
    },
    results = {
        { type = "item", name = "concrete", amount = 16 },
    },
    allow_productivity = true,
    -- Concrete keeps recycling into brick and iron ore.
    auto_recycle = false,
    icons = {
        { icon = "__base__/graphics/icons/concrete.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-sulfur.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "terrain",
    order = "b[concrete]-a[plain]-s[sulfur]",
}
