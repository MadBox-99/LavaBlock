-- An iron core and eight copper cables, wound. Only the coil winder does it:
-- a coil is turns laid side by side under tension, which is a machine's
-- work and not an assembler's.
--
-- Four copper plates and an iron plate a coil. Copper is what a motor and
-- a transformer are mostly made of, and here it is where their copper goes.
return {
    type = "recipe",
    name = "magnetic-coil",
    category = "coil-winding",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item", name = "iron-plate",   amount = 1 },
        { type = "item", name = "copper-cable", amount = 8 },
    },
    results = {
        { type = "item", name = "magnetic-coil", amount = 1 },
    },
    allow_productivity = true,
}
