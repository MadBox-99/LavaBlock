-- Slag skimmed off standing lava, and left to set in the air.
--
-- No water, which is the whole difference from basalt casting: quenched,
-- lava freezes into basalt; let it stand and the heavy dross sinks out of it
-- and can be raked off. A chemical plant rather than the quench pit, because
-- the pit's one job is to destroy what it is fed and a recipe that made
-- something there would make it a different building.
--
-- 200 lava a slag. Both lines that use it are several steps long, so the
-- first step is kept plain.
return {
    type = "recipe",
    name = "lava-slag-skimming",
    category = "chemistry",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "fluid", name = "lava", amount = 1000 },
    },
    results = {
        { type = "item", name = "lava-slag", amount = 5 },
    },
    allow_productivity = true,
    subgroup = "raw-resource",
    order = "a[basalt]-g[lava-slag]",
}
