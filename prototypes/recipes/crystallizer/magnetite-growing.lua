-- Molten iron on the crystal hearth with slag stirred through it. The iron
-- takes oxygen from the slag and grows out as magnetite.
--
-- Its own recipe and not one more roll in crystal growing, because it needs
-- molten iron, which on the island means the lava smelting line - a blue
-- science research after the random crystals are long running. Nothing is
-- left to chance here, so there is nothing to crush either.
--
-- 50 molten iron is ten iron plates' worth once cooled, so a magnetite
-- costs about five plates. That is what it is meant to be dear in.
return {
    type = "recipe",
    name = "magnetite-growing",
    categories = { "lava-crystallizing" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "fluid", name = "molten-iron", amount = 50 },
        { type = "item",  name = "lava-slag",   amount = 5 },
    },
    results = {
        { type = "item", name = "magnetite", amount = 2 },
    },
    crafting_machine_tint = {
        primary = { r = 0.20, g = 0.20, b = 0.22, a = 1.0 },
        secondary = { r = 1.00, g = 0.42, b = 0.08, a = 1.0 },
    },
    allow_productivity = true,
}
