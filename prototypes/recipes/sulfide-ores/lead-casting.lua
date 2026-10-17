-- Molten lead poured into plate. Ten units a plate, as every melt on the
-- island casts. An assembler with a fluid input pours it, and so does Space
-- Age's foundry, which casts everything faster.
return {
    type = "recipe",
    name = "lead-casting",
    categories = { "crafting-with-fluid", "metallurgy" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "molten-lead", amount = 10 },
    },
    results = {
        { type = "item", name = "lead-plate", amount = 1 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/lead-plate.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-lead.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "a[smelting]-e[lead-plate]-b[casting]",
}
