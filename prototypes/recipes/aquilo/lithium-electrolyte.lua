-- Lithium hexafluorophosphate, made cold in the cryogenic plant: lithium
-- fluorinated to lithium fluoride, phosphorus to phosphorus pentafluoride,
-- and the two together. Thirty fluorine for one lithium and one
-- phosphorus, because six of the eight atoms in the salt are fluorine.
--
-- Fifty electrolyte fills five crafts of cells, ten cells.
return {
    type = "recipe",
    name = "lithium-electrolyte",
    categories = { "cryogenics" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item",  name = "lithium",    amount = 1 },
        { type = "item",  name = "phosphorus", amount = 1 },
        { type = "fluid", name = "fluorine",   amount = 30 },
    },
    results = {
        { type = "fluid", name = "lithium-electrolyte", amount = 50 },
    },
    allow_productivity = true,
    subgroup = "lava-block-solutions",
    order = "q[lithium-electrolyte]",
}
