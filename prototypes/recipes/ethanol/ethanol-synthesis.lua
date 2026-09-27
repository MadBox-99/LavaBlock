-- Ethanol the other way: ethylene out of the petroleum gas, and steam added
-- across its double bond over an acid catalyst. It is how most industrial
-- ethanol that is not fuel is made, and it needs none of the fermentation
-- line - the Fuel Plant's reactor, gas and steam.
--
-- Deliberately not better than the biological route, only different. A
-- hundred gas for fifty ethanol puts it on the oil line, which on this
-- island starts from coal and steam; what it buys is not having to grow
-- anything.
return {
    type = "recipe",
    name = "ethanol-synthesis",
    category = "fuel-synthesizing",
    subgroup = "fluid-recipes",
    order = "b[ethanol]-e[ethanol-synthesis]",
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "petroleum-gas", amount = 100 },
        { type = "fluid", name = "steam",         amount = 50 },
    },
    results = {
        { type = "fluid", name = "ethanol", amount = 50 },
    },
    allow_productivity = true,
    allow_quality = false,
    always_show_products = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/ethanol.png",
            icon_size = 64,
        },
        {
            icon = "__base__/graphics/icons/fluid/petroleum-gas.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.78, g = 0.66, b = 0.30, a = 1.0 },
        secondary = { r = 0.76, g = 0.52, b = 0.80, a = 1.0 },
    },
}
