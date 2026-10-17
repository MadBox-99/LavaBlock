-- Titanium tetrachloride, "tickle" to the people who make it: a clear
-- liquid that fumes white in damp air. Chlorine strips the titanium out of
-- ilmenite as this, the one form in which titanium can be purified by
-- distilling it, before sodium reduces it back to metal.
return {
    type = "fluid",
    name = "titanium-tetrachloride",
    subgroup = "fluid",
    default_temperature = 25,
    heat_capacity = "0.8kJ",
    -- Pale straw: the faint yellow of the technical grade, so the clear
    -- liquid has a colour to be told by.
    base_color = { r = 0.86, g = 0.84, b = 0.62 },
    flow_color = { r = 0.94, g = 0.93, b = 0.82 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/titanium-tetrachloride.png",
    icon_size = 64,
    order = "a[fluid]-z[titanium-tetrachloride]",
}
