-- Aluminium with a tenth each of copper and magnesium, melted together.
return {
    type = "fluid",
    name = "molten-duralumin",
    subgroup = "fluid",
    default_temperature = 650,
    max_temperature = 650,
    heat_capacity = "0.5kJ",
    -- Pale blue, aluminium's white with a cast to tell the two apart.
    base_color = { r = 0.71, g = 0.78, b = 0.92 },
    flow_color = { r = 0.85, g = 0.89, b = 0.96 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-duralumin.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-duralumin]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
