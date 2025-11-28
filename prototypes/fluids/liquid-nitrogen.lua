local liquid_nitrogen = {
    type = "fluid",
    name = "liquid-nitrogen",
    subgroup = "fluid",
    default_temperature = -196,
    max_temperature = -196,
    heat_capacity = "0.2kJ",
    base_color = { r = 0.5, g = 0.5, b = 1.0 },
    flow_color = { r = 0.7, g = 0.7, b = 1.0 },
    icon = "__LavaBlock__/graphics/icons/liquid_nitrogen.png",
    icon_size = 32,
    order = "a[fluid]-z[liquid_nitrogen]",
    pressure_to_speed_ratio = 0.4,
    flow_to_energy_ratio = 0.59,
    auto_barrel = true,
}
data:extend { liquid_nitrogen }