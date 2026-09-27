-- The vanilla solar panel, made harder to build on the island.
--
-- Vanilla asks for steel, circuits and copper, all of which the island makes
-- out of lava from the first minutes, so the only thing between a new base
-- and a field of free power was the research. The panel now takes the
-- mod's own glass for its cover sheet and silica crystal for the cells, so
-- it waits on the crystallizer line, and the doubled steel and copper make
-- each panel a real cost rather than a formality.
--
-- How much a panel produces is a startup setting, applied in
-- data-final-fixes.lua.
local recipe = data.raw.recipe["solar-panel"]
recipe.ingredients = {
    { type = "item", name = "steel-plate",        amount = 10 },
    { type = "item", name = "electronic-circuit", amount = 15 },
    { type = "item", name = "copper-plate",       amount = 10 },
    { type = "item", name = "glass",              amount = 5 },
    { type = "item", name = "silica-crystal",     amount = 2 },
}

-- Glass and silica crystal come from Lava crystallization.
table.insert(data.raw.technology["solar-energy"].prerequisites, "lava-crystallization")
