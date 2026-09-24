-- A finned copper tube: it pulls the heat out of steam so the steam can
-- fall back to water. Four of them make up the two cooling columns standing
-- across the back of the water condenser, and they are where that machine's
-- copper cost lives.
return {
    type = "item",
    name = "condenser-coil",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/condenser-coil.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[lavablock]-d[condenser-coil]",
    stack_size = 50,
}
