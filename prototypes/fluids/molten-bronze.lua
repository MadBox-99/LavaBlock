-- Copper with a tenth of tin. Bronze runs into every corner of a mould,
-- which made it the casting metal for three thousand years.
return {
    type = "fluid",
    name = "molten-bronze",
    subgroup = "fluid",
    default_temperature = 960,
    max_temperature = 960,
    heat_capacity = "0.5kJ",
    -- Orange-brown, redder than brass.
    base_color = { r = 0.80, g = 0.47, b = 0.22 },
    flow_color = { r = 0.90, g = 0.73, b = 0.61 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-bronze.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-bronze]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
