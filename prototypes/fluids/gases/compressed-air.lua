local compressed_air = {
    type = "fluid",
    name = "compressed-air",
    group = "chemistry",
    max_temperature = 132.5,                    -- Critical temperature in K
    default_temperature = -210,                 -- Low temperature
    gas_temperature = -194.35,                  -- Boiling point of air in °C
    heat_capacity = "29.19J",                   -- Molar heat capacity
    base_color = { r = 0.7, g = 0.8, b = 0.9 }, -- Light blue-gray
    flow_color = { r = 0.8, g = 0.9, b = 1.0 }, -- Lighter blue-white
    icon_size = 64,
    icon = "__LavaBlock__/graphics/icons/gas/air.png",
    order = "a[gas]-a[compressed-air]",
    pressure_to_speed_ratio = 0.4,
    flow_to_energy_ratio = 0.59,
    auto_barrel = true,
}
data:extend { compressed_air }