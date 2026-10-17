-- Helium with a tenth of neon: the fill of a helium-neon laser tube. The
-- helium carries the energy of the discharge and hands it to the neon, which
-- lases.
return {
    type = "fluid",
    name = "helium-neon",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -250,
    heat_capacity = "1kJ",
    -- Salmon: neon's red let down with helium's gold.
    base_color = { r = 1.00, g = 0.55, b = 0.45 },
    flow_color = { r = 1.00, g = 0.78, b = 0.72 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/helium-neon.png",
    icon_size = 64,
    order = "a[gas]-z[helium-neon]",
    auto_barrel = true,
}
