local military_science_pack_2 = {
    type = "tool",
    name = "military-science-pack-2",
    color_hint = {
        text = "M2"
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
            icon = "__base__/graphics/icons/military-science-pack.png",
            icon_size = 64,
            tint = { r = 0.4, g = 0.4, b = 0.4, a = 1 } -- Darkened tint
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
        "item-description.military-science-pack-2"
    },
    pick_sound = {
        aggregation = {
            max_count = 1,
            remove = true
        },
        filename = "__base__/sound/item/science-inventory-move.ogg",
        volume = 0.6
    },
    pictures = {
        layers = {
            {
                filename = "__base__/graphics/icons/military-science-pack.png",
                height = 64,
                scale = 0.5,
                width = 64,
                tint = { r = 0.4, g = 0.4, b = 0.4, a = 1 } -- Darkened tint
            }
        }
    },
    stack_size = 200,
    subgroup = "science-pack",
    order = "a[science-pack]-d[military-science-pack]-b[2]"
}

return military_science_pack_2