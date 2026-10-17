-- Molten aluminium cast into plate, ten units a plate. Duralumin takes the
-- melt; titanium alloy and vanadium want the plate. An assembler with a
-- fluid input pours it, and so does Space Age's foundry, which casts
-- everything faster.
return {
    type = "recipe",
    name = "aluminium-casting",
    categories = { "crafting-with-fluid", "metallurgy" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "molten-aluminium", amount = 10 },
    },
    results = {
        { type = "item", name = "aluminium-plate", amount = 1 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/aluminium-plate.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-aluminium.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "a[smelting]-m[aluminium-plate]-b[casting]",
}
