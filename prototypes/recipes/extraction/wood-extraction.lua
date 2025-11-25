local wood_extraction = {
    type = "recipe",
    name = "wood-extraction",
    energy_required = 15,
    enabled = true,
    results = {
        { type = "item", name = "wood", amount = 1 }
    },
    icon = "__base__/graphics/icons/wood.png",
    icon_size = 64,

    category = "crafting",
    subgroup = "raw-material",
}
return wood_extraction
