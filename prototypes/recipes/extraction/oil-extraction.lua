local oil_extraction = {
    type = "recipe",
    name = "oil-extraction",
    energy_required = 5,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "steam", amount = 15 },
        { type = "item",  name = "coal",  amount = 12 }
    },
    results = {
        { type = "fluid", name = "crude-oil", amount = 200 }
    },
    icon = "__base__/graphics/icons/fluid/basic-oil-processing.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    order = "a[oil-processing]-a[basic-oil-processing]",
    allow_productivity = true
}
return oil_extraction
