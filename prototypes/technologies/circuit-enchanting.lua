-- Basic Circuit Enchanting (uses fusioning-lava, 40->41)
local basic = {
    type = "technology",
    name = "circuit-enchanting-basic",
    icon = "__base__/graphics/technology/circuit-network.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "electronic-circuit-enchanting-basic"
        },
        {
            type = "unlock-recipe",
            recipe = "advanced-circuit-enchanting-basic"
        },
        {
            type = "unlock-recipe",
            recipe = "processing-unit-enchanting-basic"
        }
    },
    prerequisites = { "enchanter" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "lava-science-pack",       2 }
        },
        time = 30
    },
}

-- Advanced Circuit Enchanting (uses stronger-fusioning-lava, 20->22)
local advanced = {
    type = "technology",
    name = "circuit-enchanting-advanced",
    icon = "__base__/graphics/technology/advanced-circuit.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "electronic-circuit-enchanting-advanced"
        },
        {
            type = "unlock-recipe",
            recipe = "advanced-circuit-enchanting-advanced"
        },
        {
            type = "unlock-recipe",
            recipe = "processing-unit-enchanting-advanced"
        }
    },
    prerequisites = { "circuit-enchanting-basic" },
    unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       3 }
        },
        time = 45
    },
}

-- Ultimate Circuit Enchanting (uses enchanted-lava, 10->13)
local ultimate = {
    type = "technology",
    name = "circuit-enchanting-ultimate",
    icon = "__base__/graphics/technology/processing-unit.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "electronic-circuit-enchanting-ultimate"
        },
        {
            type = "unlock-recipe",
            recipe = "advanced-circuit-enchanting-ultimate"
        },
        {
            type = "unlock-recipe",
            recipe = "processing-unit-enchanting-ultimate"
        }
    },
    prerequisites = { "circuit-enchanting-advanced" },
    unit = {
        count = 1000,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "production-science-pack", 1 },
            { "lava-science-pack",       5 }
        },
        time = 60
    },
}

return { basic, advanced, ultimate }
