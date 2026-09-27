-- A catalytic reactor, an insulated oxygen sphere and a filling press. The
-- advanced circuits are the press's metering: rocket fuel is dosed by mass,
-- and a charge that is off by a few per cent is a charge that does not burn
-- evenly.
return {
    type = "recipe",
    name = "fuel-plant",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "steel-plate",      amount = 40 },
        { type = "item", name = "pipe",             amount = 20 },
        { type = "item", name = "iron-gear-wheel",  amount = 15 },
        { type = "item", name = "advanced-circuit", amount = 5 },
    },
    results = {
        { type = "item", name = "fuel-plant", amount = 1 }
    },
}
