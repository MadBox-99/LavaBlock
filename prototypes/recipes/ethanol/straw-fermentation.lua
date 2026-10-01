-- Straw into wash: cellulosic ethanol, the second-generation kind, made
-- from the part of a crop nobody eats.
--
-- One step and not two. Real straw is first broken down to sugar and then
-- fermented, but the way it is done at scale now is both at once in the
-- same vessel - enzymes and yeast together, simultaneous saccharification
-- and fermentation - so a separate sugar-mash fluid would be a pipe the
-- industry itself has stopped building.
--
-- Ten straw is ten seconds of one grass bed in the Arboretum, and a tank
-- takes twenty seconds over it, so one bed feeds two tanks. Straw is the
-- cheap feed: 100 water grows 10 of it, where the same 100 water in the
-- Arboretum is half a tree.
return {
    type = "recipe",
    name = "straw-fermentation",
    categories = { "biomass-fermenting" },
    subgroup = "fluid-recipes",
    order = "b[ethanol]-a[straw-fermentation]",
    enabled = false,
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "straw", amount = 10 },
        { type = "fluid", name = "water", amount = 100 },
    },
    results = {
        { type = "fluid", name = "fermented-wash", amount = 100 },
    },
    -- A better-kept ferment really does turn more of its sugar to alcohol,
    -- the same argument the algae tank makes for growing things.
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/fermented-wash.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/straw.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.80, g = 0.66, b = 0.30, a = 1.0 },
        secondary = { r = 0.92, g = 0.84, b = 0.56, a = 1.0 },
    },
}
