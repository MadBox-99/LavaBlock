-- The bioleaching reactor, built on Gleba as the biochamber is: the recipe
-- asks for Gleba's pressure, and it starts from a biochamber, whose
-- nutrient feed and climate control it keeps for the culture. Stainless
-- steel for the tanks, which hold the acid the bacteria make; motors for
-- the two mixers and the blower; pipe for the air and the liquor.
return {
    type = "recipe",
    name = "bioleaching-reactor",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "biochamber",            amount = 1 },
        { type = "item", name = "stainless-steel-plate", amount = 30 },
        { type = "item", name = "electric-engine-unit",  amount = 4 },
        { type = "item", name = "pipe",                  amount = 20 },
    },
    results = {
        { type = "item", name = "bioleaching-reactor", amount = 1 },
    },
    surface_conditions = {
        { property = "pressure", min = 2000, max = 2000 },
    },
}
