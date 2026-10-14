-- Steam forced through crushed basalt, coming out as brine. It is what a
-- geothermal well does underground, done in a chemical plant with the rock
-- brought to it.
--
-- Five gravel and 100 steam for 100 brine, five seconds: 20 brine a second,
-- exactly what one refinery's electrolysis takes. The steam is a lava
-- cooling plant and a half, and the gravel is one basalt crushing every
-- three seconds - cheap things, because the cell is where the cost is.
return {
    type = "recipe",
    name = "brine-leaching",
    category = "chemistry",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item",  name = "basalt-gravel", amount = 5 },
        { type = "fluid", name = "steam",         amount = 100 },
    },
    results = {
        { type = "fluid", name = "brine", amount = 100 },
    },
    -- Gravel is made with productivity on the crusher already; more brine
    -- per gravel on top of that would stack two bonuses on one rock.
    allow_productivity = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/brine.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/basalt-gravel.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "d[chlor-alkali]-a[brine-leaching]",
    crafting_machine_tint = {
        primary = { r = 0.37, g = 0.55, b = 0.59, a = 1.0 },
        secondary = { r = 0.60, g = 0.75, b = 0.78, a = 1.0 },
    },
}
