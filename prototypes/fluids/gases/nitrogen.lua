-- Nitrogen gas, pulled out of compressed air by a molecular sieve. Four
-- fifths of the air is nitrogen and almost nothing makes it react, which
-- is what makes it hard to use: here it takes an electric arc and oxygen
-- to turn it into nitric acid.
--
-- Not liquid nitrogen, which the air cooler makes for quenching; the two
-- are kept apart because nothing on the island boils one into the other.
return {
    type = "fluid",
    name = "nitrogen",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -196,                      -- Boiling point in C
    heat_capacity = "1kJ",
    -- Teal, between oxygen's blue and the greens of the acid gases.
    base_color = { r = 0.16, g = 0.69, b = 0.65 },
    flow_color = { r = 0.45, g = 0.85, b = 0.80 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/nitrogen.png",
    icon_size = 64,
    order = "a[gas]-b[nitrogen]",
    auto_barrel = true,
}
