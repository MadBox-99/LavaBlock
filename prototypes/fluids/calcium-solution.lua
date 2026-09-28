-- What water carries away from slag: its calcium, dissolved. Milky, and
-- nothing but the carbonation step takes it - add carbon dioxide and the
-- calcium comes back out of it as limestone.
return {
    type = "fluid",
    name = "calcium-solution",
    subgroup = "fluid",
    default_temperature = 15,
    max_temperature = 100,
    heat_capacity = "0.2kJ",
    base_color = { r = 0.78, g = 0.78, b = 0.72 },
    flow_color = { r = 0.90, g = 0.90, b = 0.86 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/calcium-solution.png",
    icon_size = 64,
    order = "a[fluid]-z[calcium-solution]",
    auto_barrel = true,
}
