-- Silica reduced with coal to silicon, run off liquid, in the oil
-- refinery with lava for the heat. SiO2 + 2 C -> Si + 2 CO: the real
-- process takes an arc furnace and two carbons for every silicon, and the
-- two coal here are that.
--
-- Five crystals and two coal for 50 molten silicon. The puller makes 15
-- wafers from that, three to a crystal, where the laser cutter slices a
-- crystal into two. The coal, the refinery, the argon and the slow puller
-- are what the extra wafer costs.
return {
    type = "recipe",
    name = "silica-reduction",
    categories = { "oil-processing" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item",  name = "silica-crystal", amount = 5 },
        { type = "item",  name = "coal",           amount = 2 },
        { type = "fluid", name = "lava",           amount = 500 },
    },
    results = {
        { type = "fluid", name = "molten-silicon", amount = 50 },
    },
    -- Allowed, as on quartz melting. A wafer recycles to an eighth of a
    -- crystal, so five crystals through both steps at full modules (+30%
    -- in the refinery, +20% in the puller) make 23 wafers that recycle to
    -- under three crystals.
    allow_productivity = true,
    subgroup = "lava-block-melts",
    order = "g[silicon]-a[silica-reduction]",
}
