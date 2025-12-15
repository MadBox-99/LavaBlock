local ore_clearing = {
    type = "recipe",
    name = "ore-clearing",
    energy_required = 1,
    enabled = true,
    ingredients = {
        { type = "item", name = "iron-ore",   amount = 1 },
        { type = "item", name = "copper-ore", amount = 1 }
    },
    results = {
        { type = "item", name = "stone", amount = 1 }
    },
    icon = "__base__/graphics/icons/stone.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    allow_productivity = true,
    allow_quality = false,
}
return ore_clearing
