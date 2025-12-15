local calcite_processing_on_lava_block = {
    type = "technology",
    name = "calcite-processing-on-lava-block",
    icon = "__space-age__/graphics/technology/calcite-processing.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "acid-neutralisation" },
        { type = "unlock-recipe", recipe = "steam-condensation" },
        { type = "unlock-recipe", recipe = "simple-coal-liquefaction" },
        { type = "unlock-recipe", recipe = "chemical-plant" }
    },
    research_trigger = {
        type = "craft-item",
        item = "offshore-pump",
        count = 1
    },
    prerequisites = { "offshore-pump-on-lava-block" },
    order = "a-b-c"
}
return calcite_processing_on_lava_block
