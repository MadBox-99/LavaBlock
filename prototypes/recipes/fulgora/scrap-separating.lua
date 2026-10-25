-- Scrap through the eddy current separator. The rotor throws the
-- non-ferrous metal clear - aluminium most of all, because it is light and
-- conducts well, then zinc, brass and lead - and what drops off the end is
-- the circuit-board fraction, e-waste, for the arc furnace.
--
-- Six things out of ten scrap, where the recycler gets six vanilla parts
-- out of the same ten. It is not a better recycler, it is a different cut
-- of the same heap: no holmium, no circuits, no steel, and every one of
-- these is a metal the island otherwise grows on its crystal hearth.
return {
    type = "recipe",
    name = "scrap-separating",
    categories = { "scrap-separating" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "scrap", amount = 10 },
    },
    results = {
        { type = "item", name = "aluminium-plate", amount = 2 },
        { type = "item", name = "zinc-plate",      amount = 1 },
        { type = "item", name = "brass-plate",     amount = 1 },
        { type = "item", name = "lead-plate",      amount = 1 },
        { type = "item", name = "e-waste",         amount = 1 },
    },
    allow_productivity = true,
    icons = {
        { icon = "__space-age__/graphics/icons/scrap.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/aluminium-plate.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 8, 8 },
        },
    },
    subgroup = "fulgora-processes",
    order = "a[trash]-b[scrap-separating]",
}
