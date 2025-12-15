local lava_cooling_with_liquid_nitrogen = {
    type = "recipe",
    name = "lava-cooling-with-liquid-nitrogen",
    category = "cryogenic-cooling",
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "lava",            amount = 3000 },
        { type = "fluid", name = "liquid-nitrogen", amount = 10 }
    },
    results = {
        { type = "fluid", name = "steam",        amount = 2000, temperature = 1000 },
        { type = "item",  name = "stone-brick",  amount = 10,   probability = 0.8 },
        { type = "item",  name = "calcite",      amount = 5,    probability = 0.1 },
        { type = "item",  name = "iron-plate",   amount = 20,   probability = 0.2 },
        { type = "item",  name = "copper-plate", amount = 20,   probability = 0.2 }
    },
    icon = "__LavaBlock__/graphics/icons/lava-cooling.png",
    icon_size = 64,
    subgroup = "fluid-recipes",
    order = "a[fluid-chemistry]-e[lava-cooling-with-liquid-nitrogen]"

}
return lava_cooling_with_liquid_nitrogen