-- Silicon reduced out of silica with coal, liquid at 1420 degrees. Not
-- molten quartz: quartz is the oxide, melted as it is, and sets as glass;
-- this is the element, and a seed dipped into it and drawn slowly back out
-- grows a single crystal that is sawn into wafers.
return {
    type = "fluid",
    name = "molten-silicon",
    subgroup = "fluid",
    default_temperature = 1420,
    max_temperature = 1420,
    heat_capacity = "1kJ",
    -- Slate blue-grey. Liquid silicon is a metal to look at, a mirror with a
    -- cold cast to it, unlike every other melt on the island.
    base_color = { r = 0.35, g = 0.39, b = 0.53 },
    flow_color = { r = 0.60, g = 0.64, b = 0.76 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-silicon.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-silicon]",
    auto_barrel = false,
}
