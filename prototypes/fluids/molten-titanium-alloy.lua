-- Titanium with aluminium and vanadium melted into it: Ti-6Al-4V, before it
-- is cast.
return {
    type = "fluid",
    name = "molten-titanium-alloy",
    subgroup = "fluid",
    default_temperature = 1660,
    max_temperature = 1660,
    heat_capacity = "0.5kJ",
    -- Violet, a shade darker than molten titanium.
    base_color = { r = 0.66, g = 0.62, b = 0.86 },
    flow_color = { r = 0.83, g = 0.81, b = 0.93 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-titanium-alloy.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-titanium-alloy]",
    -- A melt is not barrelled: it would set in the barrel.
    auto_barrel = false,
}
