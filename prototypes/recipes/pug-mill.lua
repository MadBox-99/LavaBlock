-- Cheap and early. A mill is a tub, a paddle and a frame; the point of the
-- machine is that it replaces a furnace, and a furnace costs five stone.
return {
    type = "recipe",
    name = "pug-mill",
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "item", name = "stone-brick",     amount = 20 },
        { type = "item", name = "iron-plate",      amount = 20 },
        { type = "item", name = "iron-gear-wheel", amount = 10 },
        { type = "item", name = "pipe",            amount = 5 },
    },
    results = {
        { type = "item", name = "pug-mill", amount = 1 }
    },
}
