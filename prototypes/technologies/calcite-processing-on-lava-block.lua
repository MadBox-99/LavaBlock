-- Acid neutralisation and simple coal liquefaction are not here: both eat
-- sulfuric acid, which does not exist until Sulfur processing, so they sat
-- in the menu for most of red and green science with nothing to feed them.
-- Liquefaction moved to Sulfur processing; neutralisation is Vulcanus-only
-- (pressure 4000) and vanilla Calcite processing unlocks it there.
local calcite_processing_on_lava_block = {
    type = "technology",
    name = "calcite-processing-on-lava-block",
    icon = "__space-age__/graphics/technology/calcite-processing.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "steam-condensation" },
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
