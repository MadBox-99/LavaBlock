-- The Ostwald process: ammonia burnt with oxygen over a gauze of platinum,
-- and the gas washed into nitric acid. The way all nitric acid has been
-- made for a century, where the electric arc the Nitric Acid technology
-- burns nitrogen in was given up because it ate power.
--
-- 20 ammonia and 40 oxygen for 40 nitric acid and 20 water in two
-- seconds, against eight seconds for the arc's 40. The platinum is a
-- catalyst and comes back 49 times in 50: it wears, as a real gauze does.
-- Ignored by productivity, so productivity multiplies only the acid.
return {
    type = "recipe",
    name = "nitric-acid-from-ammonia",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item",  name = "platinum-plate", amount = 1 },
        { type = "fluid", name = "ammonia",        amount = 20 },
        { type = "fluid", name = "oxygen",         amount = 40 },
    },
    results = {
        { type = "item",  name = "platinum-plate", amount = 1, independent_probability = 0.98, ignored_by_productivity = 1 },
        { type = "fluid", name = "nitric-acid",    amount = 40 },
        { type = "fluid", name = "water",          amount = 20 },
    },
    main_product = "nitric-acid",
    allow_productivity = true,
    -- The arc recipe is the one nitric acid is recycled by, and a gauze
    -- that comes back is not an ingredient to give back.
    auto_recycle = false,
    crafting_machine_tint = {
        primary = { r = 0.95, g = 0.80, b = 0.40, a = 1.0 },
        secondary = { r = 0.85, g = 0.85, b = 0.88, a = 1.0 },
    },
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/fluid/nitric-acid.png", icon_size = 64 },
        {
            icon = "__space-age__/graphics/icons/fluid/ammonia.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "o[ammonia]-b[nitric-acid-from-ammonia]",
}
