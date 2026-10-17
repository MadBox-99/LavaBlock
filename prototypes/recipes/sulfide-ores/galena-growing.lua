-- Slag remelted on the crystal hearth with sulfur, and the lead in it grown
-- out as galena. Dry - sulfur and melt only - which is how galena forms out
-- of a sulfide-rich magma.
--
-- Three galena a craft, so a crystallizer keeps a chemical plant's worth of
-- batteries in lead with a little to spare: a battery takes a lead plate
-- every four seconds, and this makes 0.3 galena a second. Its own recipe and
-- not a roll, like magnetite and cassiterite, so lead never waits on luck.
--
-- Productivity is allowed, as on every recipe this hearth runs; nothing
-- downstream turns back into slag.
return {
    type = "recipe",
    name = "galena-growing",
    categories = { "lava-crystallizing" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "lava-slag", amount = 5 },
        { type = "item", name = "sulfur",    amount = 2 },
    },
    results = {
        { type = "item", name = "galena", amount = 3 },
    },
    crafting_machine_tint = {
        primary = { r = 0.42, g = 0.45, b = 0.52, a = 1.0 },
        secondary = { r = 0.90, g = 0.80, b = 0.20, a = 1.0 },
    },
    allow_productivity = true,
    subgroup = "lava-block-crystals",
    order = "0[growing]-g[galena]",
}
