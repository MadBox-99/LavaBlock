-- Nickel, chromium, cobalt, aluminium and yttrium melted together into a
-- superalloy, before it is cast.
return {
    type = "fluid",
    name = "molten-superalloy",
    subgroup = "fluid",
    default_temperature = 1400,
    max_temperature = 1400,
    heat_capacity = "0.5kJ",
    -- Copper-orange, the colour superalloy blades come out of a furnace.
    base_color = { r = 0.95, g = 0.62, b = 0.40 },
    flow_color = { r = 0.97, g = 0.81, b = 0.70 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-superalloy.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-superalloy]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
