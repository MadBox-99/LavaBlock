-- Iron dissolved in hydrochloric acid and topped up with chlorine: the
-- brown etchant that eats the bare copper off a circuit board and leaves
-- the tracks. Mixed with caustic soda instead, it drops its iron as
-- magnetite.
return {
    type = "fluid",
    name = "ferric-chloride",
    subgroup = "fluid",
    default_temperature = 15,
    heat_capacity = "0.2kJ",
    -- Deep rust, the colour of the real thing.
    base_color = { r = 0.43, g = 0.16, b = 0.08 },
    flow_color = { r = 0.65, g = 0.32, b = 0.18 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/ferric-chloride.png",
    icon_size = 64,
    order = "a[fluid]-z[ferric-chloride]",
    auto_barrel = true,
}
