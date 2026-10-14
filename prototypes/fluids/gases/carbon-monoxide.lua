-- The other half of reformed methane, with hydrogen. On its own it is a
-- poison and a fuel; with twice its volume of hydrogen over a cobalt
-- catalyst it builds back up into liquid hydrocarbons, which is how the
-- fuel plant makes light oil out of straw.
return {
    type = "fluid",
    name = "carbon-monoxide",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -192,                      -- Boiling point in C
    heat_capacity = "1kJ",
    -- Slate. The real gas is invisible, which is the danger in it; this is
    -- darker and bluer than carbon dioxide's flue brown.
    base_color = { r = 0.29, g = 0.33, b = 0.41 },
    flow_color = { r = 0.48, g = 0.52, b = 0.60 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/carbon-monoxide.png",
    icon_size = 64,
    order = "a[gas]-g[carbon-dioxide]-b[carbon-monoxide]",
    auto_barrel = true,
}
