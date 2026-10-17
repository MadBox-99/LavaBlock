-- Sodium, won from molten salt by a current, as the Downs cell does it. It
-- melts at 98 degrees and is kept liquid and away from air and water, which
-- it burns in; its one job here is to tear the chlorine off titanium
-- tetrachloride.
return {
    type = "fluid",
    name = "molten-sodium",
    subgroup = "fluid",
    default_temperature = 120,
    max_temperature = 120,
    heat_capacity = "0.5kJ",
    -- Silver, faintly blue: a liquid metal that does not glow.
    base_color = { r = 0.80, g = 0.82, b = 0.85 },
    flow_color = { r = 0.90, g = 0.91, b = 0.93 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-sodium.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-sodium]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
