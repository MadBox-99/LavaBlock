-- Brine boiled down further than borax takes it, until the potassium
-- chloride comes out. The same hearth, a different cut of the same brine.
--
-- 100 brine for two potash, which is two fertiliser crafts.
return {
    type = "recipe",
    name = "potash-crystallizing",
    category = "lava-crystallizing",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "fluid", name = "brine", amount = 100 },
    },
    results = {
        { type = "item", name = "potash", amount = 2 },
    },
    crafting_machine_tint = {
        primary = { r = 0.90, g = 0.62, b = 0.60, a = 1.0 },
        secondary = { r = 0.58, g = 0.76, b = 0.84, a = 1.0 },
    },
    allow_productivity = true,
    subgroup = "lava-block-crystals",
    order = "0[growing]-n[potash]",
}
