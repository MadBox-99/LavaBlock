-- A solar panel built from silicon wafers, which is what solar cells are.
--
-- The glass-and-crystal recipe costs twelve silica crystals a panel - five
-- glass at two each, and two loose. This one costs three, cut into six
-- wafers, plus less steel, copper and circuit. That is the payoff for the
-- laser line, and it is deliberately a large one.
return {
    type = "recipe",
    name = "solar-panel-from-wafers",
    categories = { "crafting", "electromagnetics" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "silicon-wafer",      amount = 6 },
        { type = "item", name = "steel-plate",        amount = 5 },
        { type = "item", name = "electronic-circuit", amount = 10 },
        { type = "item", name = "copper-plate",       amount = 5 },
    },
    results = {
        { type = "item", name = "solar-panel", amount = 1 },
    },
    -- The recycler undoes an item's last recipe. Solar panels keep recycling
    -- into what the main recipe takes, not into wafers.
    auto_recycle = false,
    icons = {
        { icon = "__base__/graphics/icons/solar-panel.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/silicon-wafer.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "energy",
    order = "d[solar-panel]-b[from-wafers]",
}
