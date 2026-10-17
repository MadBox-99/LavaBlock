-- A ruby to lase, lenses to focus it, a crystal circuit board to fire it in
-- time with the droplets, and tin for the nozzle the droplets come out of.
-- The ruby is pumped by a xenon flash tube wrapped round it, as the first
-- laser was in 1960: 20 xenon fills it, so the recipe takes a fluid and an
-- assembler with a fluid input.
--
-- No diamond, unlike the laser cutter: this is a part the machine burns
-- through, one every fifty crafts, and a diamond in every one of them would
-- make chips a lottery on the crystal hearth.
return {
    type = "recipe",
    name = "laser-source",
    categories = { "crafting-with-fluid" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "ruby",                  amount = 1 },
        { type = "item",  name = "quartz-lens",           amount = 2 },
        { type = "item",  name = "crystal-circuit-board", amount = 1 },
        { type = "item",  name = "tin-plate",             amount = 4 },
        { type = "item",  name = "steel-plate",           amount = 4 },
        { type = "fluid", name = "xenon",                 amount = 20 },
    },
    results = {
        { type = "item", name = "laser-source", amount = 1 },
    },
}
