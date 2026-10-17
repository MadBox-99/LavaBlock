-- Molten iron with the carbon burnt out of it by a lance of oxygen: steel,
-- still liquid at 1600 degrees. It is how almost all steel has been made
-- since the 1950s, and it never passes through an iron plate on the way.
return {
    type = "fluid",
    name = "molten-steel",
    subgroup = "fluid",
    default_temperature = 1600,
    max_temperature = 1600,
    heat_capacity = "0.5kJ",
    -- Yellow-white: hotter than molten iron's orange, and a shade apart from
    -- molten sulfur's gold.
    base_color = { r = 1.00, g = 0.88, b = 0.16 },
    flow_color = { r = 1.00, g = 0.96, b = 0.55 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-steel.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-steel]",
    auto_barrel = false,
}
