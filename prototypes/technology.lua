require("prototypes.technologies.stone-item-crafting-productivity")
require("prototypes.technologies.calcite-synthesis-productivity")
require("prototypes.technologies.lava-smelting-productivity")
require("prototypes.technologies.brick-smelting-productivity")
require("prototypes.technologies.foundation-platform-productivity")
require("prototypes.technologies.advanced-lava-smelting-productivity")
local advanced_lava_cooling = require("prototypes.technologies.advanced-lava-cooling")
data.raw.technology["oil-processing"].research_trigger = { type = "craft-fluid", fluid = "crude-oil", amount = 1 }
data.raw.technology["uranium-processing"].research_trigger = { type = "craft-item", item = "uranium-ore" }
data.raw.technology["oil-gathering"].effects = { { type = "unlock-recipe", recipe = "oil-extraction" } }
data.raw.technology["uranium-mining"].effects = {
  { type = "mining-with-fluid", modifier = true },
  { type = "unlock-recipe",     recipe = "uranium-extraction" }
}


data:extend({
  advanced_lava_cooling,
  require("prototypes.technologies.offshore-pump-on-lava-block"),
  require("prototypes.technologies.calcite-processing-on-lava-block"),
  require("prototypes.technologies.advanced-lava-smelting"),
  require("prototypes.technologies.air-cooler")
})
