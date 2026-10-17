-- Tin and lead, three to two. It melts at under two hundred degrees - the
-- whole point of solder.
return {
    type = "fluid",
    name = "molten-solder",
    subgroup = "fluid",
    default_temperature = 200,
    max_temperature = 200,
    heat_capacity = "0.5kJ",
    -- Mid grey: too cool to glow, between tin's mirror and lead's blue.
    base_color = { r = 0.67, g = 0.67, b = 0.69 },
    flow_color = { r = 0.83, g = 0.83, b = 0.84 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-solder.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-solder]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
