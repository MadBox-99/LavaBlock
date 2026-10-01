-- The lime kiln, in an ordinary furnace. Limestone is fired until its
-- carbon dioxide is driven off, and what is left is quicklime.
--
-- The gas escapes rather than coming back round to the carbonation step. A
-- furnace has no fluid output, and a kiln that fed its own feedstock would
-- make the coal-burning half of the line pointless once it was running.
--
-- Twice the time of a stone brick: firing lime takes longer than firing
-- clay.
return {
    type = "recipe",
    name = "limestone-calcination",
    categories = { "smelting" },
    enabled = false,
    energy_required = 6.4,
    ingredients = {
        { type = "item", name = "limestone", amount = 1 },
    },
    results = {
        { type = "item", name = "quicklime", amount = 1 },
    },
    allow_productivity = true,
}
