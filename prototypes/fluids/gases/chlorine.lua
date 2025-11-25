local chlorine = {
    type = "fluid",
    name = "chlorine",
    subgroup = "gases",
    max_temperature = 416.9,                    -- Critical temperature in K
    default_temperature = -101.5,               -- Melting point in °C
    gas_temperature = -34.04,                   -- Boiling point in °C
    heat_capacity = "33.949J",                  -- Molar heat capacity
    base_color = { r = 0.8, g = 1.0, b = 0.5 }, -- Pale yellow-green
    flow_color = { r = 0.9, g = 1.0, b = 0.7 }, -- Lighter yellow-green
    icon_size = 64,
    icon = "__LavaBlock__/graphics/icons/gas/chlorine.png",
    order = "a[gas]-z[chlorine]",
    pressure_to_speed_ratio = 0.4,
    flow_to_energy_ratio = 0.59,
    auto_barrel = true,
}
data:extend { chlorine }