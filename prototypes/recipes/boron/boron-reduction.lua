-- Borax reduced with magnesium in the arc furnace: Moissan's way to boron,
-- the magnesium taking the oxygen. Boron melts at over two thousand
-- degrees and comes out as a powder, not a melt, so nothing goes to the
-- tap.
--
-- Two borax and a magnesium plate for two boron.
return {
    type = "recipe",
    name = "boron-reduction",
    category = "arc-smelting",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "borax",           amount = 2 },
        { type = "item", name = "magnesium-plate", amount = 1 },
    },
    results = {
        { type = "item", name = "boron", amount = 2 },
    },
    allow_productivity = true,
}
