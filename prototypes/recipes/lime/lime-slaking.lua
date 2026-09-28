-- Quicklime and water. The lumps crack and fall to powder: slaked lime.
--
-- In a chemical plant rather than the pug mill because it is a reaction and
-- not a mix - the pug mill comes in at the next step, where the lime meets
-- the gravel.
return {
    type = "recipe",
    name = "lime-slaking",
    category = "chemistry",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item",  name = "quicklime", amount = 2 },
        { type = "fluid", name = "water",     amount = 50 },
    },
    results = {
        { type = "item", name = "slaked-lime", amount = 2 },
    },
    allow_productivity = true,
}
