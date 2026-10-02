-- Productivity module with microchips in place of the advanced circuits.
-- Same counts and time as vanilla's.
return {
    type = "recipe",
    name = "microchip-productivity-module",
    category = "electronics",
    enabled = false,
    energy_required = 15,
    ingredients = {
        { type = "item", name = "microchip",          amount = 5 },
        { type = "item", name = "electronic-circuit", amount = 5 },
    },
    results = {
        { type = "item", name = "productivity-module", amount = 1 },
    },
    -- Recycling keeps returning the vanilla recipe's circuits.
    auto_recycle = false,
    icons = {
        { icon = "__base__/graphics/icons/productivity-module.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/microchip.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "module",
    order = "c[productivity]-a[productivity-module-1]-b[microchip]",
}
