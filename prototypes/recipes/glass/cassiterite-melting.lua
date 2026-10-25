-- Cassiterite reduced with coal and run off as liquid tin, in the oil
-- refinery with lava for the heat, as the island melts everything else.
--
-- Five cassiterite and a coal for 60 molten tin, and ten cast a plate: six
-- plates where the furnace makes five. The coal is the reducing agent, as
-- it is in a real tin smelter, and the furnace recipe gets by without it
-- only because it takes the slow way. Most of the melt is for the float
-- bath, which hardly uses any up; the casting recipe is for a base that has
-- the melt to hand and wants plates out of it.
return {
    type = "recipe",
    name = "cassiterite-melting",
    categories = { "oil-processing" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item",  name = "cassiterite", amount = 5 },
        { type = "item",  name = "coal",        amount = 1 },
        { type = "fluid", name = "lava",        amount = 200 },
    },
    results = {
        { type = "fluid", name = "molten-tin", amount = 60 },
    },
    -- Allowed, as on quartz melting: nothing turns tin back into
    -- cassiterite.
    allow_productivity = true,
    subgroup = "lava-block-melts",
    order = "e[glass]-b[cassiterite-melting]",
}
