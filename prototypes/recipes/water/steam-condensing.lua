-- Steam Condensing: the water condenser's reason to exist.
--
-- Space Age's own steam-condensation runs in a chemical plant at 1000 steam ->
-- 90 water. On an island with no ocean that is the only water supply, and at
-- roughly 11 lava per water it makes liquid nitrogen and smelting coolant far
-- more expensive than they were ever meant to be.
--
-- A dedicated condenser gets 2 steam per water, so the same steam goes about
-- five and a half times further. That does not open a new loop: the nitrogen
-- cooling chain already paid for its own water out of the steam it produces
-- (1500 steam out against the 222 the old ratio needed), so this only widens a
-- margin that was already positive.
return {
    type = "recipe",
    name = "steam-condensing",
    category = "water-condensing",
    subgroup = "fluid-recipes",
    order = "a[fluid-chemistry]-c[steam-condensing]",
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "steam", amount = 500 },
    },
    results = {
        { type = "fluid", name = "water", amount = 250 },
    },
    -- One fluid into another: productivity here would be free matter, and
    -- quality does nothing on a fluid-only recipe.
    allow_productivity = false,
    allow_quality = false,
    always_show_products = true,
    icons = {
        { icon = "__base__/graphics/icons/fluid/water.png", icon_size = 64 },
        {
            icon = "__base__/graphics/icons/fluid/steam.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.41, g = 0.69, b = 0.90, a = 1.0 },
        secondary = { r = 0.75, g = 0.88, b = 0.95, a = 1.0 },
    },
}
