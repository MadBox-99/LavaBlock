-- In the mod's own block at the end of the intermediates, with the machine
-- parts, so the crafting menu keeps them together instead of scattering
-- them through the vanilla list.
return {
    type = "item",
    name = "glass",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/glass.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[lavablock]-e[glass]",
    stack_size = 100,
}
