local air_extraction = {
    type = "recipe",
    name = "air-electrostatic-adsorption",
    energy_required = 4,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "compressed-air", amount = 500 }
    },
    results = {
        { type = "fluid", name = "air", amount = 100 }
    },
    icon = "__LavaBlock__/graphics/recipes/electrostatic-adsorption.png",
    icon_size = 128,
    category = "gas",
    subgroup = "fluid-recipes"
}
data:extend({ air_extraction })