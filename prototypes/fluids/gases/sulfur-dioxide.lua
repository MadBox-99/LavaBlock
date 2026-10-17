-- The sharp-smelling half of a volcano's sulfur, split out of volcanic gas.
-- Two things take it: the Claus process, which burns it against hydrogen
-- sulfide down to liquid sulfur, and the contact process, which oxidises it
-- straight to sulfuric acid. Industry makes nearly all of its sulfuric
-- acid the second way.
return {
    type = "fluid",
    name = "sulfur-dioxide",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -10,                       -- Boiling point in C
    heat_capacity = "0.6kJ",
    -- Pale yellow. The real gas has no colour; this is the colour of what
    -- it is made from.
    base_color = { r = 0.92, g = 0.84, b = 0.39 },
    flow_color = { r = 0.97, g = 0.93, b = 0.62 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/sulfur-dioxide.png",
    icon_size = 64,
    order = "a[gas]-v[volcanic-gas]-a[sulfur-dioxide]",
    auto_barrel = true,
}
