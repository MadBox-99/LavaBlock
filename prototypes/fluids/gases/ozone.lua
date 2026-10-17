-- Three oxygen atoms instead of two, made by an electric discharge through
-- oxygen. It oxidises almost anything it touches and leaves nothing behind
-- but oxygen, which makes it the cleanest thing to wash a silicon wafer
-- with.
return {
    type = "fluid",
    name = "ozone",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -112,
    heat_capacity = "1kJ",
    -- Pale blue: ozone is the one blue gas.
    base_color = { r = 0.55, g = 0.70, b = 0.95 },
    flow_color = { r = 0.78, g = 0.85, b = 0.97 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/ozone.png",
    icon_size = 64,
    order = "a[gas]-z[ozone]",
    auto_barrel = true,
}
