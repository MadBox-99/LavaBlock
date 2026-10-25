-- The contact process: sulfur dioxide oxidised over a catalyst bed to the
-- trioxide, and the trioxide taken up into acid. Nearly all the world's
-- sulfuric acid is made this way.
--
-- Two fluid inlets, so the water is not one of them. A real plant does not
-- add water to the trioxide either: it absorbs it into acid that is already
-- there and dilutes a little of that, and this recipe draws on its own
-- output the same way.
--
-- Ten dioxide for ten acid, the unit the Claus process counts in, so a
-- unit of sulfur dioxide is worth the same whichever way it goes. Vanilla
-- makes fifty acid from five sulfur, ten a sulfur, and so does this: the
-- difference is that the sulfur never has to be solid.
return {
    type = "recipe",
    name = "sulfuric-acid-from-sulfur-dioxide",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "sulfur-dioxide", amount = 10 },
        { type = "fluid", name = "oxygen",         amount = 5 },
    },
    results = {
        { type = "fluid", name = "sulfuric-acid", amount = 10 },
    },
    allow_productivity = false,
    allow_quality = false,
    icons = {
        {
            icon = "__base__/graphics/icons/fluid/sulfuric-acid.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/sulfur-dioxide.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-volcanic-gas",
    order = "c[volcanic-gas]-e[sulfuric-acid-from-sulfur-dioxide]",
    crafting_machine_tint = {
        primary = { r = 1.00, g = 0.99, b = 0.00, a = 1.0 },
        secondary = { r = 0.92, g = 0.84, b = 0.39, a = 1.0 },
    },
}
