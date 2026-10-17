-- Acetylene, given off by calcium carbide in water: the gas of carbide lamps
-- and of the oxy-acetylene torch, and with hydrochloric acid the vinyl
-- chloride PVC is made of.
return {
    type = "fluid",
    name = "acetylene",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -84,
    heat_capacity = "1kJ",
    -- Pale yellow, after the flame of a carbide lamp.
    base_color = { r = 0.94, g = 0.94, b = 0.70 },
    flow_color = { r = 0.97, g = 0.97, b = 0.85 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/acetylene.png",
    icon_size = 64,
    order = "a[gas]-z[acetylene]",
    auto_barrel = true,
}
