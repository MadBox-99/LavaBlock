-- What the crusher is for.
--
-- Two passes, not one. A single basalt-to-stone recipe made the crusher a
-- machine you bolt to a belt and forget; splitting it gives the rock line a
-- shape - a first bank of crushers breaking basalt down to gravel and a
-- second grinding the gravel to stone, with something moving between them.
--
-- The yield is unchanged end to end: two basalt still make four stone. This
-- is a longer chain, not a more expensive one, and the cost of the extra
-- step is the second machine and the belt between - which is the part worth
-- building.
return {
    {
        type = "recipe",
        name = "basalt-crushing",
        categories = { "rock-crushing" },
        enabled = false,
        energy_required = 2,
        ingredients = {
            { type = "item", name = "basalt", amount = 2 }
        },
        results = {
            { type = "item", name = "basalt-gravel", amount = 3 }
        },
        allow_productivity = true,
        main_product = "basalt-gravel",
        subgroup = "raw-resource",
        order = "a[basalt]-b[crushing]",
    },
    {
        type = "recipe",
        name = "gravel-grinding",
        categories = { "rock-crushing" },
        enabled = false,
        energy_required = 2,
        ingredients = {
            { type = "item", name = "basalt-gravel", amount = 3 }
        },
        results = {
            { type = "item", name = "stone", amount = 4 }
        },
        allow_productivity = true,
        main_product = "stone",
        icon = "__base__/graphics/icons/stone.png",
        icon_size = 64,
        subgroup = "raw-resource",
        order = "a[basalt]-c[grinding]",
    },
    {
        -- The industrial machine's own category, so only it can run this.
        -- Half again as much stone out of the same gravel, paid for in
        -- lubricant - which is why that machine is worth the oil line.
        type = "recipe",
        name = "gravel-grinding-oiled",
        categories = { "rock-crushing-oiled" },
        enabled = false,
        energy_required = 2,
        ingredients = {
            { type = "item",  name = "basalt-gravel", amount = 3 },
            { type = "fluid", name = "lubricant",     amount = 10 },
        },
        results = {
            { type = "item", name = "stone", amount = 6 }
        },
        allow_productivity = true,
        main_product = "stone",
        icon = "__base__/graphics/icons/stone.png",
        icon_size = 64,
        subgroup = "raw-resource",
        order = "a[basalt]-d[grinding-oiled]",
    },
    {
        -- The oiled grind with studded rolls: cemented carbide studs set in
        -- the drums, as on a real high-pressure grinding roll, so the rock
        -- breaks on the studs and the bed of rock caught between them
        -- instead of wearing the drum. Two more stone than the oiled grind
        -- out of the same gravel.
        --
        -- The studs wear out: a carbide comes back 99 times in 100, so an
        -- industrial crusher grinding non-stop eats one about every two
        -- minutes.
        -- That is the price, and it is paid in Vulcanus's tungsten. The
        -- returned carbide is left out of productivity, so productivity
        -- only multiplies the stone.
        type = "recipe",
        name = "gravel-grinding-studded",
        categories = { "rock-crushing-oiled" },
        enabled = false,
        energy_required = 2,
        ingredients = {
            { type = "item",  name = "basalt-gravel",    amount = 3 },
            { type = "item",  name = "cemented-carbide", amount = 1 },
            { type = "fluid", name = "lubricant",        amount = 10 },
        },
        results = {
            { type = "item", name = "stone",            amount = 8 },
            { type = "item", name = "cemented-carbide", amount = 1, independent_probability = 0.99, ignored_by_productivity = 1 },
        },
        main_product = "stone",
        allow_productivity = true,
        auto_recycle = false,
        icon = "__base__/graphics/icons/stone.png",
        icon_size = 64,
        subgroup = "raw-resource",
        order = "a[basalt]-d[grinding-studded]",
    },
    {
        -- Cryogenic lava cooling hands back ten stone brick half the time,
        -- and a base running that recipe at any scale drowns in brick it
        -- has nothing to do with. This turns the surplus back into the
        -- thing land expansion actually eats.
        --
        -- It goes straight to stone rather than into the gravel line, and
        -- that is a safety rule, not a shortcut. Routed through gravel it
        -- would pick up the grinding step's productivity, and 4 stone -> 2
        -- brick -> 2 gravel -> 2.67 stone stops being a loss the moment
        -- that productivity passes fifty percent. As a one-step recipe with
        -- productivity refused, the round trip is a loss at every level and
        -- cannot be farmed.
        type = "recipe",
        name = "brick-crushing",
        categories = { "rock-crushing" },
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
        order = "a[basalt]-e[brick-crushing]",
    },
}
