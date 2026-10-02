-- The artillery wagon keeps its vanilla ingredients and moves into the
-- train factory with the rest of the rolling stock. Olive drab on the
-- factory's track.
local recipe = data.raw["recipe"]["artillery-wagon"]
recipe.category = "rolling-stock-assembling"
recipe.crafting_machine_tint = {
    primary = { r = 0.42, g = 0.45, b = 0.28, a = 1.0 },
}
