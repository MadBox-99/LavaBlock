-- Anode slime parted with acids: nitric acid takes the silver, and aqua
-- regia - nitric and hydrochloric together - takes the gold and the
-- platinum that nitric acid alone leaves. Each is dropped back out of its
-- solution as metal.
--
-- Ten slime, 20 of each acid, for four silver, two gold and a platinum one
-- craft in two - silver first, as it is in real slime. A microchip print
-- takes a gold every eight seconds, so a lithography machine wants two and
-- a half copper refining plants' slime behind it.
return {
    type = "recipe",
    name = "anode-slime-refining",
    category = "chemistry",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "anode-slime",       amount = 10 },
        { type = "fluid", name = "nitric-acid",       amount = 20 },
        { type = "fluid", name = "hydrochloric-acid", amount = 20 },
    },
    results = {
        { type = "item", name = "silver-plate",   amount = 4 },
        { type = "item", name = "gold-plate",     amount = 2 },
        { type = "item", name = "platinum-plate", amount = 1, probability = 0.5 },
    },
    allow_productivity = true,
    crafting_machine_tint = {
        primary = { r = 0.90, g = 0.75, b = 0.25, a = 1.0 },
        secondary = { r = 0.85, g = 0.85, b = 0.88, a = 1.0 },
    },
    icon = "__LavaBlock-graphics__/graphics/icons/parts/anode-slime.png",
    icon_size = 64,
    subgroup = "raw-material",
    order = "d[precious]-a[anode-slime]-b[refining]",
}
