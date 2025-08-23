data:extend({
  {
    type = "technology",
    name = "calcite-processing-on-lava-block",
    icon = "__space-age__/graphics/technology/calcite-processing.png",
    icon_size = 256,
    effects = {
      { type = "unlock-recipe", recipe = "acid-neutralisation" },
      { type = "unlock-recipe", recipe = "steam-condensation" },
      { type = "unlock-recipe", recipe = "simple-coal-liquefaction" }
    },
    research_trigger =
    {
      type = "craft-item",
      item = "offshore-pump",
      count = 1
    },
    order = "a-b-c"
  },
  {
    type = "technology",
    name = "water-smelting-productivity-3",
    icon = "__base__/graphics/technology/mining-productivity.png",
    icon_size = 256,
    effects = {
      {
        type = "change-recipe-productivity",
        recipe = "iron-smelting",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "copper-smelting",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "brick-smelting",
        change = 0.1
      }
    },
    prerequisites = { "water-smelting-productivity-2" },
    unit = {
      count = 1500,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 },
        { "production-science-pack", 1 },
        { "utility-science-pack",    1 }
      },
      time = 60
    },
    upgrade = true,
  },
  {
    type = "technology",
    name = "water-smelting-productivity-4",
    icon = "__base__/graphics/technology/mining-productivity.png",
    icon_size = 256,
    effects = {
      {
        type = "change-recipe-productivity",
        recipe = "iron-smelting",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "copper-smelting",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "brick-smelting",
        change = 0.1
      }
    },
    prerequisites = { "water-smelting-productivity-3" },
    unit = {
      count_formula = "2500*(L - 3)",
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 },
        { "production-science-pack", 1 },
        { "utility-science-pack",    1 },
        { "space-science-pack",      1 }
      },
      time = 60
    },
    max_level = "infinite",
    upgrade = true,
  },
  {
    type = "technology",
    name = "water-smelting-productivity-2",
    icon = "__base__/graphics/technology/mining-productivity.png",
    icon_size = 256,
    effects = {
      {
        type = "change-recipe-productivity",
        recipe = "iron-smelting",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "copper-smelting",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "brick-smelting",
        change = 0.1
      }
    },
    prerequisites = { "water-smelting-productivity-1" },
    unit = {
      count = 1000,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 },
        { "production-science-pack", 1 },
        { "utility-science-pack",    1 }
      },
      time = 60
    },
    upgrade = true,
  },
  {
    type = "technology",
    name = "water-smelting-productivity-1",
    icon = "__base__/graphics/technology/mining-productivity.png",
    icon_size = 256,
    effects = {
      {
        type = "change-recipe-productivity",
        recipe = "iron-smelting",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "copper-smelting",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "brick-smelting",
        change = 0.1
      }
    },
    prerequisites = { "advanced-water-smelting" },
    unit =
    {
      count = 250,
      ingredients =
      {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 }
      },
      time = 60
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "advanced-water-smelting",
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
    prerequisites = { "utility-science-pack", "chemical-science-pack" },
    unit =
    {
      count = 600,
      ingredients =
      {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 },
        { "production-science-pack", 1 },
        { "utility-science-pack",    1 }
      },
      time = 90
    },
    upgrade = true,
    order = "i-q-a"
  },
  {
    type = "technology",
    name = "mining-productivity-1",
    icons = util.technology_icon_constant_productivity("__base__/graphics/technology/mining-productivity.png"),
    effects = {
      {
        type = "mining-drill-productivity-bonus",
        modifier = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "stone-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "coal-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "iron-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "copper-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "oil-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "uranium-extraction",
        change = 0.1
      }
    },
    prerequisites = { "advanced-circuit" },
    unit =
    {
      count = 250,
      ingredients =
      {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 }
      },
      time = 60
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "mining-productivity-2",
    icons = util.technology_icon_constant_productivity("__base__/graphics/technology/mining-productivity.png"),
    effects =
    {
      {
        type = "mining-drill-productivity-bonus",
        modifier = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "stone-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "coal-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "iron-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "copper-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "oil-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "uranium-extraction",
        change = 0.1
      }
    },
    prerequisites = { "mining-productivity-1", "chemical-science-pack" },
    unit =
    {
      count = 500,
      ingredients =
      {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 }
      },
      time = 60
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "mining-productivity-3",
    icons = util.technology_icon_constant_productivity("__base__/graphics/technology/mining-productivity.png"),
    effects =
    {
      {
        type = "mining-drill-productivity-bonus",
        modifier = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "stone-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "coal-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "iron-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "copper-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "oil-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "uranium-extraction",
        change = 0.1
      }
    },
    prerequisites = { "mining-productivity-2", "production-science-pack", "utility-science-pack" },
    unit =
    {
      count = 1000,
      ingredients =
      {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 },
        { "production-science-pack", 1 },
        { "utility-science-pack",    1 }
      },
      time = 60
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "mining-productivity-4",
    icons = util.technology_icon_constant_productivity("__base__/graphics/technology/mining-productivity.png"),
    effects =
    {
      {
        type = "mining-drill-productivity-bonus",
        modifier = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "stone-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "coal-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "iron-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "copper-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "oil-extraction",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "uranium-extraction",
        change = 0.1
      }
    },
    prerequisites = { "mining-productivity-3", "space-science-pack" },
    unit =
    {
      count_formula = "2500*(L - 3)",
      ingredients =
      {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "chemical-science-pack",   1 },
        { "production-science-pack", 1 },
        { "utility-science-pack",    1 },
        { "space-science-pack",      1 }
      },
      time = 60
    },
    max_level = "infinite",
    upgrade = true
  },
})
