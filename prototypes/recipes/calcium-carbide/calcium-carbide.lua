-- Quicklime and coal fused in the arc furnace at two thousand degrees into
-- calcium carbide; the coal's third carbon leaves as carbon monoxide up
-- the offtake.
--
-- Two quicklime and three coal for two carbide and 20 carbon monoxide.
-- The gas is fuel for the fuel plant's light oil, and otherwise the quench
-- pit takes it.
--
-- No productivity: the acetylene leaves slaked lime, which the lime line
-- turns back into quicklime, so extra carbide would be lime for nothing.
return {
    type = "recipe",
    name = "calcium-carbide",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "quicklime", amount = 2 },
        { type = "item", name = "coal",      amount = 3 },
    },
    results = {
        { type = "item",  name = "calcium-carbide", amount = 2 },
        { type = "fluid", name = "carbon-monoxide", amount = 20, fluidbox_index = 2 },
    },
    main_product = "calcium-carbide",
    allow_productivity = false,
}
