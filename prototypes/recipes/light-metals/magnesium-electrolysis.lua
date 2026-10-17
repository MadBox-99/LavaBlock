-- The Dow process, on brine: slaked lime drops the magnesium out of the
-- brine as hydroxide, the hydroxide is turned to chloride and melted, and a
-- current splits the melt into magnesium and chlorine. Dow did it with sea
-- water; geothermal brine is richer.
--
-- 100 brine and a slaked lime for ten molten magnesium, a plate's worth,
-- and 20 chlorine back up the offtake - less than the brine electrolysis
-- would have made from the same brine, since most of its chloride stays
-- as salt.
return {
    type = "recipe",
    name = "magnesium-electrolysis",
    category = "arc-smelting",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "slaked-lime", amount = 1 },
        { type = "fluid", name = "brine",       amount = 100 },
    },
    results = {
        { type = "fluid", name = "molten-magnesium", amount = 10, fluidbox_index = 1 },
        { type = "fluid", name = "chlorine",         amount = 20, fluidbox_index = 2 },
    },
    main_product = "molten-magnesium",
    allow_productivity = true,
    subgroup = "fluid-recipes",
    order = "m[melt]-g[molten-magnesium]",
}
