-- A slice off a silica crystal, cut by the laser. Solar cells are wafers
-- like this, so the second solar panel recipe is built from them.
return {
    type = "item",
    name = "silicon-wafer",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/silicon-wafer.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[lavablock]-i[silicon-wafer]",
    stack_size = 100,
}
