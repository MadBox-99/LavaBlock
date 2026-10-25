data:extend({
    {
        type = "item-group",
        name = "chemistry",
        order = "d",
        inventory_order = "ad",
        icon = "__space-age__/graphics/technology/research-productivity.png",
        icon_size = 256,
    },
    -- Lava Centrifuge recipes subgroup (in intermediate-products)
    {
        type = "item-subgroup",
        name = "lava-centrifuge-recipes",
        group = "intermediate-products",
        order = "m"
    },
    {
        type = "item-subgroup",
        name = "chemical-plants",
        group = "chemistry",
        order = "a"
    },
    -- The island's fluid recipes, one row per production line, in the order
    -- the factory is built. They sat in vanilla's single fluid-recipes row in
    -- the intermediate tab, where ninety recipes from a dozen chains read as
    -- one undivided wall.
    {
        type = "item-subgroup",
        name = "lava-block-lava-extraction",
        group = "chemistry",
        order = "b-a"
    },
    {
        type = "item-subgroup",
        name = "lava-block-lava-smelting",
        group = "chemistry",
        order = "b-b"
    },
    {
        type = "item-subgroup",
        name = "lava-block-air",
        group = "chemistry",
        order = "b-c"
    },
    {
        type = "item-subgroup",
        name = "lava-block-volcanic-gas",
        group = "chemistry",
        order = "b-d"
    },
    {
        type = "item-subgroup",
        name = "lava-block-solutions",
        group = "chemistry",
        order = "b-e"
    },
    {
        type = "item-subgroup",
        name = "lava-block-organics",
        group = "chemistry",
        order = "b-f"
    },
    {
        type = "item-subgroup",
        name = "lava-block-noble-gases",
        group = "chemistry",
        order = "b-g"
    },
    {
        type = "item-subgroup",
        name = "lava-block-melts",
        group = "chemistry",
        order = "b-h"
    },
    {
        type = "item-subgroup",
        name = "lava-block-metal-melts",
        group = "chemistry",
        order = "b-i"
    },
    {
        type = "item-subgroup",
        name = "lava-block-alloy-melts",
        group = "chemistry",
        order = "b-j"
    },
    {
        type = "item-subgroup",
        name = "gas-separation",
        group = "chemistry",
        order = "a"
    }
    ,
    {
        type = "item-subgroup",
        name = "gas-processing",
        group = "chemistry",
        order = "a"
    },
    {
        type = "item-subgroup",
        name = "chemical-products",
        group = "chemistry",
        order = "b"
    },
    {
        type = "item-subgroup",
        name = "advanced-chemicals",
        group = "chemistry",
        order = "c"
    },
    {
        type = "item-subgroup",
        name = "rocket-fuel",
        group = "chemistry",
        order = "d"
    },
    {
        type = "item-subgroup",
        name = "space-chemicals",
        group = "chemistry",
        order = "e"
    },
    {
        type = "item-subgroup",
        name = "chemical-intermediates",
        group = "chemistry",
        order = "f"
    },
    {
        type = "item-subgroup",
        name = "chemical-catalysts",
        group = "chemistry",
        order = "g"
    },
    {
        type = "item-subgroup",
        name = "chemical-solvents",
        group = "chemistry",
        order = "h"
    },
    {
        type = "item-subgroup",
        name = "chemical-acids",
        group = "chemistry",
        order = "i"
    },
    {
        type = "item-subgroup",
        name = "chemical-bases",
        group = "chemistry",
        order = "j"
    },
    {
        type = "item-subgroup",
        name = "chemical-salts",
        group = "chemistry",
        order = "k"
    },
    {
        type = "item-subgroup",
        name = "polymer-chemicals",
        group = "chemistry",
        order = "l"
    },
    {
        type = "item-subgroup",
        name = "biochemicals",
        group = "chemistry",
        order = "m"
    },
    {
        type = "item-subgroup",
        name = "nanochemicals",
        group = "chemistry",
        order = "n"
    },
    {
        type = "item-subgroup",
        name = "chemical-pyrolysis",
        group = "chemistry",
        order = "o"
    },
    {
        -- Last in the group on purpose. These are the recipes that destroy
        -- rather than make, and there is one for every fluid in the game -
        -- put anywhere but the end they would bury the chemistry the player
        -- actually came here for.
        type = "item-subgroup",
        name = "fluid-quenching",
        group = "chemistry",
        order = "z"
    }

})