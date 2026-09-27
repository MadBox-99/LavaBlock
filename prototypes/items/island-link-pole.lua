return {
    type = "item",
    name = "island-link-pole",
    icons = {
        {
            icon = "__base__/graphics/icons/big-electric-pole.png",
            icon_size = 64,
            tint = { r = 1.00, g = 0.52, b = 0.20, a = 1.0 },
        },
    },
    subgroup = "energy-pipe-distribution",
    order = "a[energy]-c[big-electric-pole]-b[island-link-pole]",
    place_result = "island-link-pole",
    stack_size = 50,
}
