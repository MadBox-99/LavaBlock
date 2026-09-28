-- Magnetite: iron oxide, crystallised out of molten iron with slag stirred
-- through it. Grown on purpose from its own recipe rather than rolled for
-- with the others, and nothing uses it yet - it is kept for what comes
-- later.
--
-- It took the place of obsidian in 0.2.4. Pyroclast has an obsidian item of
-- its own, unique to that planet, and a second one here overwrote it.
return {
    type = "item",
    name = "magnetite",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/magnetite.png",
    icon_size = 64,
    subgroup = "lava-block-crystals",
    order = "b[magnetite]",
    stack_size = 100,
}
