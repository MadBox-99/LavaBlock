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
    -- Compressed air and air share one icon, so the corner shows the filter
    -- instead of the input: the same icon twice would say nothing happened.
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/air.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/items/air-filter.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    categories = { "air-filtering" },
    subgroup = "fluid-recipes"
}
return air_electrostatic_adsorption