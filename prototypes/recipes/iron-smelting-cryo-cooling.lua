local iron_smelting_cryo_cooling = {
    type = "recipe",
    name = "iron-smelting-cryo-cooling",
    category = "cryogenic-cooling",
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "molten-iron", amount = 200 },
        { type = "fluid", name = "liquid-nitrogen", amount = 50 }
    },
    results = {
        { type = "item", name = "iron-plate", amount = 8 }
    },
    icon = "__base__/graphics/icons/iron-plate.png",
    icon_size = 64,
    subgroup = "raw-material",
    order = "b[iron-plate]-c[cryo]"
}

return iron_smelting_cryo_cooling
