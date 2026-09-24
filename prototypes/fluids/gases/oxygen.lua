return {
    type = "fluid",
    name = "oxygen",
    group = "chemistry",
    max_temperature = 154.6,                     -- Critical temperature in K
    default_temperature = 15,
    gas_temperature = -182.96,                   -- Boiling point in C
    heat_capacity = "29.4J",
    base_color = { r = 0.30, g = 0.64, b = 1.00 },
    flow_color = { r = 0.48, g = 0.78, b = 1.00 },
    icon_size = 64,
    icon = "__LavaBlock-graphics__/graphics/icons/gas/oxygen.png",
    order = "a[gas]-c[oxygen]",
    pressure_to_speed_ratio = 0.4,
    flow_to_energy_ratio = 0.59,
    auto_barrel = true,
}
