-- Three steps, because the crusher itself comes in three.
--
-- Each carries a picture of the machine it hands over, rendered from the same
-- model by `--pass tech` (see docs/blender-renders.md). Three borrowed
-- base-game icons said "steel", "power" and "lubricant" - true of the
-- prerequisites and nothing at all about what the technology gives you.
--
-- The first is early on purpose. Land expansion is available from the first
-- minute and its stone bill is the largest single cost in the mod, so the
-- answer to it should not sit behind chemical science - and the machine it
-- hands over burns fuel, so it does not wait for a power network either.
return {
    {
        type = "technology",
        name = "stone-crushing",
        icon = "__LavaBlock__/graphics/technology/stone-crushing.png",
        icon_size = 256,
        effects = {
            { type = "unlock-recipe", recipe = "burner-roll-crusher" },
            { type = "unlock-recipe", recipe = "basalt-casting" },
            { type = "unlock-recipe", recipe = "basalt-crushing" },
            { type = "unlock-recipe", recipe = "brick-crushing" },
        },
        prerequisites = { "logistic-science-pack" },
        unit = {
            count = 80,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
            },
            time = 30
        },
        order = "a-b-b"
    },
    {
        -- Twice the speed for a power line and two module slots. The burner
        -- keeps working; this is what you build once the grid can carry it.
        type = "technology",
        name = "powered-rock-crushing",
        icon = "__LavaBlock__/graphics/technology/powered-rock-crushing.png",
        icon_size = 256,
        effects = {
            { type = "unlock-recipe", recipe = "roll-crusher" },
        },
        prerequisites = { "stone-crushing", "electronics" },
        unit = {
            count = 120,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
            },
            time = 30
        },
        upgrade = true,
        order = "a-b-c"
    },
    {
        -- Waits for lubricant, which on this island means the oil line is
        -- already running. In exchange the oiled recipe gets half again as
        -- much stone out of the same basalt.
        type = "technology",
        name = "lubricated-rock-crushing",
        icon = "__LavaBlock__/graphics/technology/lubricated-rock-crushing.png",
        icon_size = 256,
        effects = {
            { type = "unlock-recipe", recipe = "industrial-roll-crusher" },
            { type = "unlock-recipe", recipe = "basalt-crushing-oiled" },
        },
        prerequisites = { "powered-rock-crushing", "lubricant" },
        unit = {
            count = 250,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
            },
            time = 30
        },
        upgrade = true,
        order = "a-b-d"
    },
}
