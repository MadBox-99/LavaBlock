-- What comes out of the fermentation tank: water with about a tenth of it
-- turned to alcohol, and the spent biomass still in suspension. Distillers
-- call it wash, or beer, and it is worth nothing until the column has boiled
-- the ethanol out of it.
return {
    type = "fluid",
    name = "fermented-wash",
    subgroup = "fluid",
    order = "a[fluid]-z[fermented-wash]",
    default_temperature = 15,
    max_temperature = 100,
    -- Murky tan, the colour of anything that has been fermenting for a
    -- week. Darker and duller than ethanol so the two are not confused in
    -- a pipe.
    base_color = { r = 0.40, g = 0.30, b = 0.14 },
    flow_color = { r = 0.62, g = 0.50, b = 0.28 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/fermented-wash.png",
    icon_size = 64,
    auto_barrel = true,
}
