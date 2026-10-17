-- Tin, smelted out of cassiterite. The lithography machine melts it and
-- fires it as droplets into the path of its laser, which turns each droplet
-- into the plasma whose light prints the chips; the laser source is built
-- around a tin nozzle.
return {
    type = "item",
    name = "tin-plate",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/tin-plate.png",
    icon_size = 64,
    subgroup = "raw-material",
    order = "a[smelting]-d[tin-plate]",
    stack_size = 100,
}
