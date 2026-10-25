-- Lava slag leached by bacteria. Slag is a poor ore - a little of every
-- metal and not much of any - which is what bioleaching is for: a culture
-- works through a heap no furnace would be worth lighting for.
--
-- Two copper and, every other run, a nickel and a zinc from ten slag,
-- straight to plate with no crystal grown first. Much poorer than growing
-- crystals out of the same slag; what it saves is the crystal hearth and
-- the arc furnace.
return {
    type = "recipe",
    name = "slag-bioleaching",
    categories = { "ore-bioleaching" },
    enabled = false,
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "lava-slag",         amount = 10 },
        { type = "item",  name = "leaching-bacteria", amount = 1 },
        { type = "fluid", name = "water",             amount = 100 },
    },
    results = {
        { type = "item", name = "copper-plate", amount = 2 },
        { type = "item", name = "nickel-plate", amount = 1, independent_probability = 0.5 },
        { type = "item", name = "zinc-plate",   amount = 1, independent_probability = 0.5 },
    },
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/parts/lava-slag.png", icon_size = 64 },
        { icon = "__LavaBlock-graphics__/graphics/icons/items/leaching-bacteria.png", icon_size = 64, scale = 0.25, shift = { -8, -8 } },
    },
    subgroup = "agriculture-processes",
    order = "b[agriculture]-d[bacteria]-g[bioleaching]-d[slag]",
    crafting_machine_tint = {
        -- Murky olive: a little of everything.
        primary = { r = 0.52, g = 0.46, b = 0.26, a = 1 },
        secondary = { r = 0.38, g = 0.34, b = 0.20, a = 1 },
    },
}
