data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["coal"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["stone"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["uranium-ore"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["iron-ore"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["copper-ore"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["crude-oil"] = nil
data.raw["fluid"]["lava"].fuel_value = "25kJ"
data.raw["assembling-machine"]["assembling-machine-3"].crafting_categories =
{
    "basic-crafting",
    "crafting",
    "advanced-crafting",
    "crafting-with-fluid",
    "electronics",
    "electronics-with-fluid",
    "pressing",
    "metallurgy-or-assembling",
    "organic-or-hand-crafting",
    "organic-or-assembling",
    "electronics-or-assembling",
    "cryogenics-or-assembling",
    "crafting-with-fluid-or-metallurgy",
    "smelting",
    "chemistry",
    "gas",
}

-- Modify artillery shell recipe to use Pyroclast materials (bmat + cmat)
data.raw.recipe["artillery-shell"].ingredients = {
    { type = "item",  name = "explosive-cannon-shell", amount = 4 },
    { type = "item",  name = "explosives",             amount = 8 },
    { type = "item",  name = "bmat",                   amount = 10 },
    { type = "item",  name = "cmat",                   amount = 5 },
    { type = "fluid", name = "lava",                   amount = 500 },
}
data.raw.recipe["artillery-shell"].energy_required = 10
data.raw.recipe["artillery-shell"].category = "crafting-with-fluid"

-- Modify radar recipe (100x batch, lava + electronic-circuit)
data.raw.recipe["radar"].ingredients = {
    { type = "item",  name = "electronic-circuit", amount = 500 },
    { type = "fluid", name = "lava",               amount = 100000 },
}
data.raw.recipe["radar"].results = {
    { type = "item", name = "radar", amount = 100 },
}
data.raw.recipe["radar"].category = "crafting-with-fluid"

-- Modify railgun turret recipe (add lava)
table.insert(data.raw.recipe["railgun-turret"].ingredients, {
    type = "fluid", name = "lava", amount = 100
})
data.raw.recipe["railgun-turret"].category = "crafting-with-fluid"

table.insert(data.raw["technology"]["bacteria-cultivation"].effects, {
    type = "unlock-recipe",
    recipe = "uranium-bacteria-cultivation"
})

table.insert(data.raw["technology"]["jellynut"].effects, {
    type = "unlock-recipe",
    recipe = "uranium-bacteria"
})

-- Space Age: Replace asteroid-productivity with separate simple and advanced versions
if mods["space-age"] then
    require("helpers.functions")
    -- Remove the original asteroid-productivity technology completely
    remove_technology("asteroid-productivity")
end