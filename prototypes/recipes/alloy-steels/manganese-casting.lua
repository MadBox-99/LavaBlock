-- Molten manganese poured into plate, ten units a plate. An assembler with a
-- fluid input pours it, and so does Space Age's foundry, which casts
-- everything faster.
return {
    type = "recipe",
    name = "manganese-casting",
    category = "crafting-with-fluid",
    additional_categories = { "metallurgy" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "molten-manganese", amount = 10 },
    },
    results = {
        { type = "item", name = "manganese-plate", amount = 1 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/manganese-plate.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-manganese.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "a[smelting]-k[manganese-plate]-b[casting]",
}
