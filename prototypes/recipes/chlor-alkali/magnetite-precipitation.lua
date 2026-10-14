-- Magnetite out of solution: caustic soda poured into ferric chloride drops
-- the iron as black oxide, and the salt stays behind in the water. It is
-- how the particles in a real ferrofluid are made - far finer than any
-- grinding gives - and the salt water is brine, so it goes back to the
-- cell.
--
-- 60 ferric chloride (three iron plates) and 80 caustic soda for one
-- magnetite and 60 brine, five seconds. Magnetite growing gets two from 50
-- molten iron, ten plates' worth, so five plates each and a crystal hearth;
-- this is three plates and a chemical plant, with a whole chlor-alkali line
-- behind it.
--
-- The loop does not pay for itself. 60 brine back makes 36 caustic soda in
-- the cell, less than half the 80 this takes, so the brine still has to be
-- leached from gravel.
return {
    type = "recipe",
    name = "magnetite-precipitation",
    category = "chemistry",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "fluid", name = "ferric-chloride",  amount = 60 },
        { type = "fluid", name = "sodium-hydroxide", amount = 80 },
    },
    results = {
        { type = "item",  name = "magnetite", amount = 1 },
        -- Productivity multiplies the magnetite only: more brine would be
        -- more chlorine out of nothing.
        { type = "fluid", name = "brine",     amount = 60, ignored_by_productivity = 60 },
    },
    main_product = "magnetite",
    allow_productivity = true,
    -- The second way to magnetite; recycling keeps looking at the first.
    auto_recycle = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/magnetite.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/sodium-hydroxide.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-crystals",
    order = "b[magnetite]-b[precipitation]",
    crafting_machine_tint = {
        primary = { r = 0.20, g = 0.20, b = 0.22, a = 1.0 },
        secondary = { r = 0.75, g = 0.69, b = 0.92, a = 1.0 },
    },
}
