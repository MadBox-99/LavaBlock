-- The basic oxygen converter: oxygen blown through molten iron burns the
-- carbon out of it, and the melt turns to steel in minutes. A chemical
-- plant stands in for the vessel.
--
-- 100 molten iron and 20 oxygen for 100 molten steel, and 25 cast a steel
-- plate: four plates from 100 molten iron. Cooled to iron plate first, the
-- same 100 is twenty plates, which the furnace takes five at a time for a
-- steel - four again. So the iron is the same either way. What the
-- converter saves is the furnace, 16 seconds a plate, and the cooling step;
-- what it costs is the oxygen, a hundred water through electrolysis for
-- every five converter loads.
--
-- Nauvis only, like the cooling recipes for molten iron. On Vulcanus the
-- foundry already casts steel from molten iron, and this must not undercut
-- it there.
return {
    type = "recipe",
    name = "steel-converting",
    category = "chemistry",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "molten-iron", amount = 100 },
        { type = "fluid", name = "oxygen",      amount = 20 },
    },
    results = {
        { type = "fluid", name = "molten-steel", amount = 100 },
    },
    -- One melt into another; productivity would be iron out of nothing.
    allow_productivity = false,
    allow_quality = false,
    surface_conditions = {
        { property = "pressure", min = 1000, max = 1000 },
        { property = "gravity",  min = 10,   max = 10 },
    },
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-steel.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/oxygen.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "f[steel]-a[steel-converting]",
    crafting_machine_tint = {
        primary = { r = 1.00, g = 0.88, b = 0.16, a = 1.0 },
        secondary = { r = 0.28, g = 0.57, b = 0.80, a = 1.0 },
    },
}
