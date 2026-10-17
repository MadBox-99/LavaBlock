-- Neodymium, iron and boron pressed and sintered into magnets, and plated
-- with nickel. Nd2Fe14B is about a quarter neodymium and one per cent
-- boron by weight; two neodymium, five iron, a boron and a nickel plate
-- make four.
--
-- In an assembler, like the ferrite magnet: sintering is pressing and
-- baking, not melting.
return {
    type = "recipe",
    name = "neodymium-magnet",
    categories = { "advanced-crafting" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item", name = "neodymium",    amount = 2 },
        { type = "item", name = "iron-plate",   amount = 5 },
        { type = "item", name = "boron",        amount = 1 },
        { type = "item", name = "nickel-plate", amount = 1 },
    },
    results = {
        { type = "item", name = "neodymium-magnet", amount = 4 },
    },
    allow_productivity = true,
}
