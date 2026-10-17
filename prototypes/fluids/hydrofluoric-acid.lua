-- Hydrogen fluoride washed out of volcanic gas with water. Volcanoes vent
-- it with the sulfur gases, a fraction of a per cent, and it is the most
-- dangerous thing in the plume. It eats glass, which is why it is kept in
-- plastic, and it is the first step to uranium hexafluoride, the gas
-- uranium is enriched as.
return {
    type = "fluid",
    name = "hydrofluoric-acid",
    subgroup = "fluid",
    default_temperature = 15,
    heat_capacity = "0.2kJ",
    -- Pale mint, apart from hydrochloric acid's lime.
    base_color = { r = 0.59, g = 0.92, b = 0.78 },
    flow_color = { r = 0.80, g = 1.00, b = 0.90 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/hydrofluoric-acid.png",
    icon_size = 64,
    order = "a[fluid]-z[hydrofluoric-acid]",
    auto_barrel = true,
}
