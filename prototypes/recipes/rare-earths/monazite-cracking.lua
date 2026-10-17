-- Monazite dissolved in hydrochloric acid and its rare earths separated out
-- of the solution, one from the next, by solvent extraction. The phosphate
-- the ore is made of comes out as phosphorus.
--
-- Four monazite and 40 acid for two cerium, one neodymium, a yttrium one
-- craft in two and a phosphorus: cerium is about half of a monazite's rare
-- earths and neodymium a fifth, and yttrium is the scarce one.
return {
    type = "recipe",
    name = "monazite-cracking",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "item",  name = "monazite",          amount = 4 },
        { type = "fluid", name = "hydrochloric-acid", amount = 40 },
    },
    results = {
        { type = "item", name = "cerium",     amount = 2 },
        { type = "item", name = "neodymium",  amount = 1 },
        { type = "item", name = "yttrium",    amount = 1, independent_probability = 0.5 },
        { type = "item", name = "phosphorus", amount = 1 },
    },
    allow_productivity = true,
    crafting_machine_tint = {
        primary = { r = 0.84, g = 0.80, b = 0.50, a = 1.0 },
        secondary = { r = 0.66, g = 0.60, b = 0.86, a = 1.0 },
    },
    icon = "__LavaBlock-graphics__/graphics/icons/parts/monazite.png",
    icon_size = 64,
    subgroup = "raw-material",
    order = "c[element]-a[monazite-cracking]",
}
