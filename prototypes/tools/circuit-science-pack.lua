local circuit_science_pack = {
    -- A plain item, not a tool: Factorio 2.1 made vanilla's science packs
    -- items and lets labs take any item.
    type = "item",
    name = "circuit-science-pack",
    color_hint = {
        text = "C"
    },
    drop_sound = {
        aggregation = {
            max_count = 1,
            remove = true
        },
        filename = "__base__/sound/item/science-inventory-move.ogg",
        volume = 0.6
    },
    icons = {
        {
            icon = "__base__/graphics/icons/production-science-pack.png",
            icon_size = 64,
            tint = { r = 0.2, g = 0.8, b = 0.3, a = 1 } -- Green tint for circuits
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
        "item-description.circuit-science-pack"
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
                filename = "__base__/graphics/icons/production-science-pack.png",
                height = 64,
                scale = 0.5,
                width = 64,
                tint = { r = 0.2, g = 0.8, b = 0.3, a = 1 } -- Green tint for circuits
            }
        }
    },
    stack_size = 200,
    subgroup = "science-pack",
    order = "a[science-pack]-e[circuit-science-pack]"
}

return circuit_science_pack