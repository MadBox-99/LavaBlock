-- Propane, the larger part of what petroleum gas is. Liquefied under
-- pressure it dissolves the oil out of heavy residue and leaves the asphalt
-- behind, which is how lubricating oil is made.
return {
    type = "fluid",
    name = "propane",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -42,
    heat_capacity = "1kJ",
    -- Mauve, kept off ethylene's pink and methane's blue.
    base_color = { r = 0.86, g = 0.70, b = 0.86 },
    flow_color = { r = 0.93, g = 0.85, b = 0.93 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/propane.png",
    icon_size = 64,
    order = "a[gas]-z[propane]",
    auto_barrel = true,
}
