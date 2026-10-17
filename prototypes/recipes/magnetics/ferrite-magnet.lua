-- Magnetite and limestone, pressed and fired. Two ingredients, so it is an
-- assembler's recipe and not a furnace's: a furnace takes one.
--
-- A magnetite costs about five iron plates (see magnetite-growing), so a
-- magnet does too, plus half a limestone.
return {
    type = "recipe",
    name = "ferrite-magnet",
    categories = { "advanced-crafting" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item", name = "magnetite", amount = 2 },
        { type = "item", name = "limestone", amount = 1 },
    },
    results = {
        { type = "item", name = "ferrite-magnet", amount = 2 },
    },
    allow_productivity = true,
}
