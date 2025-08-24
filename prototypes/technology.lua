data:extend({
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
    name = "lava-smelting-productivity-3",
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
    prerequisites = { "lava-smelting-productivity-2" },
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
    name = "lava-smelting-productivity-4",
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
    prerequisites = { "lava-smelting-productivity-3" },
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
    name = "lava-smelting-productivity-2",
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
    prerequisites = { "lava-smelting-productivity-1" },
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
    name = "lava-smelting-productivity-1",
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
    prerequisites = { "advanced-lava-smelting" },
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
  }
})
