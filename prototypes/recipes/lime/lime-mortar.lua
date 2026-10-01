-- Slaked lime, gravel and a little water, worked together in the pug mill -
-- the machine the island already mixes its adobe in.
return {
    type = "recipe",
    name = "lime-mortar",
    categories = { "adobe-mixing" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "slaked-lime",   amount = 2 },
        { type = "item",  name = "basalt-gravel", amount = 4 },
        { type = "fluid", name = "water",         amount = 20 },
    },
    results = {
        { type = "item", name = "lime-mortar", amount = 4 },
    },
    allow_productivity = true,
}
