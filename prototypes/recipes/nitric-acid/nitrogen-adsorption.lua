-- Pressure swing adsorption: compressed air through a bed of carbon sieve
-- that holds the oxygen back and lets the nitrogen through. Every
-- nitrogen generator on a factory floor works this way, and it is a
-- filter's job, so it runs on the air filter beside the electrostatic one.
--
-- 500 compressed air for 300 nitrogen, two seconds. Air is four fifths
-- nitrogen; the sieve lets some of it go with the oxygen it vents. 500
-- compressed air is one air compressor craft, 100 steam.
return {
    type = "recipe",
    name = "nitrogen-adsorption",
    categories = { "air-filtering" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "compressed-air", amount = 500 },
    },
    results = {
        { type = "fluid", name = "nitrogen", amount = 300 },
    },
    -- The air filter takes no productivity modules, and gas into gas would
    -- not deserve them.
    allow_productivity = false,
    allow_quality = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/nitrogen.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/items/air-filter.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-air",
    order = "a[gas]-b[nitrogen]-a[nitrogen-adsorption]",
}
