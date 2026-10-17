-- Krypton with a little fluorine. A discharge through it forms krypton
-- fluoride for a few nanoseconds - an excited dimer, an excimer - which
-- lases at 248 nanometres as it falls apart.
return {
    type = "fluid",
    name = "excimer-gas",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -150,
    heat_capacity = "1kJ",
    -- Lilac: krypton's green and fluorine's yellow gone to the colour of the
    -- ultraviolet it makes.
    base_color = { r = 0.70, g = 0.62, b = 0.92 },
    flow_color = { r = 0.85, g = 0.81, b = 0.96 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/excimer-gas.png",
    icon_size = 64,
    order = "a[gas]-z[excimer-gas]",
    auto_barrel = true,
}
