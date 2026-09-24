-- Argon with a measured trace of oxygen, for growing crystal under.
--
-- Not pure argon, which is what an inert blanket would be for a metal. The
-- hearth grows silica, and silica is an oxide: blanket the melt in nothing
-- but argon and it comes back reduced. The oxygen is there to hold the melt
-- at the composition it is supposed to crystallise at, which is why this is
-- a blend and needs a machine to blend it.
return {
    type = "fluid",
    name = "shielding-gas",
    group = "chemistry",
    max_temperature = 2000,
    default_temperature = 15,
    gas_temperature = 20,
    heat_capacity = "22.4J",
    -- Argon's own pale blue-violet, pushed towards the crystals it grows.
    base_color = { r = 0.62, g = 0.52, b = 0.95 },
    flow_color = { r = 0.78, g = 0.70, b = 1.00 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/shielding-gas.png",
    icon_size = 64,
    order = "a[gas]-z[argon]-a[shielding-gas]",
    pressure_to_speed_ratio = 0.4,
    flow_to_energy_ratio = 0.59,
    auto_barrel = true,
}
