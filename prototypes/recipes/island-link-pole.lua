-- A big pole on a heavier mast with a longer run of cable on it. Twice a big
-- pole's reach for about four times the steel, which is the price of not
-- having to build a power plant on every island.
return {
    type = "recipe",
    name = "island-link-pole",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item", name = "big-electric-pole", amount = 1 },
        { type = "item", name = "steel-plate",       amount = 15 },
        { type = "item", name = "copper-cable",      amount = 40 },
        { type = "item", name = "stone-brick",       amount = 5 },
    },
    results = {
        { type = "item", name = "island-link-pole", amount = 1 }
    },
}
