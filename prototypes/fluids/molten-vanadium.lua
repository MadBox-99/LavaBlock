-- Vanadium, reduced out of magnetite with aluminium.
return {
    type = "fluid",
    name = "molten-vanadium",
    subgroup = "fluid",
    default_temperature = 1920,
    max_temperature = 1920,
    heat_capacity = "0.5kJ",
    -- Sea green, after the colours of vanadium's compounds - no other melt is
    -- green.
    base_color = { r = 0.55, g = 0.75, b = 0.72 },
    flow_color = { r = 0.78, g = 0.88, b = 0.86 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-vanadium.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-vanadium]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
