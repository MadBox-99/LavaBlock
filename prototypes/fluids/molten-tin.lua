-- Tin reduced out of cassiterite and kept liquid. It melts at 232
-- degrees, the lowest of any metal on the island, and it is dense enough
-- that molten glass floats on it - the whole idea of float glass, and the
-- reason a pool of it sits under every window ever made since the 1960s.
return {
    type = "fluid",
    name = "molten-tin",
    subgroup = "fluid",
    default_temperature = 300,
    heat_capacity = "0.25kJ",
    -- Mirror grey, a shade darker than calcium solution's white so the two
    -- are not mistaken in a pipe.
    base_color = { r = 0.59, g = 0.61, b = 0.65 },
    flow_color = { r = 0.80, g = 0.82, b = 0.86 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-tin.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-tin]",
    auto_barrel = false,
}
