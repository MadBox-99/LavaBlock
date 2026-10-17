-- Steel melted with a tenth of manganese: Hadfield steel, before it is cast.
return {
    type = "fluid",
    name = "molten-manganese-steel",
    subgroup = "fluid",
    default_temperature = 1420,
    max_temperature = 1420,
    heat_capacity = "0.5kJ",
    -- Deep orange.
    base_color = { r = 0.90, g = 0.47, b = 0.20 },
    flow_color = { r = 0.95, g = 0.73, b = 0.60 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-manganese-steel.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-manganese-steel]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
