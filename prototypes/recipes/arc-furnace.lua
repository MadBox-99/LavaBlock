-- The arc furnace: a steel shell, a refractory hearth and roof, and the
-- copper that carries the current from the transformer to the electrodes.
-- Concrete for the pad a tilting furnace stands on.
--
-- Six steel furnaces' brick, because the hearth and the roof are both
-- lined, and forty steel for the shell, the masts and the arms.
return {
    type = "recipe",
    name = "arc-furnace",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "steel-plate",        amount = 40 },
        { type = "item", name = "stone-brick",        amount = 60 },
        { type = "item", name = "concrete",           amount = 20 },
        { type = "item", name = "copper-cable",       amount = 30 },
        { type = "item", name = "electronic-circuit", amount = 10 },
    },
    results = {
        { type = "item", name = "arc-furnace", amount = 1 },
    },
}
