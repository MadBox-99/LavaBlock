-- Obsidian extraction: only available on Pyroclast (pressure 6000, gravity 60)
-- Volcanic glass forms when lava cools under Pyroclast's extreme pressure
local obsidian_extraction = {
    type = "recipe",
    name = "obsidian-extraction",
    energy_required = 10,
    enabled = false,
    category = "chemistry",
    surface_conditions = {
        { property = "pressure", min = 6000, max = 6000 },
        { property = "gravity",  min = 60,   max = 60   }
    },
    ingredients = {
        { type = "fluid", name = "lava", amount = 500 }
    },
    results = {
        { type = "item", name = "obsidian", amount = 3 }
    },
    icons = {
        {
            icon = "__base__/graphics/icons/coal.png",
            icon_size = 64,
            tint = { r = 0.15, g = 0.1, b = 0.35, a = 1 }
        }
    },
    subgroup = "fluid-recipes",
    order = "z[obsidian-extraction]",
    allow_productivity = true,
}
return obsidian_extraction
