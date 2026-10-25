-- Pyrite biooxidation, the BIOX process: gold locked inside pyrite grains
-- cannot be reached by anything until bacteria eat the pyrite away from
-- round it. The iron and sulfur the bacteria free come out as sulfuric
-- acid.
--
-- A gold plate and 50 sulfuric acid from five pyrite. Until now gold came
-- only out of anode slime: two plates for every hundred copper refined.
--
-- Anode slime stays the cheaper gold. This is where pyrite goes when the
-- crystal hearth grows more of it than the circuit boards take - gold and
-- acid instead of gravel from the crusher. At ten pyrite it was a sink
-- nobody would use; at five it pays for the bacteria.
--
-- Six seconds a run, not twenty. At twenty the reactor's own time cost more
-- than the furnace and acid it saves, and every bioleaching recipe made
-- dearer metal than the island's routes did.
return {
    type = "recipe",
    name = "pyrite-biooxidizing",
    categories = { "ore-bioleaching" },
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "item",  name = "pyrite",            amount = 5 },
        { type = "item",  name = "leaching-bacteria", amount = 1 },
        { type = "fluid", name = "water",             amount = 100 },
    },
    results = {
        { type = "item",  name = "gold-plate",    amount = 1 },
        { type = "fluid", name = "sulfuric-acid", amount = 50 },
    },
    main_product = "gold-plate",
    allow_productivity = true,
    -- Gold recycles into gold. Without this the recycler took this recipe
    -- as gold's own and handed back pyrite and bacteria.
    auto_recycle = false,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/parts/gold-plate.png", icon_size = 64 },
        { icon = "__LavaBlock-graphics__/graphics/icons/items/leaching-bacteria.png", icon_size = 64, scale = 0.25, shift = { -8, -8 } },
    },
    subgroup = "agriculture-processes",
    order = "b[agriculture]-d[bacteria]-g[bioleaching]-c[pyrite]",
    crafting_machine_tint = {
        -- Ferric sulfate, rust red.
        primary = { r = 0.72, g = 0.30, b = 0.10, a = 1 },
        secondary = { r = 0.50, g = 0.22, b = 0.08, a = 1 },
    },
}
