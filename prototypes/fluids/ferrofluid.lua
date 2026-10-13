-- Magnetite ground to particles ten nanometres across and held in oil, so
-- the whole liquid answers a magnet. Its real work is sealing a turning
-- shaft: a ring of it held in place by magnets lets the shaft turn and
-- keeps a vacuum or a pressure on one side of it. That is what the
-- lithography machine and the lava centrifuge take it for.
return {
    type = "fluid",
    name = "ferrofluid",
    subgroup = "fluid",
    default_temperature = 25,
    heat_capacity = "1.6kJ",
    -- Black with a cold sheen, not crude oil's brown-black.
    base_color = { r = 0.05, g = 0.055, b = 0.07 },
    flow_color = { r = 0.30, g = 0.32, b = 0.38 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/ferrofluid.png",
    icon_size = 64,
    order = "a[fluid]-z[ferrofluid]",
    auto_barrel = true,
}
