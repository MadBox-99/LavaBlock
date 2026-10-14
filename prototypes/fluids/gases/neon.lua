-- Neon, the rarest gas the air compressor can be bothered to pull out of
-- the air - five hundred times scarcer than argon. Its use is the one that made
-- it worth isolating at industrial scale: the fill gas of excimer lasers,
-- which run every deep-ultraviolet chip printer and are nearly all neon.
return {
    type = "fluid",
    name = "neon",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -246,                      -- Boiling point in C
    heat_capacity = "1kJ",
    -- Neon-sign red-orange, the colour the gas glows in a discharge.
    base_color = { r = 1.00, g = 0.27, b = 0.16 },
    flow_color = { r = 1.00, g = 0.55, b = 0.42 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/neon.png",
    icon_size = 64,
    order = "a[gas]-z[argon]-b[neon]",
    auto_barrel = true,
}
