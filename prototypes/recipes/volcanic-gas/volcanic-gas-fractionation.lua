-- Volcanic gas split in the oil refinery, the one building on the island
-- with three outlets.
--
-- The split follows a real fumarole: mostly steam, and the two sulfur gases
-- a few per cent each. Seventy steam, fifteen of each sulfur gas from a
-- hundred. The steam comes out at 165 degrees, so it is worth something,
-- but not a power plant: 70 steam from 1000 lava and three buildings is
-- half of what lava cooling gets from 100 lava and one.
--
-- Equal parts of the two sulfur gases, where the Claus process wants two of
-- hydrogen sulfide to one of dioxide. That is on purpose: the half of the
-- sulfur dioxide that Claus cannot take is left for the contact process,
-- so a full line makes sulfur and sulfuric acid both, the way a real
-- sulfur plant does.
return {
    type = "recipe",
    name = "volcanic-gas-fractionation",
    categories = { "oil-processing" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "fluid", name = "volcanic-gas", amount = 100 },
    },
    results = {
        { type = "fluid", name = "sulfur-dioxide",   amount = 15 },
        { type = "fluid", name = "hydrogen-sulfide", amount = 15 },
        { type = "fluid", name = "steam",            amount = 70, temperature = 165 },
    },
    -- Splitting a gas into its parts makes nothing new, so productivity
    -- would only conjure more of them.
    allow_productivity = false,
    allow_quality = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/volcanic-gas.png",
            icon_size = 64,
            scale = 0.35,
            shift = { 0, -5 },
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/sulfur-dioxide.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -9, 8 },
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/hydrogen-sulfide.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 9, 8 },
        },
    },
    subgroup = "lava-block-volcanic-gas",
    order = "c[volcanic-gas]-b[volcanic-gas-fractionation]",
}
