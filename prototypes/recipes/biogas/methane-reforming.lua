-- Steam reforming: methane and steam over hot nickel come apart into
-- hydrogen and carbon monoxide, three to one, CH4 + H2O -> CO + 3 H2. Most
-- of the world's hydrogen is made this way.
--
-- 50 methane and 50 steam for 150 hydrogen and 50 carbon monoxide, two
-- seconds. Light oil synthesis takes the two at two to one, so a third of
-- the hydrogen is left over: that is the hydrogen this line is for, and
-- what diamond synthesis and hydrochloric acid draw on.
return {
    type = "recipe",
    name = "methane-reforming",
    category = "chemistry",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "methane", amount = 50 },
        { type = "fluid", name = "steam",   amount = 50 },
    },
    results = {
        { type = "fluid", name = "hydrogen",        amount = 150 },
        { type = "fluid", name = "carbon-monoxide", amount = 50 },
    },
    -- Gases into gases; productivity would be matter from nothing.
    allow_productivity = false,
    allow_quality = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/hydrogen.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/methane.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "b[ethanol]-h[methane-reforming]",
    crafting_machine_tint = {
        primary = { r = 0.96, g = 0.59, b = 0.20, a = 1.0 },
        secondary = { r = 0.80, g = 0.94, b = 1.00, a = 1.0 },
    },
}
