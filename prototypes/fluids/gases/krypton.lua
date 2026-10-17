-- Krypton, a part in a million of the air, distilled out of liquid air with
-- xenon. Excited with fluorine it lases in the deep ultraviolet - the light
-- most of the world's chips are still printed with.
return {
    type = "fluid",
    name = "krypton",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -153,
    heat_capacity = "1kJ",
    -- Pale green: the colour of a krypton discharge, between neon's red and
    -- argon's violet.
    base_color = { r = 0.62, g = 0.86, b = 0.66 },
    flow_color = { r = 0.81, g = 0.93, b = 0.83 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/krypton.png",
    icon_size = 64,
    order = "a[gas]-z[krypton]",
    auto_barrel = true,
}
