local extract_copper_from_air = {
    type = "recipe",
    name = "extract-copper-from-air",
    energy_required = 1,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "air", amount = 1000 }
    },
    results = {
        { type = "item", name = "copper-ore", amount = 1 }
    },
    icon = "__base__/graphics/icons/copper-ore.png",
    icon_size = 64,
    category = "gas-mix",
    subgroup = "fluid-recipes"
}

local extract_iron_from_air = {
    type = "recipe",
    name = "extract-iron-from-air",
    energy_required = 1,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "air", amount = 1000 }
    },
    results = {
        { type = "item", name = "iron-ore", amount = 1 }
    },
    icon = "__base__/graphics/icons/iron-ore.png",
    icon_size = 64,
    category = "gas-mix",
    subgroup = "fluid-recipes"
}

return { extract_copper_from_air, extract_iron_from_air }
