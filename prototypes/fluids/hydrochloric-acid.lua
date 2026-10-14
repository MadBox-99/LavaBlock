-- Hydrogen burnt in chlorine and the gas taken up in water. It dissolves
-- iron into ferric chloride, the etchant for circuit boards, and later
-- turns ethylene into plastic.
return {
    type = "fluid",
    name = "hydrochloric-acid",
    subgroup = "fluid",
    default_temperature = 15,
    heat_capacity = "0.2kJ",
    -- Lime. Strong hydrochloric acid has a faint yellow-green cast from the
    -- chlorine in it; this is that, turned up enough to read in a pipe.
    base_color = { r = 0.71, g = 0.92, b = 0.35 },
    flow_color = { r = 0.85, g = 0.98, b = 0.60 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/hydrochloric-acid.png",
    icon_size = 64,
    order = "a[fluid]-z[hydrochloric-acid]",
    auto_barrel = true,
}
