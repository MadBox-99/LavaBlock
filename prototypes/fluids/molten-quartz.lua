-- Silica crystal melted down. Quartz melts at about 1700 degrees and does not
-- grow back into crystal when it cools - it sets as fused quartz, a glass -
-- so the one thing it is good for here is casting.
return {
    type = "fluid",
    name = "molten-quartz",
    subgroup = "fluid",
    default_temperature = 1700,
    max_temperature = 1700,
    heat_capacity = "0.8kJ",
    base_color = { r = 1.00, g = 0.78, b = 0.42 },
    flow_color = { r = 1.00, g = 0.90, b = 0.66 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-quartz.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-quartz]",
    -- No barrel, like Space Age's molten iron and copper: a melt at 1700
    -- degrees goes from the furnace to the mould by pipe or not at all.
    auto_barrel = false,
}
