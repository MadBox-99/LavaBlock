-- Flue gas from burning coal, taken for its carbon dioxide. It is the
-- carbonate in limestone: bubbled through the calcium solution, it brings
-- the calcium back out as rock.
return {
    type = "fluid",
    name = "carbon-dioxide",
    group = "chemistry",
    default_temperature = 15,
    max_temperature = 31,                        -- Critical temperature in C
    gas_temperature = -78.5,                     -- Sublimation point in C
    heat_capacity = "37J",
    base_color = { r = 0.36, g = 0.33, b = 0.30 },
    flow_color = { r = 0.52, g = 0.49, b = 0.46 },
    icon_size = 64,
    icon = "__LavaBlock-graphics__/graphics/icons/gas/carbon-dioxide.png",
    order = "a[gas]-g[carbon-dioxide]",
    pressure_to_speed_ratio = 0.4,
    flow_to_energy_ratio = 0.59,
    auto_barrel = true,
}
