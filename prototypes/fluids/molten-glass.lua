-- Soda-lime glass, molten: silica with quicklime stirred in to bring the
-- melting point down from quartz's 1700 degrees to about 1100. Nearly
-- every window and bottle is this glass. Molten quartz next door is the
-- pure melt, and the lens maker's; this is the cheap one, and it is poured
-- by the tonne.
return {
    type = "fluid",
    name = "molten-glass",
    subgroup = "fluid",
    default_temperature = 1100,
    max_temperature = 1100,
    heat_capacity = "0.8kJ",
    -- Furnace orange, redder than molten quartz's amber because it runs
    -- six hundred degrees cooler.
    base_color = { r = 1.00, g = 0.47, b = 0.16 },
    flow_color = { r = 1.00, g = 0.70, b = 0.40 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-glass.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-glass]",
    auto_barrel = false,
}
