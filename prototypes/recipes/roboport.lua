-- The vanilla roboport, with transformers in its charging pads. Four robots
-- charge at once, each off the line through a pad of its own; four
-- transformers, one a pad, step the grid down to what a robot's battery
-- takes.
--
-- Transformers come from Ferromagnetism, which robots already wait on
-- through the electric engine, so nothing moves in the tree.
local recipe = data.raw.recipe["roboport"]
table.insert(recipe.ingredients, { type = "item", name = "transformer", amount = 4 })
