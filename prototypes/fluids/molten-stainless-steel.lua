-- Steel melted with chromium and nickel into stainless steel, at a white
-- heat.
return {
    type = "fluid",
    name = "molten-stainless-steel",
    subgroup = "fluid",
    default_temperature = 1460,
    max_temperature = 1460,
    heat_capacity = "0.5kJ",
    -- Pale orange, between molten steel's yellow and molten iron's orange.
    base_color = { r = 1.00, g = 0.80, b = 0.47 },
    flow_color = { r = 1.00, g = 0.90, b = 0.73 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-stainless-steel.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-stainless-steel]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
