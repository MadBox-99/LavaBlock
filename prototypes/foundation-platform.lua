local foundation_platform = table.deepcopy(data.raw["item"]["foundation"])
foundation_platform.name = "foundation-platform-nauvis"


local recipe = {
    type = "recipe",
    name = "foundation-platform-nauvis",
    energy_required = 10,
    enabled = true,
    category = "crafting-with-fluid",
    ingredients =
    {
        { type = "item",  name = "landfill",     amount = 10 },
        { type = "item",  name = "calcite",      amount = 100 },
        { type = "item",  name = "iron-plate",   amount = 100 },
        { type = "item",  name = "copper-plate", amount = 100 },
        { type = "item",  name = "stone-brick",  amount = 100 },
        { type = "item",  name = "stone",        amount = 200 },
        { type = "fluid", name = "lava",         amount = 20000 }
    },
    results = { { type = "item", name = "foundation-platform-nauvis", amount = 1 } },
}


data:extend { foundation_platform, recipe }
