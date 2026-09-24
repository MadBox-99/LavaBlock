-- Basalt off the first pass through a crusher, on its way to the second.
--
-- The rock line used to be one step: basalt in, stone out. Splitting it in
-- two is what gives the crusher a factory to sit in rather than a single
-- machine bolted to a belt - a row of crushers now has a first bank and a
-- second, with something moving between them.
--
-- It carries a rendered icon rather than a recoloured vanilla stone, which
-- is what basalt does. Three tinted copies of the same rock - stone, basalt,
-- gravel - would be three items nobody can tell apart on a belt, and that is
-- exactly the complaint this mod has already had to answer once.
return {
    type = "item",
    name = "basalt-gravel",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/basalt-gravel.png",
    icon_size = 64,
    subgroup = "raw-resource",
    order = "a[basalt]-b[gravel]",
    stack_size = 100,
}
