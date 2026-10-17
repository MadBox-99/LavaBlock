-- Molten quartz poured into lens moulds and polished with ceria. An
-- assembler with a fluid input does the casting, as it does for anything
-- else the island pours. Ceria is what every precision lens is finished
-- with: it takes the last scratches out of glass by reacting with it,
-- where an abrasive only grinds.
--
-- Two lenses at a time, so that one cerium polishes both: the quartz is
-- the same 50 a lens as before.
return {
    type = "recipe",
    name = "quartz-lens",
    categories = { "crafting-with-fluid" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "cerium",        amount = 1 },
        { type = "fluid", name = "molten-quartz", amount = 100 },
    },
    results = {
        { type = "item", name = "quartz-lens", amount = 2 },
    },
    allow_productivity = true,
}
