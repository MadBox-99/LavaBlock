-- A sapphire sliced into two substrate plates. Slower than silicon:
-- sapphire is corundum, and only the diamond in the laser's own head is
-- harder. The blank on the bed goes sapphire blue.
return {
    type = "recipe",
    name = "sapphire-substrate-cutting",
    categories = { "laser-cutting" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "sapphire", amount = 1 },
    },
    results = {
        { type = "item", name = "sapphire-substrate", amount = 2 },
    },
    main_product = "sapphire-substrate",
    crafting_machine_tint = {
        primary = { r = 0.16, g = 0.34, b = 0.95, a = 1.0 },
    },
    allow_productivity = true,
}
