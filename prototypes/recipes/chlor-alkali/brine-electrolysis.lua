-- The chlor-alkali cell: a current through brine gives chlorine at one
-- electrode, hydrogen at the other, and caustic soda left in the water. It
-- is one of the largest electrochemical processes there is.
--
-- In the oil refinery, which has nothing to do with oil here and everything
-- to do with being the one building on the island with three outlets.
--
-- 100 brine for 30 chlorine, 30 hydrogen and 60 sodium hydroxide every five
-- seconds. Chlorine and hydrogen come off one for one, as the equation
-- says, and that is what hydrochloric acid takes, so the two gases need
-- not be balanced by hand. For chlorine alone it is a poor deal: volcanic
-- gas scrubbing gets 40 from 100 lava in three seconds in a chemical plant.
-- What this has over scrubbing is that it needs no centrifuge, and the
-- hydrogen and the caustic soda.
return {
    type = "recipe",
    name = "brine-electrolysis",
    categories = { "oil-processing" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "fluid", name = "brine", amount = 100 },
    },
    results = {
        { type = "fluid", name = "chlorine",         amount = 30 },
        { type = "fluid", name = "hydrogen",         amount = 30 },
        { type = "fluid", name = "sodium-hydroxide", amount = 60 },
    },
    -- Magnetite precipitation hands brine back, so productivity here would
    -- let the loop grow on itself.
    allow_productivity = false,
    allow_quality = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/brine.png",
            icon_size = 64,
            scale = 0.35,
            shift = { 0, -5 },
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/chlorine.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -9, 8 },
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/hydrogen.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 9, 8 },
        },
    },
    subgroup = "lava-block-solutions",
    order = "d[chlor-alkali]-b[brine-electrolysis]",
}
