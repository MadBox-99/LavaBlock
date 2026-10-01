-- Coal burned for its flue gas, which is mostly carbon dioxide once the
-- ash and the water are out of it.
--
-- It makes no steam and no power. Coal burned in a boiler already does that,
-- and a recipe that did both would be the cheapest power station on the
-- island by accident. This one is for the gas.
return {
    type = "recipe",
    name = "coal-combustion",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item", name = "coal", amount = 2 },
    },
    results = {
        { type = "fluid", name = "carbon-dioxide", amount = 100 },
    },
    allow_productivity = true,
    subgroup = "lava-block-lime",
    order = "0[b-combustion]",
}
