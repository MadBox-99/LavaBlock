-- The dross skimmed off a pan of lava: everything heavy enough to sink out
-- of the melt and light enough not to be metal.
--
-- Two lines start from it. Grown with sulfur and coal it gives crystal;
-- leached with water it gives up its calcium, and that becomes limestone.
-- It sits beside basalt, the other thing the island casts lava into, rather
-- than in either row: it belongs to both.
return {
    type = "item",
    name = "lava-slag",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/lava-slag.png",
    icon_size = 64,
    subgroup = "raw-resource",
    order = "a[basalt]-g[lava-slag]",
    stack_size = 100,
}
