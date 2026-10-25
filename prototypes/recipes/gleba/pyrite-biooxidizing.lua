-- Pyrite biooxidation, the BIOX process: gold locked inside pyrite grains
-- cannot be reached by anything until bacteria eat the pyrite away from
-- round it. The iron and sulfur the bacteria free come out as sulfuric
-- acid.
--
-- A gold plate and 50 sulfuric acid from ten pyrite. Until now gold came
-- only out of anode slime: two plates for every hundred copper refined.
return {
    type = "recipe",
    name = "pyrite-biooxidizing",
    categories = { "ore-bioleaching" },
    enabled = false,
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "pyrite",            amount = 10 },
        { type = "item",  name = "leaching-bacteria", amount = 1 },
        { type = "fluid", name = "water",             amount = 100 },
    },
    results = {
        { type = "item",  name = "gold-plate",    amount = 1 },
        { type = "fluid", name = "sulfuric-acid", amount = 50 },
    },
    main_product = "gold-plate",
    allow_productivity = true,
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
