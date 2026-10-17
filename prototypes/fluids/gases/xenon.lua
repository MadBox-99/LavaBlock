-- Xenon, the rarest gas in the air, one part in eleven million. A flash tube
-- filled with it gives the white light that pumps a ruby laser.
return {
    type = "fluid",
    name = "xenon",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -108,
    heat_capacity = "1kJ",
    -- Blue-white, the colour of a xenon flash.
    base_color = { r = 0.62, g = 0.72, b = 1.00 },
    flow_color = { r = 0.81, g = 0.86, b = 1.00 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/xenon.png",
    icon_size = 64,
    order = "a[gas]-z[xenon]",
    auto_barrel = true,
}
