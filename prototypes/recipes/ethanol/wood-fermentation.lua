-- Wood into wash. The same cellulose as straw, locked up in lignin that has
-- to be broken open first, so it is the dear feed: five logs are ten
-- megajoules on a fire, and here they give twelve and a half as ethanol -
-- a little more, and liquid, which is the only reason to do it.
--
-- It exists for a base with orchards and no grass beds, and for anyone
-- whose wood is piling up faster than the boilers can burn it.
return {
    type = "recipe",
    name = "wood-fermentation",
    categories = { "biomass-fermenting" },
    subgroup = "fluid-recipes",
    order = "b[ethanol]-b[wood-fermentation]",
    enabled = false,
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "wood",  amount = 5 },
        { type = "fluid", name = "water", amount = 100 },
    },
    results = {
        { type = "fluid", name = "fermented-wash", amount = 100 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/fermented-wash.png",
            icon_size = 64,
        },
        {
            icon = "__base__/graphics/icons/wood.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.62, g = 0.42, b = 0.22, a = 1.0 },
        secondary = { r = 0.80, g = 0.62, b = 0.40, a = 1.0 },
    },
}
