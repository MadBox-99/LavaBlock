-- Volcanic gas washed through water, which takes the hydrogen fluoride out
-- of it as acid. A scrubber on a real smelter stack does the same, to keep
-- the fluoride out of the grass.
--
-- 100 volcanic gas and 50 water for 20 hydrofluoric acid, two seconds. The
-- gas is used up: this is a second use for it beside fractionation, not a
-- pass it goes through on the way. A hundred volcanic gas is two degassing
-- crafts, 1000 lava, so the 40 acid of an enrichment run is four.
return {
    type = "recipe",
    name = "fluoride-scrubbing",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "volcanic-gas", amount = 100 },
        { type = "fluid", name = "water",        amount = 50 },
    },
    results = {
        { type = "fluid", name = "hydrofluoric-acid", amount = 20 },
    },
    allow_productivity = false,
    allow_quality = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/hydrofluoric-acid.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/volcanic-gas.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-volcanic-gas",
    order = "c[volcanic-gas]-f[fluoride-scrubbing]",
    crafting_machine_tint = {
        primary = { r = 0.59, g = 0.92, b = 0.78, a = 1.0 },
        secondary = { r = 0.65, g = 0.37, b = 0.24, a = 1.0 },
    },
}
