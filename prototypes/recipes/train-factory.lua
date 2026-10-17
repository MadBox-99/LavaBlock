-- Brick for the shop, steel for its frame and the track, gears and engines
-- for the four robots, circuits to drive them and pumps for the lava line
-- to the foundry.
--
-- Nothing here is past Railway, which hands it over: the factory is the
-- only place a train can be built, so it must not arrive after the trains.
return {
    type = "recipe",
    name = "train-factory",
    enabled = false,
    energy_required = 30,
    ingredients = {
        { type = "item", name = "stone-brick",        amount = 100 },
        { type = "item", name = "steel-plate",        amount = 100 },
        { type = "item", name = "iron-gear-wheel",    amount = 100 },
        { type = "item", name = "engine-unit",        amount = 10 },
        { type = "item", name = "electronic-circuit", amount = 30 },
        { type = "item", name = "pump",               amount = 2 },
    },
    results = {
        { type = "item", name = "train-factory", amount = 1 },
    },
}
