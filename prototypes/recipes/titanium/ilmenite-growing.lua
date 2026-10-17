-- Slag on the crystal hearth with coal: ilmenite grows out of a basalt
-- melt kept short of oxygen, and the coal is what keeps it short. Iron that
-- would otherwise rust into magnetite stays in the ilmenite with the
-- titanium.
--
-- Three a craft, like every ore the hearth grows on purpose.
return {
    type = "recipe",
    name = "ilmenite-growing",
    category = "lava-crystallizing",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "lava-slag", amount = 5 },
        { type = "item", name = "coal",      amount = 1 },
    },
    results = {
        { type = "item", name = "ilmenite", amount = 3 },
    },
    crafting_machine_tint = {
        primary = { r = 0.12, g = 0.11, b = 0.12, a = 1.0 },
        secondary = { r = 0.70, g = 0.62, b = 0.90, a = 1.0 },
    },
    allow_productivity = true,
    subgroup = "lava-block-crystals",
    order = "0[growing]-l[ilmenite]",
}
