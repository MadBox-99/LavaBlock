-- Nickel and chromium four to one, before it is drawn into wire.
return {
    type = "fluid",
    name = "molten-nichrome",
    subgroup = "fluid",
    default_temperature = 1410,
    max_temperature = 1410,
    heat_capacity = "0.5kJ",
    -- Red-orange, the colour every nichrome element glows.
    base_color = { r = 1.00, g = 0.35, b = 0.16 },
    flow_color = { r = 1.00, g = 0.68, b = 0.58 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-nichrome.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-nichrome]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
