-- Ethanol. One fluid with two routes to it - fermented and distilled out of
-- biomass, or made from petroleum gas and steam - because it is one
-- molecule however it was made. "Bio-ethanol" is where it came from, not
-- what it is, and two fluids that are the same thing would only split the
-- pipes for no reason.
--
-- It carries a fuel value so that anything which burns fluid can burn it.
-- 500 kJ a unit puts 200 of it at exactly one rocket fuel, which is the
-- number the rocket fuel recipe is balanced against.
return {
    type = "fluid",
    name = "ethanol",
    subgroup = "fluid",
    order = "a[fluid]-z[ethanol]",
    default_temperature = 15,
    max_temperature = 78,               -- boils at 78 C
    heat_capacity = "2.4kJ",
    -- Pale gold. Ethanol is clear, and a clear fluid in Factorio is water;
    -- the colour is the grain it came from, and it stays apart from water's
    -- teal, the air family's greys and oxygen's blue.
    base_color = { r = 0.78, g = 0.66, b = 0.30 },
    flow_color = { r = 0.95, g = 0.88, b = 0.60 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/ethanol.png",
    icon_size = 64,
    fuel_value = "500kJ",
    -- It burns cleaner than oil, which is most of why anyone makes it.
    emissions_multiplier = 0.8,
    auto_barrel = true,
}
