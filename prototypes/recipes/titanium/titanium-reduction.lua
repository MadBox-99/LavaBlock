-- The Hunter process: titanium tetrachloride run onto molten sodium, which
-- takes the chlorine as salt and leaves titanium behind - here melted down
-- under the arcs and tapped. The salt stays in the hearth with the slag.
--
-- 20 tetrachloride and 40 molten sodium for 10 molten titanium. Two brine
-- cells' sodium and two ilmenite make a plate's worth of titanium, which is
-- why titanium is dear.
return {
    type = "recipe",
    name = "titanium-reduction",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "fluid", name = "titanium-tetrachloride", amount = 20 },
        { type = "fluid", name = "molten-sodium",          amount = 40 },
    },
    results = {
        { type = "fluid", name = "molten-titanium", amount = 10, fluidbox_index = 1 },
    },
    allow_productivity = true,
    subgroup = "lava-block-metal-melts",
    order = "m[melt]-j[molten-titanium]",
}
