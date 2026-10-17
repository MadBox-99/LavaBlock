-- What a lava pool breathes out, caught under a hood before it reaches the
-- air. Real fumarole gas is mostly steam, with the sulfur gases that give a
-- volcano its smell - sulfur dioxide and hydrogen sulfide - a few per cent
-- of it. Nothing takes it raw: the oil refinery splits it the way it
-- splits crude, and the split says what it is made of.
return {
    type = "fluid",
    name = "volcanic-gas",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = 0,
    heat_capacity = "0.2kJ",
    -- Rust brown, darker than carbon dioxide's grey-brown: the smoke over
    -- a vent, not a flue.
    base_color = { r = 0.65, g = 0.37, b = 0.24 },
    flow_color = { r = 0.80, g = 0.55, b = 0.42 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/volcanic-gas.png",
    icon_size = 64,
    order = "a[gas]-v[volcanic-gas]",
    auto_barrel = true,
}
