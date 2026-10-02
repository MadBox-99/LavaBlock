-- A ruby to lase, lenses to focus it, a crystal circuit board to fire it in
-- time with the droplets, and tin for the nozzle the droplets come out of.
--
-- No diamond, unlike the laser cutter: this is a part the machine burns
-- through, one every fifty crafts, and a diamond in every one of them would
-- make chips a lottery on the crystal hearth.
return {
    type = "recipe",
    name = "laser-source",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "ruby",                  amount = 1 },
        { type = "item", name = "quartz-lens",           amount = 2 },
        { type = "item", name = "crystal-circuit-board", amount = 1 },
        { type = "item", name = "tin-plate",             amount = 4 },
        { type = "item", name = "steel-plate",           amount = 4 },
    },
    results = {
        { type = "item", name = "laser-source", amount = 1 },
    },
}
