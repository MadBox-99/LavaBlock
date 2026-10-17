-- Molten stainless steel cast into plate, ten units a plate. An assembler
-- with a fluid input pours it, and so does Space Age's foundry, which casts
-- everything faster.
return {
    type = "recipe",
    name = "stainless-steel-casting",
    categories = { "crafting-with-fluid", "metallurgy" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "molten-stainless-steel", amount = 10 },
    },
    results = {
        { type = "item", name = "stainless-steel-plate", amount = 1 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/stainless-steel-plate.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-stainless-steel.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "b[alloy]-a[stainless-steel-plate]-b[casting]",
}
