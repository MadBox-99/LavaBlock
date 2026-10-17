-- Molten superalloy cast into plate, ten units a plate. An assembler with a
-- fluid input pours it, and so does Space Age's foundry, which casts
-- everything faster.
return {
    type = "recipe",
    name = "superalloy-casting",
    categories = { "crafting-with-fluid", "metallurgy" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "molten-superalloy", amount = 10 },
    },
    results = {
        { type = "item", name = "superalloy-plate", amount = 1 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/superalloy-plate.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-superalloy.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "b[alloy]-i[superalloy-plate]-b[casting]",
}
