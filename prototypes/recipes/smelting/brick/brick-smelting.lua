local brick_smelting = {
    type = "recipe",
    name = "brick-smelting",
    energy_required = 3,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 10000 }
    },
    results = {
        { type = "item", name = "stone-brick", amount = 2 }
    },
    icon = "__base__/graphics/icons/stone-brick.png",
    category = "chemistry",
    subgroup = "fluid-recipes",
    allow_productivity = true
}
return brick_smelting