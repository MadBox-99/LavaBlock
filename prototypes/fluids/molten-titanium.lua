-- Titanium, reduced out of its tetrachloride by sodium and melted under the
-- arcs at 1668 degrees.
return {
    type = "fluid",
    name = "molten-titanium",
    subgroup = "fluid",
    default_temperature = 1680,
    max_temperature = 1680,
    heat_capacity = "0.5kJ",
    -- Lilac-white, after the colours titanium takes when it is heated in air.
    base_color = { r = 0.80, g = 0.76, b = 0.92 },
    flow_color = { r = 0.90, g = 0.88, b = 0.96 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-titanium.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-titanium]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
