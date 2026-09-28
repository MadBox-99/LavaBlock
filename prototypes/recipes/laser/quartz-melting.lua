-- Silica crystal melted into fused quartz in an oil refinery, the same way
-- the lava smelting line melts ore: the lava brings the heat and the
-- refinery's burners take it the rest of the way.
--
-- Ten crystals for a hundred units, and a lens takes fifty. A cutter needs
-- four lenses, so the whole melt of one cutter is twenty crystals - small
-- beside the rest of its bill, on purpose: the quartz is there to say what a
-- laser is made of, not to be the thing that holds it up.
return {
    type = "recipe",
    name = "quartz-melting",
    category = "oil-processing",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item",  name = "silica-crystal", amount = 10 },
        { type = "fluid", name = "lava",           amount = 500 },
    },
    results = {
        { type = "fluid", name = "molten-quartz", amount = 100 },
    },
    allow_productivity = true,
    subgroup = "fluid-recipes",
    order = "z[molten-quartz]",
}
