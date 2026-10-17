-- Molten solder cast into bar, ten units a bar. Solder is sold as bar for
-- the dip pots that solder boards in one pass. An assembler with a fluid
-- input pours it, and so does Space Age's foundry, which casts everything
-- faster.
return {
    type = "recipe",
    name = "solder",
    category = "crafting-with-fluid",
    additional_categories = { "metallurgy" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "molten-solder", amount = 10 },
    },
    results = {
        { type = "item", name = "solder", amount = 1 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/solder.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-solder.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "b[alloy]-f[solder]-b[casting]",
}
