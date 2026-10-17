-- The Pilkington process: molten glass poured onto a bath of molten tin,
-- where it spreads flat under its own weight and cools perfectly smooth on
-- both sides. Rolled glass has to be ground and polished to get there,
-- and loses glass doing it; float glass does not.
--
-- 100 molten glass for 5 glass, where casting gets 4 - a crystal and a fifth
-- a glass against a crystal and a half. The bath is a catalyst: 20 tin go
-- in and 19 come back, so it costs a tenth of a tin plate for five glass.
-- That is a small price, which is why this waits for tin, and tin waits for
-- EUV lithography.
return {
    type = "recipe",
    name = "float-glass",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "fluid", name = "molten-glass", amount = 100 },
        { type = "fluid", name = "molten-tin",   amount = 20 },
    },
    results = {
        { type = "item",  name = "glass",      amount = 5 },
        -- Productivity multiplies the glass only, or the bath would grow.
        { type = "fluid", name = "molten-tin", amount = 19, ignored_by_productivity = 19 },
    },
    main_product = "glass",
    allow_productivity = true,
    -- Glass keeps recycling into silica crystal.
    auto_recycle = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/glass.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-tin.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "z[lavablock]-e[glass]-c[float]",
    crafting_machine_tint = {
        primary = { r = 1.00, g = 0.47, b = 0.16, a = 1.0 },
        secondary = { r = 0.59, g = 0.61, b = 0.65, a = 1.0 },
    },
}
