-- Leaching bacteria, picked out of jelly the way Space Age picks its iron
-- bacteria out of it: one craft in ten keeps a culture, the rest is
-- spoilage. Sulfur goes in as well, because these strains live on it -
-- it is what they are fed, and what tells them from the iron bacteria in
-- the same jelly.
--
-- Gleba only, like Space Age's bacteria. Half the jelly of iron bacteria,
-- because a strain fed on sulfur has to be found only once and then
-- cultivated.
return {
    type = "recipe",
    name = "leaching-bacteria",
    categories = { "organic", "crafting" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "item", name = "jelly",  amount = 3 },
        { type = "item", name = "sulfur", amount = 1 },
    },
    results = {
        { type = "item", name = "leaching-bacteria", amount = 1, independent_probability = 0.1 },
        { type = "item", name = "spoilage",          amount = 1 },
    },
    main_product = "leaching-bacteria",
    allow_productivity = true,
    surface_conditions = {
        { property = "pressure", min = 2000, max = 2000 },
    },
    subgroup = "agriculture-processes",
    order = "b[agriculture]-d[bacteria]-e[leaching-bacteria]",
    crafting_machine_tint = {
        primary = { r = 0.80, g = 0.74, b = 0.20, a = 1 },
        secondary = { r = 0.62, g = 0.66, b = 0.22, a = 1 },
    },
}
