-- The vanilla nuclear reactor, with a stainless steel vessel. A reactor
-- holds its water at full temperature and pressure for the life of the
-- plant, and every real pressure vessel is clad inside in stainless steel
-- so that the water never touches carbon steel.
--
-- 500 stainless plates for the 500 steel plates.
local recipe = data.raw.recipe["nuclear-reactor"]
recipe.ingredients = {
    { type = "item", name = "concrete",              amount = 500 },
    { type = "item", name = "stainless-steel-plate", amount = 500 },
    { type = "item", name = "advanced-circuit",      amount = 500 },
    { type = "item", name = "copper-plate",          amount = 500 },
}
