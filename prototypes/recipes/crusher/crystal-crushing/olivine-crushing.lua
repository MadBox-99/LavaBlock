-- Olivine has no use yet, so for now all of it ends up here. See
-- pyrite-crushing for why every crystal has a way out and why it pays so
-- little.
return {
    type = "recipe",
    name = "olivine-crushing",
    category = "rock-crushing",
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "item", name = "olivine", amount = 1 },
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
        { icon = "__LavaBlock-graphics__/graphics/icons/parts/olivine.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/basalt-gravel.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 8, 8 },
        },
    },
    subgroup = "lava-block-crystals",
    order = "z[crushing]-c[olivine]",
}
