-- Chemical vapour deposition: a little methane in a lot of hydrogen, lit
-- into a plasma over a diamond seed, and the carbon settles onto it as
-- more diamond, a layer of atoms at a time. Lab-grown diamonds are made
-- this way. The crystal hearth is the island's machine for growing crystal,
-- and it has the two inlets this takes.
--
-- 20 methane and 100 hydrogen for a diamond, thirty seconds - slow, as the
-- real thing is. The hydrogen is two reformers' leftover, so a diamond
-- costs about 53 methane, a little over ten straw. Crystal growing rolls a
-- diamond one craft in twenty, 200 seconds of hearth time, but brings the
-- other four crystals with it; this brings nothing else.
return {
    type = "recipe",
    name = "diamond-depositing",
    category = "lava-crystallizing",
    enabled = false,
    energy_required = 30,
    ingredients = {
        { type = "fluid", name = "methane",  amount = 20 },
        { type = "fluid", name = "hydrogen", amount = 100 },
    },
    results = {
        { type = "item", name = "diamond", amount = 1 },
    },
    -- Allowed, as on every recipe the hearth runs. Diamonds crush to gravel
    -- and nothing more, so there is nothing to farm.
    allow_productivity = true,
    -- Diamonds keep recycling the way they did.
    auto_recycle = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/diamond.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/methane.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-crystals",
    order = "f[diamond]-b[depositing]",
    crafting_machine_tint = {
        primary = { r = 0.80, g = 0.94, b = 1.00, a = 1.0 },
        secondary = { r = 0.96, g = 0.59, b = 0.20, a = 1.0 },
    },
}
