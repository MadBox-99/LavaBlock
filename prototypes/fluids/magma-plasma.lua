-- Molten salt driven past boiling and stripped of its electrons in the
-- magma reactor - the island's answer to Space Age's fusion plasma, and the
-- only thing the magma turbine runs on.
--
-- 25 MJ a unit at its default 50,000 degrees, the same as fusion plasma:
-- the turbine's 250 MW is ten units a second. It is energy by temperature,
-- not by burning, so a reactor with neighbours runs it hotter and each unit
-- carries more.
--
-- Violet-pink, the colour a plasma glows, and nothing else on the island is
-- that colour: lava is orange, molten quartz amber and hot salt red, and a
-- fourth glowing orange would be the one that gets piped into the wrong
-- machine.
return {
    type = "fluid",
    name = "magma-plasma",
    subgroup = "fluid",
    default_temperature = 50000,
    max_temperature = 500000,
    heat_capacity = "0.5kJ",
    base_color = { r = 0.60, g = 0.10, b = 0.45 },
    flow_color = { r = 1.00, g = 0.45, b = 0.85 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/magma-plasma.png",
    icon_size = 64,
    order = "a[fluid]-z[magma-plasma]",
    -- No barrel and no pipe: like fusion plasma it only passes from a reactor
    -- straight into a turbine, or from one turbine into the next.
    auto_barrel = false,
}
