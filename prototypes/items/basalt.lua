-- Quenched lava: the rock the island is actually made of, in a form a
-- crusher can bite. It exists so that stone has a source that is not
-- ore-clearing, which burns an iron ore and a copper ore for every single
-- stone and made land expansion the most expensive thing in the mod.
return {
    type = "item",
    name = "basalt",
    -- The vanilla stone icon, darkened. Basalt is stone that has not been
    -- crushed yet, so a recoloured stone reads correctly and truthfully,
    -- and it saves carrying a sprite for a one-step intermediate.
    icons = {
        {
            icon = "__base__/graphics/icons/stone.png",
            icon_size = 64,
            tint = { r = 0.46, g = 0.44, b = 0.50 },
        },
    },
    subgroup = "raw-resource",
    order = "a[basalt]",
    stack_size = 100
}
