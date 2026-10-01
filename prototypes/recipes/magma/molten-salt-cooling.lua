-- Hot salt back to cold, so the reactor can take it again: the step that
-- closes the loop, as fluoroketone cooling closes the fusion one.
--
-- Water, because it is the only coolant on the island that is not already
-- spoken for. 20 a hundred salt, and a chemical plant cools 20 salt a
-- second, so a reactor, which takes 40, needs two of them.
return {
    type = "recipe",
    name = "molten-salt-cooling",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "fluid", name = "molten-salt-hot", amount = 100 },
        { type = "fluid", name = "water",           amount = 20 },
    },
    results = {
        { type = "fluid", name = "molten-salt-cold", amount = 100, temperature = 290 },
    },
    crafting_machine_tint = {
        primary = { r = 0.90, g = 0.84, b = 0.56, a = 1.0 },
        secondary = { r = 0.95, g = 0.30, b = 0.16, a = 1.0 },
        tertiary = { r = 0.40, g = 0.36, b = 0.20, a = 1.0 },
        quaternary = { r = 0.50, g = 0.70, b = 0.90, a = 1.0 },
    },
}
