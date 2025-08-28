data.raw.recipe['burner-mining-drill'].enabled = false

local lava_cooling = {
    type = "recipe",
    name = "lava-cooling",
    energy_required = 5,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 100 }
    },
    results = {
        { type = "fluid", name = "steam", amount = 70, temperature = 165 }
    },
    icon = "__LavaBlock__/graphics/icons/lava-cooling.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
}

local calcite_synthesis = {
    type = "recipe",
    name = "calcite-synthesis",
    energy_required = 1,
    enabled = true,
    ingredients = {
        { type = "item",  name = "coal",        amount = 20 },
        { type = "item",  name = "stone-brick", amount = 40 },
        { type = "fluid", name = "lava",        amount = 5000 },
    },
    results = {
        { type = "item", name = "calcite", amount = 10 }
    },
    icon = "__space-age__/graphics/icons/calcite.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    surface_conditions = { { property = "pressure", min = 1000, max = 1000 }, { property = "gravity", min = 10, max = 10 } },
}


local steam_generation = {
    type = "recipe",
    name = "steam-generation",
    energy_required = 1,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 5000 },
        { type = "item",  name = "wood", amount = 1 },
        { type = "item",  name = "coal", amount = 5 }

    },
    results = {
        { type = "fluid", name = "steam", amount = 5000, temperature = 165 }
    },
    icon = "__base__/graphics/icons/fluid/steam.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
}

local brick_smelting = {
    type = "recipe",
    name = "brick-smelting",
    energy_required = 3,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 10000 }
    },
    results = {
        { type = "item", name = "stone-brick", amount = 2 }
    },
    icon = "__LavaBlock__/graphics/icons/brick-smelt.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    allow_productivity = true
}
local wood_extraction = {
    type = "recipe",
    name = "wood-extraction",
    energy_required = 15,
    enabled = true,
    results = {
        { type = "item", name = "wood", amount = 1 }
    },
    icon = "__base__/graphics/icons/wood.png",
    icon_size = 64,

    category = "crafting",
    subgroup = "raw-material",
}

local coal_extraction = {
    type = "recipe",
    name = "coal-extraction",
    energy_required = 4,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 1000 }
    },
    results = {
        { type = "item", name = "coal", amount = 5 }
    },
    icon = "__base__/graphics/icons/coal.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes"
}

local iron_extraction = {
    type = "recipe",
    name = "iron-extraction",
    energy_required = 4,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 1000 },
    },
    results = {
        { type = "item", name = "iron-ore", amount = 5 }
    },
    icon = "__base__/graphics/icons/iron-ore.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
}

local iron_smelting = {
    type = "recipe",
    name = "iron-smelting",
    energy_required = 3,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "lava",     amount = 10000 },
        { type = "item",  name = "iron-ore", amount = 1 }
    },
    results = {
        { type = "item", name = "iron-plate", amount = 2 }
    },
    icon = "__LavaBlock__/graphics/icons/iron-lava-smelt.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    allow_productivity = true,
    allow_quality = false,
}

local copper_smelting = {
    type = "recipe",
    name = "copper-smelting",
    energy_required = 3,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "lava",       amount = 10000 },
        { type = "item",  name = "copper-ore", amount = 1 }
    },
    results = {
        { type = "item", name = "copper-plate", amount = 2 }
    },
    icon = "__LavaBlock__/graphics/icons/iron-lava-smelt.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    allow_productivity = true,
    allow_quality = false,

}

local copper_extraction = {
    type = "recipe",
    name = "copper-extraction",
    energy_required = 4,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 1000 },
    },
    results = {
        { type = "item", name = "copper-ore", amount = 5 }
    },
    icon = "__base__/graphics/icons/copper-ore.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
}


local ore_clearing = {
    type = "recipe",
    name = "ore-clearing",
    energy_required = 1,
    enabled = true,
    ingredients = {
        { type = "item", name = "iron-ore",   amount = 1 },
        { type = "item", name = "copper-ore", amount = 1 }
    },
    results = {
        { type = "item", name = "stone", amount = 1 }
    },
    icon = "__base__/graphics/icons/stone.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    allow_productivity = true,
    allow_quality = false,
}

data:extend({
    lava_cooling,
    calcite_synthesis,
    steam_generation,
    ore_clearing,
    brick_smelting,
    wood_extraction,
    coal_extraction,
    iron_extraction,
    iron_smelting,
    copper_extraction,
    copper_smelting,
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
