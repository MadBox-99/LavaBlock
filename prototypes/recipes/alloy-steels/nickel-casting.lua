-- Molten nickel poured into plate, ten units a plate. Most nickel never
-- needs it: the alloys take the melt straight from the tap. An assembler
-- with a fluid input pours it, and so does Space Age's foundry, which casts
-- everything faster.
return {
    type = "recipe",
    name = "nickel-casting",
    category = "crafting-with-fluid",
    additional_categories = { "metallurgy" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "molten-nickel", amount = 10 },
    },
    results = {
        { type = "item", name = "nickel-plate", amount = 1 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/nickel-plate.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-nickel.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "a[smelting]-g[nickel-plate]-b[casting]",
}
