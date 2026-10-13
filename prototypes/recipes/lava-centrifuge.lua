-- Ferrofluid seals the rotor shaft: a fast shaft through a sealed drum is
-- one of the few places a real machine uses it.
return {
    type = "recipe",
    name = "lava-centrifuge",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "steel-plate",      amount = 100 },
        { type = "item",  name = "iron-gear-wheel",  amount = 100 },
        { type = "item",  name = "advanced-circuit", amount = 100 },
        { type = "item",  name = "concrete",         amount = 100 },
        { type = "fluid", name = "ferrofluid",       amount = 50 },
    },
    results = {
        { type = "item", name = "lava-centrifuge", amount = 1 }
    },
}
