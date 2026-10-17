-- Pentlandite dissolved in hot sulfuric acid and the solution electrolysed:
-- nickel plates out first and cobalt after it. It is the way the world gets
-- its cobalt, which is never mined for itself but always comes out of
-- nickel or copper ore.
--
-- Six pentlandite and 50 acid for a cobalt and two nickel plates, against
-- the three nickel the arc furnace gets out of the same six ore: the price
-- of the cobalt is a nickel.
return {
    type = "recipe",
    name = "pentlandite-leaching",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item",  name = "pentlandite",   amount = 6 },
        { type = "fluid", name = "sulfuric-acid", amount = 50 },
    },
    results = {
        { type = "item", name = "cobalt-plate", amount = 1 },
        { type = "item", name = "nickel-plate", amount = 2 },
    },
    main_product = "cobalt-plate",
    allow_productivity = true,
    crafting_machine_tint = {
        primary = { r = 0.30, g = 0.45, b = 0.85, a = 1.0 },
        secondary = { r = 0.40, g = 0.80, b = 0.40, a = 1.0 },
    },
    subgroup = "raw-material",
    order = "a[smelting]-h[cobalt-plate]",
}
