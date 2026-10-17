-- Molten nichrome cast into rod and drawn down into wire, ten units a coil.
-- An assembler with a fluid input pours it, and so does Space Age's foundry,
-- which casts everything faster.
return {
    type = "recipe",
    name = "nichrome-wire",
    categories = { "crafting-with-fluid", "metallurgy" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "molten-nichrome", amount = 10 },
    },
    results = {
        { type = "item", name = "nichrome-wire", amount = 1 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/nichrome-wire.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-nichrome.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "b[alloy]-c[nichrome-wire]-b[casting]",
}
