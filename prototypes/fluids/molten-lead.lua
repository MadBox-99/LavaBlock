-- Lead, melted out of galena. It melts at 327 degrees, low enough that a
-- lead pipe can be poured in a sand mould, and it is what every battery
-- plate is cast from.
return {
    type = "fluid",
    name = "molten-lead",
    subgroup = "fluid",
    default_temperature = 340,
    max_temperature = 340,
    heat_capacity = "0.5kJ",
    -- Dark blue-grey, the colour of the metal, and the darkest melt there is.
    base_color = { r = 0.37, g = 0.39, b = 0.47 },
    flow_color = { r = 0.69, g = 0.70, b = 0.73 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-lead.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-lead]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
