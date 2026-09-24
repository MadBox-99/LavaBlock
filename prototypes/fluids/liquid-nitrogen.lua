return {
    type = "fluid",
    name = "liquid-nitrogen",
    subgroup = "fluid",
    default_temperature = -196,
    max_temperature = -196,
    heat_capacity = "0.2kJ",
    base_color = { r = 0.5, g = 0.5, b = 1.0 },
    flow_color = { r = 0.7, g = 0.7, b = 1.0 },
    -- Rendered rather than drawn, at 64 like every other fluid here.
    -- The 32 px one it replaces was upscaled by the game everywhere
    -- an icon is shown larger than an inventory slot.
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/liquid-nitrogen.png",
    icon_size = 64,
    order = "a[fluid]-z[liquid_nitrogen]",
    pressure_to_speed_ratio = 0.4,
    flow_to_energy_ratio = 0.59,
    auto_barrel = true,
}