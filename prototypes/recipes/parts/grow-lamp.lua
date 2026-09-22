-- Circuits and copper, near enough what a vanilla lamp costs. Unlocked by
-- the arboretum, which is the first thing on the island that needs light.
return {
    type = "recipe",
    name = "grow-lamp",
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "item", name = "electronic-circuit", amount = 2 },
        { type = "item", name = "copper-plate",       amount = 2 },
        { type = "item", name = "iron-plate",         amount = 1 },
    },
    results = { { type = "item", name = "grow-lamp", amount = 1 } },
}
