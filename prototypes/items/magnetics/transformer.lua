-- Two coils on a laminated steel core, sealed in a tank of oil that cools
-- and insulates them. Mineral oil, not ferrofluid: that is what real
-- transformers are filled with, and lubricant is the island's mineral oil.
-- A substation is a transformer with a pole on it.
return {
    type = "item",
    name = "transformer",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/transformer.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[lavablock]-p[transformer]",
    stack_size = 20,
}
