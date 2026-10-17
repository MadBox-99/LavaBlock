-- Biogas, near enough: what straw and algae give off when they rot with no
-- air, cleaned down to the methane. Reformed with steam it is hydrogen and
-- carbon monoxide; thinned into hydrogen over a crystal seed it lays down
-- diamond.
return {
    type = "fluid",
    name = "methane",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -162,                      -- Boiling point in C
    heat_capacity = "2.2kJ",
    -- Flame orange: the gas has no colour, and this is the colour it burns
    -- in a pipe flare.
    base_color = { r = 0.96, g = 0.59, b = 0.20 },
    flow_color = { r = 1.00, g = 0.76, b = 0.45 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/methane.png",
    icon_size = 64,
    order = "a[gas]-m[methane]",
    auto_barrel = true,
}
