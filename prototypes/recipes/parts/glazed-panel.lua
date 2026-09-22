-- A pane in a steel frame. What the glasshouses are actually walled with,
-- and the reason the arboretum and the algae tank now cost less plate than
-- they did: the glazed wall replaces the steel one rather than being bolted
-- on top of it. The buildings got a new ingredient, not a higher bill.
return {
    type = "recipe",
    name = "glazed-panel",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item", name = "glass",       amount = 3 },
        { type = "item", name = "steel-plate", amount = 1 },
    },
    results = { { type = "item", name = "glazed-panel", amount = 1 } },
    allow_productivity = true,
}
