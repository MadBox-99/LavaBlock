-- Two columns, borrowed from the algae tank next door, and the pan and press
-- still in plate and brick. The garden is the one new machine with no part
-- of its own: it is a dome over a pan with a rake turning in it, and
-- inventing a part that cannot be pointed at on the model would be a tax
-- rather than a step. The six panels are the dome, which can be pointed at.
return {
    type = "recipe",
    name = "bio-garden",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item", name = "culture-column",     amount = 2 },
        { type = "item", name = "glazed-panel",       amount = 6 },
        { type = "item", name = "steel-plate",        amount = 19 },
        { type = "item", name = "electronic-circuit", amount = 20 },
        { type = "item", name = "pipe",               amount = 15 },
        { type = "item", name = "stone-brick",        amount = 40 },
    },
    results = {
        { type = "item", name = "bio-garden", amount = 1 }
    },
}
