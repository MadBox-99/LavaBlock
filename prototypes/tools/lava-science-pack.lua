local lava_science_pack = {
    type = "tool",
    name = "lava-science-pack",
    color_hint = {
        text = "A"
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
    -- Recoloured from the vanilla utility pack by tools/icons/make_science_pack.py,
    -- which keeps the steel collar and only warms the glass. A prototype
    -- `tint` cannot do that - it multiplies the whole layer, which is why
    -- the XP and circuit packs have coloured collars.
    --
    -- icon_size was missing here while the file was a 120x64 mipmap strip,
    -- so Factorio read the leading 64x64 and carried 56 dead pixels. The
    -- file is a plain 64x64 now and 2.0 builds its own mipmaps.
    icon = "__LavaBlock-graphics__/graphics/icons/lava-science-pack.png",
    icon_size = 64,
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
    order = "a[lava-science-pack]",
    pick_sound = {
        aggregation = {
            max_count = 1,
            remove = true
        },
        filename = "__base__/sound/item/science-inventory-pickup.ogg",
        volume = 0.6
    },
    random_tint_color = {
        0.92,
        0.97,
        0.97,
        1
    },
    stack_size = 200,
    subgroup = "science-pack",
    weight = 1000
}
return lava_science_pack