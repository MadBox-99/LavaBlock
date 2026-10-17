-- The Czochralski process: a seed crystal dipped into molten silicon and
-- drawn up so slowly that the melt freezes onto it as one crystal, under
-- argon so nothing in the air gets into it. Every chip-grade wafer starts
-- as one of these boules. The crystal hearth is the island's machine for
-- growing crystal out of a melt, and it has the two inlets this takes.
--
-- 50 molten silicon and 10 argon for 15 wafers, ten seconds. Ten argon is
-- 250 air on the compressor. The arithmetic against the laser cutter is on
-- silica reduction.
--
-- A phosphorus goes into the melt as the dopant: a few atoms in a million
-- give the silicon the spare electrons a chip is printed into.
return {
    type = "recipe",
    name = "silicon-wafer-pulling",
    category = "lava-crystallizing",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "phosphorus",     amount = 1 },
        { type = "fluid", name = "molten-silicon", amount = 50 },
        { type = "fluid", name = "argon",          amount = 10 },
    },
    results = {
        { type = "item", name = "silicon-wafer", amount = 15 },
    },
    allow_productivity = true,
    -- Wafers keep recycling into silica crystal.
    auto_recycle = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/silicon-wafer.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-silicon.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "z[lavablock]-i[silicon-wafer]-b[pulling]",
    crafting_machine_tint = {
        primary = { r = 0.35, g = 0.39, b = 0.53, a = 1.0 },
        secondary = { r = 0.66, g = 0.24, b = 0.67, a = 1.0 },
    },
}
