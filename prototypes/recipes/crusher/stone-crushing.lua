-- What the crusher is for.
return {
    {
        type = "recipe",
        name = "basalt-crushing",
        category = "rock-crushing",
        enabled = false,
        energy_required = 2,
        ingredients = {
            { type = "item", name = "basalt", amount = 2 }
        },
        results = {
            { type = "item", name = "stone", amount = 4 }
        },
        allow_productivity = true,
        main_product = "stone",
        icon = "__base__/graphics/icons/stone.png",
        icon_size = 64,
        subgroup = "raw-resource",
        order = "a[basalt]-b[crushing]",
    },
    {
        -- Cryogenic lava cooling hands back ten stone brick half the time,
        -- and a base running that recipe at any scale drowns in brick it
        -- has nothing to do with. This turns the surplus back into the
        -- thing land expansion actually eats.
        --
        -- It cannot be farmed: vanilla smelts 2 stone into 1 brick, so the
        -- round trip is 4 stone -> 2 brick -> 3 stone, a loss either way
        -- round.
        type = "recipe",
        name = "brick-crushing",
        category = "rock-crushing",
        enabled = false,
        energy_required = 2,
        ingredients = {
            { type = "item", name = "stone-brick", amount = 2 }
        },
        results = {
            { type = "item", name = "stone", amount = 3 }
        },
        main_product = "stone",
        icon = "__base__/graphics/icons/stone.png",
        icon_size = 64,
        subgroup = "raw-resource",
        order = "a[basalt]-c[brick-crushing]",
    },
    {
        -- The industrial machine's own category, so only it can run this.
        -- Half again as much stone out of the same basalt, paid for in
        -- lubricant - which is why that machine is worth the oil line.
        --
        -- There is deliberately no oiled version of brick-crushing. At four
        -- stone out of two brick the round trip would break even, and with
        -- productivity on top it would print stone from nothing.
        type = "recipe",
        name = "basalt-crushing-oiled",
        category = "rock-crushing-oiled",
        enabled = false,
        energy_required = 2,
        ingredients = {
            { type = "item",  name = "basalt",    amount = 2 },
            { type = "fluid", name = "lubricant", amount = 10 },
        },
        results = {
            { type = "item", name = "stone", amount = 6 }
        },
        allow_productivity = true,
        main_product = "stone",
        icon = "__base__/graphics/icons/stone.png",
        icon_size = 64,
        subgroup = "raw-resource",
        order = "a[basalt]-d[crushing-oiled]",
    },
}
