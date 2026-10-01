-- The magma loop's salt, and the one place it is made. Limestone for the
-- calcium, slag for everything else a salt melt needs, and lava to melt the
-- two together.
--
-- A loop needs filling once rather than feeding: the reactor and turbine
-- pass the same salt back and forth, and it only runs short when a pipe is
-- pulled up. So this is a start-up recipe, priced like one.
return {
    type = "recipe",
    name = "salt-melting",
    category = "chemistry",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "limestone", amount = 5 },
        { type = "item",  name = "lava-slag", amount = 5 },
        { type = "fluid", name = "lava",      amount = 200 },
    },
    results = {
        { type = "fluid", name = "molten-salt-hot", amount = 100, temperature = 565 },
    },
    crafting_machine_tint = {
        primary = { r = 0.90, g = 0.30, b = 0.16, a = 1.0 },
        secondary = { r = 0.80, g = 0.72, b = 0.50, a = 1.0 },
        tertiary = { r = 0.36, g = 0.20, b = 0.10, a = 1.0 },
        quaternary = { r = 1.00, g = 0.42, b = 0.08, a = 1.0 },
    },
}
