require("prototypes.technologies.stone-item-crafting-productivity")
require("prototypes.technologies.calcite-synthesis-productivity")
require("prototypes.technologies.lava-smelting-productivity")
require("prototypes.technologies.brick-smelting-productivity")
require("prototypes.technologies.foundation-platform-productivity")
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
  {
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
  },
  {
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
  },

  {
    type = "technology",
    name = "advanced-lava-smelting",
    icon = "__base__/graphics/technology/mining-productivity.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "iron-smelting"
      },
      {
        type = "unlock-recipe",
        recipe = "copper-smelting"
      },
      {
        type = "unlock-recipe",
        recipe = "brick-smelting"
      }
    },
    prerequisites = { "chemical-science-pack" },
    unit =
    {
      count = 666,
      ingredients =
      {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 }
      },
      time = 66
    },
    upgrade = true,
    order = "t-q-a"
  },

})
