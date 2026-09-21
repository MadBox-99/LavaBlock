-- Algae cultivation: the three things the algae tank grows.
--
-- Each strain lives off a different solution, which is what makes the tank a
-- machine you route pipes to rather than a box that turns water into one
-- thing. Water is always the medium; the second fluid is the difference.
--
--   green - water thick with dissolved rock. Mineral-fed algae build fibre,
--           and pressed fibre stands in for timber.
--   blue  - water and air. Cyanobacteria fix nitrogen straight out of the
--           atmosphere, which is where the island's nitrogen ought to come
--           from rather than out of a lava pipe.
--   red   - water and steam, a hot spring in a jar. Coralline red algae lay
--           down calcium carbonate as they grow, so the harvest is calcite.
--
-- Costs are set against the existing routes rather than out of the air; the
-- arithmetic is in each processing recipe.
local function cultivate(colour, order, medium, amount, seconds, yield, tint)
    return {
        type = "recipe",
        name = "algae-" .. colour,
        category = "algae-tank",
        subgroup = "raw-material",
        order = "a[algae]-" .. order .. "[algae-" .. colour .. "]",
        enabled = false,
        energy_required = seconds,
        ingredients = {
            { type = "fluid", name = "water", amount = 100 },
            { type = "fluid", name = medium,  amount = amount },
        },
        results = {
            { type = "item", name = "algae-" .. colour, amount = yield },
        },
        -- Growing matter is the one place productivity is not free lunch:
        -- a better-run garden really does yield more off the same feed.
        allow_productivity = true,
        main_product = "algae-" .. colour,
        icons = {
            {
                icon = "__LavaBlock__/graphics/icons/items/algae-"
                    .. colour .. ".png",
                icon_size = 64,
            },
        },
        crafting_machine_tint = tint,
    }
end

return {
    cultivate("green", "a", "lava", 100, 5, 5, {
        primary = { r = 0.28, g = 0.86, b = 0.34, a = 1.0 },
        secondary = { r = 0.52, g = 0.95, b = 0.45, a = 1.0 },
    }),
    cultivate("blue", "b", "air", 400, 6, 5, {
        primary = { r = 0.26, g = 0.56, b = 1.00, a = 1.0 },
        secondary = { r = 0.48, g = 0.76, b = 1.00, a = 1.0 },
    }),
    cultivate("red", "c", "steam", 200, 5, 5, {
        primary = { r = 1.00, g = 0.26, b = 0.32, a = 1.0 },
        secondary = { r = 1.00, g = 0.52, b = 0.46, a = 1.0 },
    }),
}
