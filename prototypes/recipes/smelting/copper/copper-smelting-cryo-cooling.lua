local copper_smelting_cryo_cooling = {
    type = "recipe",
    name = "copper-smelting-cryo-cooling",
    category = "cryogenic-cooling",
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "molten-copper",   amount = 200 },
        { type = "fluid", name = "liquid-nitrogen", amount = 5000 }
    },
    results = {
        { type = "item", name = "copper-plate", amount = 80 }
    },
    icon = "__base__/graphics/icons/copper-plate.png",
    icon_size = 64,
    subgroup = "raw-material",
    order = "c[copper-plate]-c[cryo]"
}

return copper_smelting_cryo_cooling