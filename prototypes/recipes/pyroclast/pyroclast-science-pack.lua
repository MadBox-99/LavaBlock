-- Pyroclast Science Pack: late-game science pack crafted only on Pyroclast
-- Requires obsidian (unique to Pyroclast) + advanced components + lava
local pyroclast_science_pack = {
    type = "recipe",
    name = "pyroclast-science-pack",
    energy_required = 30,
    enabled = false,
    category = "crafting-with-fluid",
    surface_conditions = {
        { property = "pressure", min = 6000, max = 6000 },
        { property = "gravity",  min = 60,   max = 60   }
    },
    ingredients = {
        { type = "item",  name = "obsidian",          amount = 5    },
        { type = "item",  name = "lava-science-pack",  amount = 3    },
        { type = "item",  name = "processing-unit",    amount = 2    },
        { type = "fluid", name = "lava",               amount = 2000 }
    },
    results = {
        { type = "item", name = "pyroclast-science-pack", amount = 2 }
    },
    icons = {
        {
            icon = "__base__/graphics/icons/production-science-pack.png",
            icon_size = 64,
            tint = { r = 0.7, g = 0.15, b = 0.05, a = 1 }
        }
    },
    subgroup = "science-pack",
    order = "a[pyroclast-science-pack]",
    allow_productivity = true,
}
return pyroclast_science_pack
