-- The lithography machine's light source: a ruby laser and the tin droplet
-- nozzle it fires at, in one housing that slots into the machine.
--
-- It wears out. Every microchip craft has a one in fifty chance of burning
-- it up, so the machine eats one about every fifty crafts and the player
-- keeps them coming the way they keep a reactor in fuel. A light source that
-- lasted for ever would make the most expensive machine on the island the
-- one with nothing to feed.
return {
    type = "item",
    name = "laser-source",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/laser-source.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[lavablock]-l[laser-source]",
    stack_size = 20,
}
