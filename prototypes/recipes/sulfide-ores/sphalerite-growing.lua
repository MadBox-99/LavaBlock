-- Slag on the crystal hearth with sulfur and steam: zinc grown out as
-- sphalerite. Wet where galena is dry, because zinc ore is a hydrothermal
-- mineral - it settles out of hot water that has run through rock - and
-- the steam is that water.
--
-- One sulfur where galena takes two, since zinc sulfide carries half as
-- much sulfur by weight as lead sulfide does, and the same three crystals a
-- craft so the two ores pace each other.
return {
    type = "recipe",
    name = "sphalerite-growing",
    category = "lava-crystallizing",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "lava-slag", amount = 5 },
        { type = "item",  name = "sulfur",    amount = 1 },
        { type = "fluid", name = "steam",     amount = 50 },
    },
    results = {
        { type = "item", name = "sphalerite", amount = 3 },
    },
    crafting_machine_tint = {
        primary = { r = 0.45, g = 0.26, b = 0.10, a = 1.0 },
        secondary = { r = 0.90, g = 0.80, b = 0.20, a = 1.0 },
    },
    allow_productivity = true,
    subgroup = "lava-block-crystals",
    order = "0[growing]-h[sphalerite]",
}
