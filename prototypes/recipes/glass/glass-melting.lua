-- Silica crystal and quicklime melted together in the oil refinery, with
-- lava for the heat, the way quartz melting does it.
--
-- Six crystals and a quicklime for 100 molten glass, and 25 cast a glass:
-- four glass from six crystals, a crystal and a half each, where the
-- furnace takes two. The lime is what buys that, as it does in a real glass
-- furnace - it fluxes the silica so less of it is needed for the same
-- glass. A quarter of a quicklime a glass is the whole lime line behind it,
-- so a base short of silica builds this and one short of limestone does
-- not.
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
        { type = "fluid", name = "molten-glass", amount = 100 },
    },
    -- Allowed, as on quartz melting. Glass recycles to a quarter of the two
    -- crystals the furnace takes, half a crystal. With productivity modules
    -- in the refinery (+30%) and the caster (+40%), six crystals make 7.3
    -- glass, which recycle to 3.6 crystals: no loop.
    allow_productivity = true,
    subgroup = "lava-block-melts",
    order = "e[glass]-a[glass-melting]",
}
