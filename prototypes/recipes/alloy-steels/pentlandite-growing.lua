-- Slag on the crystal hearth with molten iron and sulfur: the iron and the
-- sulfur make a sulfide melt, and the melt pulls the nickel out of the
-- slag as it goes, the way the great nickel deposits formed under old
-- basalts.
--
-- 50 molten iron is what magnetite takes for two crystals, and here it buys
-- three, because most of a pentlandite is the slag's nickel and not the
-- iron.
return {
    type = "recipe",
    name = "pentlandite-growing",
    categories = { "lava-crystallizing" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "lava-slag",   amount = 5 },
        { type = "item",  name = "sulfur",      amount = 1 },
        { type = "fluid", name = "molten-iron", amount = 50 },
    },
    results = {
        { type = "item", name = "pentlandite", amount = 3 },
    },
    crafting_machine_tint = {
        primary = { r = 0.62, g = 0.52, b = 0.26, a = 1.0 },
        secondary = { r = 0.90, g = 0.80, b = 0.20, a = 1.0 },
    },
    allow_productivity = true,
    subgroup = "lava-block-crystals",
    order = "0[growing]-i[pentlandite]",
}
