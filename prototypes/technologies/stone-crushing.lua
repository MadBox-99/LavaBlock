-- The rock line, in five steps.
--
-- It used to be three, and the first of them handed over four recipes and a
-- machine at once - casting, crushing, brick reclamation and the crusher
-- itself all fell out of one research. That is a lot to drop on a player in
-- one go and it wasted the shape of the line: casting lava into basalt and
-- grinding basalt into stone are two different ideas, and the brick recycler
-- is a side door that has nothing to do with either.
--
-- Split apart they arrive one at a time, each one cheap, and the order they
-- arrive in is the order they are used in.
--
-- The machine technologies carry a picture of the machine they hand over,
-- rendered from the same model by `--pass tech` (see docs/blender-renders.md).
-- The two that hand over a recipe rather than a building borrow an icon, as
-- the rest of the mod's recipe technologies do.
return {
    {
        -- First, because there is no rock to crush until lava has been
        -- quenched into some. Deliberately early and cheap: everything
        -- downstream waits on it.
        type = "technology",
        name = "basalt-casting",
        icon = "__LavaBlock-graphics__/graphics/lava-cooling-tech-icon-small.png",
        icon_size = 128,
        effects = {
            { type = "unlock-recipe", recipe = "basalt-casting" },
        },
        prerequisites = { "logistic-science-pack" },
        unit = {
            count = 50,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
            },
            time = 30
        },
        order = "a-c-a"
    },
    {
        -- The machine and the two passes it runs. Early on purpose: land
        -- expansion is available from the first minute and its stone bill is
        -- the largest single cost in the mod, so the answer to it should not
        -- sit behind chemical science - and the machine it hands over burns
        -- fuel, so it does not wait for a power network either.
        type = "technology",
        name = "stone-crushing",
        icon = "__LavaBlock-graphics__/graphics/technology/stone-crushing.png",
        icon_size = 256,
        effects = {
            { type = "unlock-recipe", recipe = "crusher-roll" },
            { type = "unlock-recipe", recipe = "burner-roll-crusher" },
            { type = "unlock-recipe", recipe = "basalt-crushing" },
            { type = "unlock-recipe", recipe = "gravel-grinding" },
        },
        prerequisites = { "basalt-casting" },
        unit = {
            count = 80,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
            },
            time = 30
        },
        order = "a-c-b"
    },
    {
        -- A side door, and it waits its turn. You only want it once
        -- cryogenic lava cooling is running and the brick is piling up, and
        -- until then it is a recipe in the menu doing nothing.
        type = "technology",
        name = "brick-reclamation",
        icon = "__base__/graphics/icons/stone-brick.png",
        icon_size = 64,
        effects = {
            { type = "unlock-recipe", recipe = "brick-crushing" },
        },
        prerequisites = { "stone-crushing" },
        unit = {
            count = 100,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
            },
            time = 30
        },
        order = "a-c-c"
    },
    {
        -- Twice the speed for a power line and two module slots. The burner
        -- keeps working; this is what you build once the grid can carry it.
        type = "technology",
        name = "powered-rock-crushing",
        icon = "__LavaBlock-graphics__/graphics/technology/powered-rock-crushing.png",
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
        order = "a-c-d"
    },
    {
        -- Waits for lubricant, which on this island means the oil line is
        -- already running. In exchange the oiled grind gets half again as
        -- much stone out of the same gravel.
        type = "technology",
        name = "lubricated-rock-crushing",
        icon = "__LavaBlock-graphics__/graphics/technology/lubricated-rock-crushing.png",
        icon_size = 256,
        effects = {
            { type = "unlock-recipe", recipe = "industrial-roll-crusher" },
            { type = "unlock-recipe", recipe = "gravel-grinding-oiled" },
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
        order = "a-c-e"
    },
}
