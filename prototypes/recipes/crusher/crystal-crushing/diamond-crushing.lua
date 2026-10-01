-- Nobody will want to, but the diamond needs a way out like the rest: a
-- player who has built all the laser cutters they want has no other use for
-- them, and a chest full would otherwise stop the hearth. See
-- pyrite-crushing.
return {
    type = "recipe",
    name = "diamond-crushing",
    categories = { "rock-crushing" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "item", name = "diamond", amount = 1 },
    },
    results = {
        { type = "item", name = "basalt-gravel", amount = 1 },
    },
    allow_decomposition = false,
    -- The recycler undoes the last recipe it finds for an item, and this
    -- would be the last one for basalt gravel: every gravel would recycle
    -- into a quarter of a crystal, which turns the drain into a mint.
    auto_recycle = false,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/parts/diamond.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/basalt-gravel.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 8, 8 },
        },
    },
    subgroup = "lava-block-crystals",
    order = "z[crushing]-f[diamond]",
}
