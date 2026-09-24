-- Brick and pipe, and not much else. A pit is a lined hole: the bricks hold
-- the shaft open against the melt and the pipes bring the fluid to it. It is
-- cheap on purpose - a sink the player cannot afford is a sink that does not
-- get built, and the running cost is meant to be the pollution, not the
-- construction.
return {
    type = "recipe",
    name = "quench-pit",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "stone-brick",     amount = 30 },
        { type = "item", name = "steel-plate",     amount = 15 },
        { type = "item", name = "pipe",            amount = 20 },
        { type = "item", name = "iron-gear-wheel", amount = 10 },
    },
    results = {
        { type = "item", name = "quench-pit", amount = 1 }
    },
}
