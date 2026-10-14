-- Uranium hexafluoride: the one uranium compound that is a gas at a
-- temperature a pipe can hold, a little above 56 degrees. That is the
-- whole reason it exists - a gas can be spun in a centrifuge, so every
-- enrichment plant in the world turns its uranium into this first.
return {
    type = "fluid",
    name = "uranium-hexafluoride",
    subgroup = "fluid",
    default_temperature = 60,
    gas_temperature = 56,                        -- Sublimation point in C
    heat_capacity = "0.5kJ",
    -- Uranium green. The real gas is colourless and its crystals white;
    -- this is the colour everything uranium wears in Factorio.
    base_color = { r = 0.16, g = 0.90, b = 0.47 },
    flow_color = { r = 0.50, g = 1.00, b = 0.70 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/uranium-hexafluoride.png",
    icon_size = 64,
    order = "a[gas]-u[uranium-hexafluoride]",
    auto_barrel = true,
}
