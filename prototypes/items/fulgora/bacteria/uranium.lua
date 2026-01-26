local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")

local uranium_bacteria = {
    type = "item",
    name = "uranium-bacteria",
    icon = "__LavaBlock__/graphics/icons/items/uranium-bacteria.png",
    icon_size = 64,
    pictures =
    {
        { size = 64, filename = "__LavaBlock__/graphics/icons/items/uranium-bacteria.png",   scale = 0.5, mipmap_count = 4 },
        { size = 64, filename = "__LavaBlock__/graphics/icons/items/uranium-bacteria-2.png", scale = 0.5, mipmap_count = 4 }
    },
    subgroup = "agriculture-processes",
    order = "b[agriculture]-e[uranium-bacteria]",
    inventory_move_sound = space_age_item_sounds.agriculture_inventory_move,
    pick_sound = space_age_item_sounds.agriculture_inventory_pickup,
    drop_sound = space_age_item_sounds.agriculture_inventory_move,
    stack_size = 50,
    default_import_location = "gleba",
    weight = 1 * kg,
    spoil_ticks = 1 * minute,
    spoil_result = "uranium-ore"
}

data:extend({ uranium_bacteria })