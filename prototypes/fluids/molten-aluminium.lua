-- Aluminium, tapped from the bottom of the reduction cell. It melts at only
-- 660 degrees but takes more electricity to win than any other common metal.
return {
    type = "fluid",
    name = "molten-aluminium",
    subgroup = "fluid",
    default_temperature = 670,
    max_temperature = 670,
    heat_capacity = "0.5kJ",
    -- Near white: molten aluminium does not glow at 670 degrees, it shines.
    base_color = { r = 0.86, g = 0.86, b = 0.88 },
    flow_color = { r = 0.93, g = 0.93, b = 0.94 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-aluminium.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-aluminium]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
