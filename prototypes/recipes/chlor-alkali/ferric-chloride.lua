-- Iron dissolved in hydrochloric acid, and chlorine bubbled through to
-- take it from the ferrous to the ferric salt. Both steps happen in the
-- same tank in real plants, so this is one recipe.
--
-- One iron plate, 20 acid and 10 chlorine for 20 ferric chloride: 20 units
-- carry one plate's iron. That is the unit the two recipes downstream
-- count in - an etched circuit board takes 10, half a plate, and a
-- magnetite takes 60, three plates.
return {
    type = "recipe",
    name = "ferric-chloride",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item",  name = "iron-plate",        amount = 1 },
        { type = "fluid", name = "hydrochloric-acid", amount = 20 },
        { type = "fluid", name = "chlorine",          amount = 10 },
    },
    results = {
        { type = "fluid", name = "ferric-chloride", amount = 20 },
    },
    -- Magnetite precipitation turns this back into brine, which the cell
    -- turns back into chlorine; productivity here would feed that loop.
    allow_productivity = false,
    subgroup = "fluid-recipes",
    order = "d[chlor-alkali]-d[ferric-chloride]",
    crafting_machine_tint = {
        primary = { r = 0.43, g = 0.16, b = 0.08, a = 1.0 },
        secondary = { r = 0.71, g = 0.92, b = 0.35, a = 1.0 },
    },
}
