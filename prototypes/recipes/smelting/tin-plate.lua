-- Cassiterite reduced to tin. Plain "smelting", like iron and copper: a
-- stone furnace does it, and tin melts at a little over 230 degrees, which
-- is the easiest smelt on the island.
return {
    type = "recipe",
    name = "tin-plate",
    category = "smelting",
    enabled = false,
    energy_required = 3.2,
    ingredients = {
        { type = "item", name = "cassiterite", amount = 1 },
    },
    results = {
        { type = "item", name = "tin-plate", amount = 1 },
    },
    allow_productivity = true,
}
