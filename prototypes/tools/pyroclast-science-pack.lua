local pyroclast_science_pack = {
    type = "tool",
    name = "pyroclast-science-pack",
    color_hint = {
        text = "P"
    },
    drop_sound = {
        aggregation = {
            max_count = 1,
            remove = true
        },
        filename = "__base__/sound/item/science-inventory-move.ogg",
        volume = 0.6
    },
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount-key",
    durability_description_value = "description.science-pack-remaining-amount-value",
    factoriopedia_durability_description_key = "description.factoriopedia-science-pack-remaining-amount-key",
    icons = {
        {
            icon = "__base__/graphics/icons/production-science-pack.png",
            icon_size = 64,
            tint = { r = 0.7, g = 0.15, b = 0.05, a = 1 } -- deep volcanic red/orange
        }
    },
    inventory_move_sound = {
        aggregation = {
            max_count = 1,
            remove = true
        },
        filename = "__base__/sound/item/science-inventory-move.ogg",
        volume = 0.6
    },
    localised_description = {
        "item-description.science-pack"
    },
    order = "a[pyroclast-science-pack]",
    pick_sound = {
        aggregation = {
            max_count = 1,
            remove = true
        },
        filename = "__base__/sound/item/science-inventory-pickup.ogg",
        volume = 0.6
    },
    random_tint_color = { 0.9, 0.3, 0.1, 1 },
    stack_size = 200,
    subgroup = "science-pack",
    weight = 1000
}
return pyroclast_science_pack
