-- Steel with a fifth of chromium and a tenth of nickel in it. The chromium
-- puts a skin of oxide on it that heals itself, so it does not rust in
-- steam or in a reactor's water - which is what heat exchangers and
-- reactor vessels are made of it for.
--
-- Drawn as a recoloured steel girder, the way vanilla draws steel - the one
-- alloy the base game has - while every pure metal is a pile of plates
-- stamped with its symbol.
return {
    type = "item",
    name = "stainless-steel-plate",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/stainless-steel-plate.png",
    icon_size = 64,
    subgroup = "raw-material",
    order = "b[alloy]-a[stainless-steel-plate]",
    stack_size = 100,
}
