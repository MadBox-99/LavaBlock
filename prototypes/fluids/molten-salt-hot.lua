-- Molten salt as it leaves the magma turbine, and as salt melting first
-- makes it: 565 degrees, too hot to feed back into a reactor until it has
-- been cooled.
return {
    type = "fluid",
    name = "molten-salt-hot",
    subgroup = "fluid",
    default_temperature = 565,
    heat_capacity = "1.5kJ",
    -- Cherry red: hot enough to glow, and a shade apart from lava's orange
    -- and molten quartz's amber.
    base_color = { r = 0.55, g = 0.10, b = 0.06 },
    flow_color = { r = 0.95, g = 0.30, b = 0.16 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-salt-hot.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-salt]-b[hot]",
    auto_barrel = false,
}
