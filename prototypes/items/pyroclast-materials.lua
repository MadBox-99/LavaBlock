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

local emat = {
    type = "item",
    name = "emat",
    icons = {
        {
            icon = "__base__/graphics/icons/explosives.png",
            icon_size = 64,
            tint = { r = 0.9, g = 0.4, b = 0.2, a = 1 }
        }
    },
    subgroup = "raw-material",
    order = "c[emat]",
    stack_size = 100
}

local rmat = {
    type = "item",
    name = "rmat",
    icons = {
        {
            icon = "__base__/graphics/icons/copper-plate.png",
            icon_size = 64,
            tint = { r = 0.3, g = 0.4, b = 0.7, a = 1 }
        }
    },
    subgroup = "raw-material",
    order = "c[rmat]",
    stack_size = 100
}

local hemat = {
    type = "item",
    name = "hemat",
    icons = {
        {
            icon = "__base__/graphics/icons/steel-plate.png",
            icon_size = 64,
            tint = { r = 0.7, g = 0.15, b = 0.15, a = 1 }
        }
    },
    subgroup = "raw-material",
    order = "c[hemat]",
    stack_size = 50
}

return { bmat, cmat, emat, rmat, hemat }
