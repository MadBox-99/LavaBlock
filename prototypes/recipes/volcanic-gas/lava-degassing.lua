-- A hood over a pan of lava, drawing off the gas it gives up as it stands.
--
-- Five hundred lava for fifty gas, five seconds: ten gas a second from one
-- chemical plant. The oil refinery splits a hundred every five seconds,
-- twenty a second, so two plants feed one refinery. Lava is the one thing
-- the island has without limit, so the cost is the plant and its power, not
-- the melt.
--
-- Not folded into volcanic gas scrubbing, which pulls chlorine out of the
-- same vent in one step: that recipe is the centrifuge era's and asks for
-- nothing but lava, and routing it through this gas would make the chlorine
-- line wait on a refinery for no gain.
return {
    type = "recipe",
    name = "lava-degassing",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "fluid", name = "lava", amount = 500 },
    },
    results = {
        { type = "fluid", name = "volcanic-gas", amount = 50 },
    },
    -- One fluid into another: productivity would be free matter, and quality
    -- does nothing on a fluid-only recipe.
    allow_productivity = false,
    allow_quality = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/volcanic-gas.png",
            icon_size = 64,
        },
        {
            icon = "__space-age__/graphics/icons/fluid/lava.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-volcanic-gas",
    order = "c[volcanic-gas]-a[lava-degassing]",
    crafting_machine_tint = {
        primary = { r = 0.65, g = 0.37, b = 0.24, a = 1.0 },
        secondary = { r = 0.92, g = 0.84, b = 0.39, a = 1.0 },
    },
}
