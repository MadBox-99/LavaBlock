-- The magma line's coolant on its way into the reactor. "Cold" as a solar
-- tower's cold tank is cold: 290 degrees, still well molten.
--
-- It goes round and round. The reactor turns it into plasma, the turbine
-- lets it back down to hot salt, and a chemical plant cools that with water
-- to this again. Nothing is used up but the water, so a loop is filled once
-- from salt melting and topped up after that.
return {
    type = "fluid",
    name = "molten-salt-cold",
    subgroup = "fluid",
    default_temperature = 290,
    max_temperature = 565,
    heat_capacity = "1.5kJ",
    -- Pale straw, which is what a nitrate melt looks like, and clear of the
    -- milky calcium solution it is made next to.
    base_color = { r = 0.62, g = 0.54, b = 0.26 },
    flow_color = { r = 0.90, g = 0.84, b = 0.56 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-salt-cold.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-salt]-a[cold]",
    auto_barrel = false,
}
