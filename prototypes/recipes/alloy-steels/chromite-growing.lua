-- Slag on the crystal hearth with oxygen blown over it. Chromite is the
-- first mineral out of a cooling basalt and needs the melt oxidised to
-- form, so the oxygen is what the recipe is made of besides the slag.
--
-- 20 oxygen is small beside the 1000 lava behind the five slag.
return {
    type = "recipe",
    name = "chromite-growing",
    categories = { "lava-crystallizing" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "lava-slag", amount = 5 },
        { type = "fluid", name = "oxygen",    amount = 20 },
    },
    results = {
        { type = "item", name = "chromite", amount = 3 },
    },
    crafting_machine_tint = {
        primary = { r = 0.10, g = 0.10, b = 0.12, a = 1.0 },
        secondary = { r = 0.40, g = 0.70, b = 0.30, a = 1.0 },
    },
    allow_productivity = true,
    subgroup = "lava-block-crystals",
    order = "0[growing]-j[chromite]",
}
