-- Tungsten carbide with a cobalt binder, sintered under argon in the
-- isostatic press. Real hardmetal is six to twelve parts cobalt in a
-- hundred; one cobalt plate to four carbide is about that.
--
-- The argon is what the press squeezes with, five to a carbide: the gas
-- is pumped to a thousand atmospheres and some of every charge is lost
-- when the vessel is opened.
--
-- Four out of four in, so the press adds no tungsten; what it adds is the
-- cobalt and the toughness. Cobalt leaching gives one cobalt plate a run,
-- so a single chemical plant on pentlandite keeps a press busy.
return {
    type = "recipe",
    name = "cemented-carbide",
    categories = { "isostatic-pressing" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "tungsten-carbide", amount = 4 },
        { type = "item",  name = "cobalt-plate",     amount = 1 },
        { type = "fluid", name = "argon",            amount = 20 },
    },
    results = {
        { type = "item", name = "cemented-carbide", amount = 4 },
    },
    allow_productivity = true,
}
