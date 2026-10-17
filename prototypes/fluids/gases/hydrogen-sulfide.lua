-- The rotten-egg half of a volcano's sulfur, split out of volcanic gas.
-- Its one use is the Claus process: two parts of it against one of sulfur
-- dioxide burn down to liquid sulfur and water. That is how refineries get
-- rid of it, and it is where most of the world's sulfur comes from.
return {
    type = "fluid",
    name = "hydrogen-sulfide",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -60,                       -- Boiling point in C
    heat_capacity = "1kJ",
    -- Olive, a shade apart from sulfur dioxide's yellow and chlorine's green.
    base_color = { r = 0.59, g = 0.63, b = 0.20 },
    flow_color = { r = 0.75, g = 0.80, b = 0.40 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/hydrogen-sulfide.png",
    icon_size = 64,
    order = "a[gas]-v[volcanic-gas]-b[hydrogen-sulfide]",
    auto_barrel = true,
}
