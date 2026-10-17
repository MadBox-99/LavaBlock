-- Nitrous oxide, made by heating ammonium nitrate - here ammonia and nitric
-- acid. It carries a third more oxygen than air and gives it up when it is
-- heated, which makes it the oxidiser of a hybrid rocket motor.
return {
    type = "fluid",
    name = "nitrous-oxide",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -88,
    heat_capacity = "1kJ",
    -- Cool white-grey: a colourless gas, kept apart from oxygen's blue.
    base_color = { r = 0.78, g = 0.80, b = 0.86 },
    flow_color = { r = 0.89, g = 0.90, b = 0.93 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/nitrous-oxide.png",
    icon_size = 64,
    order = "a[gas]-z[nitrous-oxide]",
    auto_barrel = true,
}
