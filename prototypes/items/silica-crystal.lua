-- What the hearth grows. A raw resource rather than an intermediate: it is
-- dug out of a pan of melt, not assembled from anything, and it sits beside
-- basalt in the crafting menu where the island's other rock does.
return {
    type = "item",
    name = "silica-crystal",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/silica-crystal.png",
    icon_size = 64,
    subgroup = "raw-resource",
    order = "a[basalt]-c[silica-crystal]",
    stack_size = 100,
}
