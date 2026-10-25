-- The cell assembly line, built on Aquilo as the cryogenic plant is: the
-- recipe asks for Aquilo's thin air, and the line's rollers and dry room
-- are lined with lithium, which only Aquilo has. Stainless steel for the
-- frames, motors for the reels, the winder and the conveyor, and
-- processing units for the formation rack, which charges every cell one by
-- one.
return {
    type = "recipe",
    name = "cell-assembly-line",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "lithium-plate",         amount = 20 },
        { type = "item", name = "stainless-steel-plate", amount = 20 },
        { type = "item", name = "electric-engine-unit",  amount = 10 },
        { type = "item", name = "processing-unit",       amount = 20 },
    },
    results = {
        { type = "item", name = "cell-assembly-line", amount = 1 },
    },
    surface_conditions = {
        { property = "pressure", min = 100, max = 600 },
    },
}
