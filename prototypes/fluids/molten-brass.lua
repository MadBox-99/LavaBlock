-- Copper and zinc melted together, seven to three. Brass pours well and
-- casts clean, which is why so much of it was cast.
return {
    type = "fluid",
    name = "molten-brass",
    subgroup = "fluid",
    default_temperature = 930,
    max_temperature = 930,
    heat_capacity = "0.5kJ",
    -- Gold-yellow, brass's own colour.
    base_color = { r = 0.92, g = 0.75, b = 0.24 },
    flow_color = { r = 0.96, g = 0.88, b = 0.62 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-brass.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-brass]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
