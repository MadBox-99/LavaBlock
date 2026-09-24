-- A toothed drum. Two of them turning towards each other are what a roll
-- crusher crushes with, so this is the part the whole machine is named after
-- and the one a player will recognise from the sprite.
--
-- It sits at the end of the intermediate-product subgroup with the mod's
-- other machine parts, so the crafting menu keeps them in one block instead
-- of scattering them through the vanilla intermediates.
return {
    type = "item",
    name = "crusher-roll",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/crusher-roll.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[lavablock]-a[crusher-roll]",
    stack_size = 50,
}
