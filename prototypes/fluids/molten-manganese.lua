-- Manganese, reduced out of slag. It goes into manganese steel a tenth at a
-- time.
return {
    type = "fluid",
    name = "molten-manganese",
    subgroup = "fluid",
    default_temperature = 1250,
    max_temperature = 1250,
    heat_capacity = "0.5kJ",
    -- Dusky pink, after the pink of its ores; no other melt is pink.
    base_color = { r = 0.78, g = 0.55, b = 0.59 },
    flow_color = { r = 0.89, g = 0.78, b = 0.79 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-manganese.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-manganese]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
