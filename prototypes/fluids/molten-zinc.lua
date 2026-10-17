-- Zinc, melted out of sphalerite. It boils at 907 degrees, so it is caught
-- and kept just above its melting point at 420.
return {
    type = "fluid",
    name = "molten-zinc",
    subgroup = "fluid",
    default_temperature = 430,
    max_temperature = 430,
    heat_capacity = "0.5kJ",
    -- Pale steel blue, lighter than lead's.
    base_color = { r = 0.49, g = 0.61, b = 0.75 },
    flow_color = { r = 0.75, g = 0.80, b = 0.87 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-zinc.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-zinc]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
