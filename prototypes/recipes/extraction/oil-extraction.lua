-- Crude oil out of coal and steam. It gave 200 crude every 5 seconds,
-- which is four pumpjacks in one chemical plant at about 12 lava a unit,
-- and made the whole oil line nearly free once coal was flowing. A quarter
-- of that at half the speed puts crude at about 48 lava and one plant at
-- half a pumpjack, so oil is something a base builds for rather than a
-- side effect of having coal.
local oil_extraction = {
    type = "recipe",
    name = "oil-extraction",
    energy_required = 10,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "steam", amount = 15 },
        { type = "item",  name = "coal",  amount = 12 }
    },
    results = {
        { type = "fluid", name = "crude-oil", amount = 50 }
    },
    icon = "__base__/graphics/icons/fluid/basic-oil-processing.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    order = "a[oil-processing]-a[basic-oil-processing]",
    allow_productivity = true
}
return oil_extraction
