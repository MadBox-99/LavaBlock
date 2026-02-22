local bmat = {
    type = "item",
    name = "bmat",
    icons = {
        {
            icon = "__base__/graphics/icons/iron-plate.png",
            icon_size = 64,
            tint = { r = 0.5, g = 0.55, b = 0.3, a = 1 }
        }
    },
    subgroup = "raw-material",
    order = "c[bmat]",
    stack_size = 100
}

local cmat = {
    type = "item",
    name = "cmat",
    icons = {
        {
            icon = "__base__/graphics/icons/steel-plate.png",
            icon_size = 64,
            tint = { r = 0.35, g = 0.4, b = 0.3, a = 1 }
        }
    },
    subgroup = "raw-material",
    order = "c[cmat]",
    stack_size = 100
}

return { bmat, cmat }
