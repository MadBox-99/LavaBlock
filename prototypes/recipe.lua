data:extend({
    {
        type = "recipe",
        name = "stone-extraction",
        energy_required = 4,
        enabled = true,
        ingredients = {
            { type = "fluid", name = "lava", amount = 50 }
        },
        results = {
            { type = "item", name = "stone", amount = 5 }
        },
        icon = "__base__/graphics/icons/stone.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
    },
    {
        type = "recipe",
        name = "brick-smelting",
        energy_required = 3.2,
        enabled = false,
        ingredients = {
            { type = "fluid", name = "lava", amount = 100 }
        },
        results = {
            { type = "item", name = "stone-brick", amount = 2 }
        },
        icon = "__LavaBlock__/graphics/icons/brick-smelt.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "wood-extraction",
        energy_required = 5,
        enabled = true,
        ingredients = {
            { type = "fluid", name = "lava", amount = 50 }
        },
        results = {
            { type = "item", name = "wood", amount = 5 }
        },
        icon = "__base__/graphics/icons/wood.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes"
    },
    {
        type = "recipe",
        name = "coal-extraction",
        energy_required = 4,
        enabled = true,
        ingredients = {
            { type = "fluid", name = "lava", amount = 50 },
        },
        results = {
            { type = "item", name = "coal", amount = 5 }
        },
        icon = "__base__/graphics/icons/coal.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
    },
    {
        type = "recipe",
        name = "iron-extraction",
        energy_required = 5,
        enabled = true,
        ingredients = {
            { type = "fluid", name = "lava", amount = 75 },
        },
        results = {
            { type = "item", name = "iron-ore", amount = 5 }
        },
        icon = "__base__/graphics/icons/iron-ore.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
    },
    {
        type = "recipe",
        name = "iron-smelting",
        energy_required = 3.2,
        enabled = false,
        ingredients = {
            { type = "fluid", name = "lava", amount = 100 }
        },
        results = {
            { type = "item", name = "iron-plate", amount = 2 }
        },
        icon = "__LavaBlock__/graphics/icons/iron-smelt.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "copper-extraction",
        energy_required = 5,
        enabled = true,
        ingredients = {
            { type = "fluid", name = "lava", amount = 75 },
        },
        results = {
            { type = "item", name = "copper-ore", amount = 5 }
        },
        icon = "__base__/graphics/icons/copper-ore.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
    },
    {
        type = "recipe",
        name = "copper-smelting",
        energy_required = 3.2,
        enabled = false,
        ingredients = {
            { type = "fluid", name = "lava", amount = 100 }
        },
        results = {
            { type = "item", name = "copper-plate", amount = 2 }
        },
        icon = "__LavaBlock__/graphics/icons/copper-smelt.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "oil-extraction",
        energy_required = 5,
        enabled = false,
        ingredients = {
            { type = "fluid", name = "steam", amount = 15 },
            { type = "item",  name = "coal",  amount = 12 }
        },
        results = {
            { type = "fluid", name = "crude-oil", amount = 200 }
        },
        icon = "__base__/graphics/icons/fluid/basic-oil-processing.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
        order = "a[oil-processing]-a[basic-oil-processing]",
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "uranium-extraction",
        energy_required = 10,
        enabled = false,
        ingredients = {
            { type = "item",  name = "stone",         amount = 10 },
            { type = "fluid", name = "sulfuric-acid", amount = 20 }
        },
        results = {
            { type = "item", name = "uranium-ore", amount = 5 }
        },
        icon = "__base__/graphics/icons/uranium-ore.png",
        icon_size = 64,
        category = "chemistry",
        subgroup = "fluid-recipes",
        allow_productivity = true
    },

})
