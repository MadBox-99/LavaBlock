return {
    type = "item",
    name = "geo-thermal-turbine",
    icons = {
        { icon = "__base__/graphics/icons/steam-turbine.png" },
        {
            icon = "__space-age__/graphics/icons/fluid/lava.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    icon_size = 64,
    subgroup = "energy",
    order = "f[nuclear-energy]-e[steam-turbine]",
    place_result = "geo-thermal-turbine",
    stack_size = 10
}