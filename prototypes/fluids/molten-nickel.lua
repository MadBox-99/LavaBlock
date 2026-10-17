-- Nickel, smelted out of pentlandite and kept liquid at a white heat. Most
-- of it goes straight into stainless steel and nichrome without ever being
-- cast.
return {
    type = "fluid",
    name = "molten-nickel",
    subgroup = "fluid",
    default_temperature = 1460,
    max_temperature = 1460,
    heat_capacity = "0.5kJ",
    -- Pale gold, the white heat of a melt at nearly 1500 degrees.
    base_color = { r = 0.84, g = 0.78, b = 0.55 },
    flow_color = { r = 0.92, g = 0.89, b = 0.78 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-nickel.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-nickel]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
