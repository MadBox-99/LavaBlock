local liquid_nitrogen_production = {
    type = "recipe",
    name = "liquid-nitrogen-production",
    category = "cryogenic-cooling",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "fluid", name = "lava", amount = 100 },
        { type = "fluid", name = "water", amount = 100 }
    },
    results = {
        { type = "fluid", name = "liquid-nitrogen", amount = 50 }
    },
    icon = "__LavaBlock__/graphics/icons/liquid_nitrogen.png",
    icon_size = 32,
    subgroup = "fluid-recipes",
    order = "a[fluid-chemistry]-d[liquid-nitrogen]"
}

return liquid_nitrogen_production
