-- Charge a plate, run the air past it, and the dust falls out. This has
-- always been in the mod; what changed is where it runs. It sat on the air
-- compressor, which meant one building compressed the air, filtered it and
-- then pulled the metal back out of it - three jobs the mod separates
-- everywhere else. It is a filter's work, so it belongs to the filter.
local air_electrostatic_adsorption = {
    type = "recipe",
    name = "air-electrostatic-adsorption",
    energy_required = 2,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "compressed-air", amount = 500 }
    },
    results = {
        { type = "fluid", name = "air", amount = 500 }
    },
    icon = "__LavaBlock-graphics__/graphics/recipes/electrostatic-adsorption.png",
    icon_size = 128,
    category = "air-filtering",
    subgroup = "fluid-recipes"
}
return air_electrostatic_adsorption