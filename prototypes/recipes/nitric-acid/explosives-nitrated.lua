-- Explosives the way they are actually made: carbon nitrated in mixed acid,
-- nitric for the nitrogen and sulfuric to take up the water the reaction
-- gives off. Vanilla's sulfur, coal and water stand in for black powder.
--
-- A coal, 10 nitric acid and 10 sulfuric acid for three explosives, where
-- vanilla gets two from a coal, a sulfur and water. Ten sulfuric acid is a
-- sulfur's worth, so the sulfur is the same and the coal is the same; the
-- third explosive is paid for in nitric acid, which is an air line, an
-- oxygen line and a slow arc.
return {
    type = "recipe",
    name = "explosives-nitrated",
    category = "chemistry",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "coal",          amount = 1 },
        { type = "fluid", name = "nitric-acid",   amount = 10 },
        { type = "fluid", name = "sulfuric-acid", amount = 10 },
    },
    results = {
        { type = "item", name = "explosives", amount = 3 },
    },
    allow_productivity = true,
    -- Explosives keep recycling into their vanilla ingredients.
    auto_recycle = false,
    icons = {
        {
            icon = "__base__/graphics/icons/explosives.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/nitric-acid.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "b[chemistry]-e[explosives]-b[nitrated]",
    crafting_machine_tint = {
        primary = { r = 0.98, g = 0.47, b = 0.35, a = 1.0 },
        secondary = { r = 1.00, g = 0.99, b = 0.00, a = 1.0 },
    },
}
