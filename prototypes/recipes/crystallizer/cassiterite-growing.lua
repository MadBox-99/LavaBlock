-- Slag on the crystal hearth with chlorine blown through it. The chlorine
-- carries the tin out of the melt as a chloride vapour and lets it go again
-- as cassiterite - the way the ore forms over a real granite, and the reason
-- tin deposits sit where volcanic gas has been.
--
-- Its own recipe like magnetite's, and for the same reason: it needs a fluid
-- the random crystal roll does not, and nothing in it is left to chance.
--
-- 20 chlorine is 50 lava from the gas scrubber, next to the 1000 behind the
-- five slag, so the slag is what a tin costs.
return {
    type = "recipe",
    name = "cassiterite-growing",
    category = "lava-crystallizing",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "lava-slag", amount = 5 },
        { type = "fluid", name = "chlorine",  amount = 20 },
    },
    results = {
        { type = "item", name = "cassiterite", amount = 2 },
    },
    crafting_machine_tint = {
        primary = { r = 0.30, g = 0.20, b = 0.12, a = 1.0 },
        secondary = { r = 0.70, g = 0.85, b = 0.30, a = 1.0 },
    },
    allow_productivity = true,
}
