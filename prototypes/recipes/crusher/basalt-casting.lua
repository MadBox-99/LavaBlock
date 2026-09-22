-- Lava quenched into rock. Deliberately a recipe of its own rather than a
-- byproduct bolted onto lava-cooling: a free extra output would have made
-- steam generation strictly better than it is today, and this way the
-- player opts into the stone route instead of being handed it.
--
-- 1000 lava -> 3 basalt -> 6 stone, so 167 lava a stone against the 400 that
-- ore-clearing costs (200 lava an ore, two ores a stone). Cheaper, but it
-- takes two machines, water and power to get there.
return {
    type = "recipe",
    name = "basalt-casting",
    category = "chemistry",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "fluid", name = "lava",  amount = 1000 },
        { type = "fluid", name = "water", amount = 100 },
    },
    results = {
        { type = "item", name = "basalt", amount = 3 }
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__base__/graphics/icons/stone.png",
            icon_size = 64,
            tint = { r = 0.46, g = 0.44, b = 0.50 },
        },
    },
    subgroup = "raw-resource",
    order = "a[basalt]-a[casting]",
}
