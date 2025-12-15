local offshore_pump_on_lava_block = {
    type = "technology",
    name = "offshore-pump-on-lava-block",
    icon = "__base__/graphics/icons/offshore-pump.png",
    icon_size = 64,
    effects = {
        { type = "unlock-recipe", recipe = "offshore-pump" },
    },
    research_trigger =
    {
        type = "craft-item",
        item = "wood",
        count = 1
    },
    order = "a-b-c"
}
return offshore_pump_on_lava_block
