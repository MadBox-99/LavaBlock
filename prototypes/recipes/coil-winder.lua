-- An assembling machine 2 rebuilt round a turntable, with a steel column for
-- the guide and gears for the drive. No coils in it: the winder is the only
-- thing that makes them, so it cannot be built from them.
return {
    type = "recipe",
    name = "coil-winder",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item", name = "assembling-machine-2", amount = 1 },
        { type = "item", name = "steel-plate",          amount = 10 },
        { type = "item", name = "iron-gear-wheel",      amount = 10 },
        { type = "item", name = "electronic-circuit",   amount = 5 },
    },
    results = {
        { type = "item", name = "coil-winder", amount = 1 },
    },
}
