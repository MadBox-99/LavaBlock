-- The way out for surplus pyrite. The crystal hearth rolls its results, so
-- whatever the factory is not using piles up behind what it is waiting for;
-- without a way out the belt stops for want of one ruby.
--
-- Crushing is the way out for every crystal, and it pays back gravel: one for
-- one, much less than the slag's lava would have made cast as basalt, so it is
-- a drain and not a shortcut to stone. No productivity and no decomposition,
-- for the same reason.
return {
    type = "recipe",
    name = "pyrite-crushing",
    category = "rock-crushing",
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "item", name = "pyrite", amount = 1 },
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
        { icon = "__LavaBlock-graphics__/graphics/icons/parts/pyrite.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/basalt-gravel.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 8, 8 },
        },
    },
    subgroup = "lava-block-crystals",
    order = "z[crushing]-a[pyrite]",
}
