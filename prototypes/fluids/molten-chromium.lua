-- Chromium, the hardest of the island's metals to melt: 1907 degrees, a
-- temperature only the arc furnace reaches.
return {
    type = "fluid",
    name = "molten-chromium",
    subgroup = "fluid",
    default_temperature = 1910,
    max_temperature = 1910,
    heat_capacity = "0.5kJ",
    -- Ice blue-white, the hottest-looking melt, because it is.
    base_color = { r = 0.47, g = 0.69, b = 0.96 },
    flow_color = { r = 0.74, g = 0.84, b = 0.98 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-chromium.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-chromium]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
