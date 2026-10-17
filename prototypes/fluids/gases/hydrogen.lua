-- Hydrogen, from the cathode of the chlor-alkali cell and later from
-- reformed methane. It burns with chlorine into hydrochloric acid, lays
-- down diamond with methane, and builds oil back up out of carbon monoxide.
--
-- Not from water electrolysis, though that is where it really comes from
-- too: that recipe was tuned to make oxygen alone, 100 for 100, and giving
-- it a second output would hand every oxygen line a gas to get rid of.
return {
    type = "fluid",
    name = "hydrogen",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -253,                      -- Boiling point in C
    heat_capacity = "1.4kJ",
    -- White with a cold blue edge: the lightest thing in a pipe.
    base_color = { r = 0.80, g = 0.94, b = 1.00 },
    flow_color = { r = 0.92, g = 0.98, b = 1.00 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/hydrogen.png",
    icon_size = 64,
    order = "a[gas]-b[hydrogen]",
    auto_barrel = true,
}
