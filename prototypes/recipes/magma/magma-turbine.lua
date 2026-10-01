-- Fifteen tiles of turbine and generator. Four geothermal turbines go into
-- it - a machine that grew out of the smaller one - and the generator's
-- field magnets are magnetite, a hundred of them.
return {
    type = "recipe",
    name = "magma-turbine",
    enabled = false,
    energy_required = 60,
    ingredients = {
        { type = "item", name = "geo-thermal-turbine",   amount = 4 },
        { type = "item", name = "magnetite",             amount = 100 },
        { type = "item", name = "crystal-circuit-board", amount = 10 },
        { type = "item", name = "processing-unit",       amount = 50 },
        { type = "item", name = "copper-plate",          amount = 200 },
        { type = "item", name = "refined-concrete",      amount = 150 },
        { type = "item", name = "steel-plate",           amount = 300 },
    },
    results = {
        { type = "item", name = "magma-turbine", amount = 1 },
    },
}
