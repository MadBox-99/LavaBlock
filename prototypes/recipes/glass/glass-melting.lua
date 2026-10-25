-- Silica crystal and quicklime melted together in the oil refinery, with
-- lava for the heat, the way quartz melting does it.
--
-- Six crystals and a quicklime for 150 molten glass, and 25 cast a glass:
-- six glass from six crystals, a crystal each, where the furnace takes two.
-- The lime is what buys that, as it does in a real glass furnace - it
-- fluxes the silica so less of it is needed for the same glass. A sixth of
-- a quicklime a glass is the whole lime line behind it.
--
-- Not 100. At a crystal and a half a glass, the refinery, the quicklime and
-- the caster cost more than the half crystal they saved, so cast glass and
-- glazed panels from the melt came out a fifth dearer than the furnace's
-- glass. At 150 cast glass is a little cheaper and float glass a third
-- cheaper again.
return {
    type = "recipe",
    name = "glass-melting",
    categories = { "oil-processing" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item",  name = "silica-crystal", amount = 6 },
        { type = "item",  name = "quicklime",      amount = 1 },
        { type = "fluid", name = "lava",           amount = 500 },
    },
    results = {
        { type = "fluid", name = "molten-glass", amount = 150 },
    },
    -- Allowed, as on quartz melting. There is no loop through the
    -- recycler: glass recycles into glass (see the furnace recipe), so
    -- nothing turns it back into crystal.
    allow_productivity = true,
    subgroup = "lava-block-melts",
    order = "e[glass]-a[glass-melting]",
}
