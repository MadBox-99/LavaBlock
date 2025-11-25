local air = {
    type = "fluid",
    name = "air",
    subgroup = "gases",
    max_temperature = 132.5,                     -- Critical temperature in K (average for air)
    default_temperature = 15,                    -- Standard temperature in °C
    gas_temperature = -194.35,                   -- Boiling point in °C (average for air)
    heat_capacity = "29.1J",                     -- Molar heat capacity
    base_color = { r = 0.8, g = 0.9, b = 1.0 },  -- Light blue-white
    flow_color = { r = 0.9, g = 0.95, b = 1.0 }, -- Very pale blue
    icon_size = 64,
    icon = "__LavaBlock__/graphics/icons/gas/air.png",
    order = "a[gas]-a[air]",
    pressure_to_speed_ratio = 0.4,
    flow_to_energy_ratio = 0.59,
    auto_barrel = true,
}
data:extend { air }