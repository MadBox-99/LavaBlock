-- Caustic soda in water, the third product of the chlor-alkali cell and
-- the reason the industry runs it as much as for the chlorine. Here it
-- precipitates magnetite out of ferric chloride, the way ferrofluid's
-- particles are actually made, and the salt it leaves behind goes back to
-- the cell as brine.
return {
    type = "fluid",
    name = "sodium-hydroxide",
    subgroup = "fluid",
    default_temperature = 15,
    heat_capacity = "0.2kJ",
    -- Pale lavender. The real solution is clear; this keeps it apart from
    -- water and from calcium solution's milk.
    base_color = { r = 0.75, g = 0.69, b = 0.92 },
    flow_color = { r = 0.88, g = 0.84, b = 0.98 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/sodium-hydroxide.png",
    icon_size = 64,
    order = "a[fluid]-z[sodium-hydroxide]",
    auto_barrel = true,
}
