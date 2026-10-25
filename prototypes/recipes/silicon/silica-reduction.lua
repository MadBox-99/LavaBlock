-- Silica reduced with coal to silicon, run off liquid, in the oil
-- refinery with lava for the heat. SiO2 + 2 C -> Si + 2 CO: the real
-- process takes an arc furnace and two carbons for every silicon, and the
-- two coal here are that.
--
-- Five crystals and two coal for 50 molten silicon. The puller makes 25
-- wafers from that, five to a crystal, where the laser cutter slices a
-- crystal into two. The coal, the refinery, the argon, the phosphorus and
-- the slow puller are what the extra wafers cost.
--
-- Not 15 wafers. At three to a crystal the phosphorus alone outweighed the
-- crystal saved, and a pulled wafer came out two fifths dearer than a cut
-- one; at five it is about an eighth cheaper.
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
    -- Allowed, as on quartz melting. There is no loop through the
    -- recycler: wafers recycle into wafers (see the laser cutter's
    -- recipe).
    allow_productivity = true,
    subgroup = "lava-block-melts",
    order = "g[silicon]-a[silica-reduction]",
}
