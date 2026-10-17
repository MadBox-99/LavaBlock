-- Ethane, the smaller part of petroleum gas. Cracked with steam it gives
-- ethylene, the building block of half the plastic in the world.
return {
    type = "fluid",
    name = "ethane",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -89,
    heat_capacity = "1kJ",
    -- Pale cyan.
    base_color = { r = 0.70, g = 0.86, b = 0.94 },
    flow_color = { r = 0.85, g = 0.93, b = 0.97 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/ethane.png",
    icon_size = 64,
    order = "a[gas]-z[ethane]",
    auto_barrel = true,
}
