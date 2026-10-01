return {
    type = "item",
    name = "magma-turbine",
    icon = "__LavaBlock-graphics__/graphics/icons/items/magma-turbine.png",
    icon_size = 64,
    subgroup = "energy",
    order = "f[nuclear-energy]-g[magma-turbine]",
    place_result = "magma-turbine",
    stack_size = 5,
    -- Three fusion generators' worth of machine, so three of their weight.
    weight = 600000,
}
