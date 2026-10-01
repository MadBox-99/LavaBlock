-- The hearth grows two and a half pyrite for every sapphire and the board
-- takes two, so the sapphire runs out first and is rarely surplus. The way
-- out is here for when it is. See pyrite-crushing.
return {
    type = "recipe",
    name = "sapphire-crushing",
    categories = { "rock-crushing" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "item", name = "sapphire", amount = 1 },
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
        { icon = "__LavaBlock-graphics__/graphics/icons/parts/sapphire.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/basalt-gravel.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 8, 8 },
        },
    },
    subgroup = "lava-block-crystals",
    order = "z[crushing]-e[sapphire]",
}
