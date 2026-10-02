-- What a scanner is made of: quartz lenses for the optics, magnetite for
-- the magnets the wafer stage floats on, crystal circuit boards and
-- processing units to steer it, sapphire substrate for the reticle it
-- prints from, and a great deal of steel to hold all of it still.
--
-- It comes without a laser source. That is fed in separately, and it wears.
return {
    type = "recipe",
    name = "lithography-machine",
    enabled = false,
    energy_required = 30,
    ingredients = {
        { type = "item", name = "processing-unit",       amount = 20 },
        { type = "item", name = "crystal-circuit-board", amount = 10 },
        { type = "item", name = "quartz-lens",           amount = 20 },
        { type = "item", name = "magnetite",             amount = 10 },
        { type = "item", name = "sapphire-substrate",    amount = 10 },
        { type = "item", name = "steel-plate",           amount = 100 },
    },
    results = {
        { type = "item", name = "lithography-machine", amount = 1 },
    },
}
