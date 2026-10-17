-- Magnesium, won from brine by electrolysis. Liquid it must be kept from the
-- air, which it burns in with a white flame.
return {
    type = "fluid",
    name = "molten-magnesium",
    subgroup = "fluid",
    default_temperature = 660,
    max_temperature = 660,
    heat_capacity = "0.5kJ",
    -- Cream, a warmer white than aluminium's.
    base_color = { r = 0.88, g = 0.86, b = 0.59 },
    flow_color = { r = 0.94, g = 0.93, b = 0.79 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-magnesium.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-magnesium]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
