-- Molten steel quenched to plate in a chemical plant, the way the lava
-- smelting line cools molten iron.
--
-- 25 a plate and 10 water, three seconds. The arithmetic against the
-- furnace is on steel converting. Nauvis only, for the reason given there.
return {
    type = "recipe",
    name = "steel-casting",
    category = "chemistry",
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "molten-steel", amount = 25 },
        { type = "fluid", name = "water",        amount = 10 },
    },
    results = {
        { type = "item", name = "steel-plate", amount = 1 },
    },
    allow_productivity = true,
    -- Steel keeps recycling into iron plate.
    auto_recycle = false,
    surface_conditions = {
        { property = "pressure", min = 1000, max = 1000 },
        { property = "gravity",  min = 10,   max = 10 },
    },
    icons = {
        {
            icon = "__base__/graphics/icons/steel-plate.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-steel.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "a[smelting]-c[steel-plate]-b[casting]",
    crafting_machine_tint = {
        primary = { r = 1.00, g = 0.88, b = 0.16, a = 1.0 },
        secondary = { r = 0.60, g = 0.80, b = 1.00, a = 1.0 },
    },
}
