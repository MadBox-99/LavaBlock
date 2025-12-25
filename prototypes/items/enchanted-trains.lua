-- Enchanted Locomotive
local enchanted_locomotive = {
    type = "item",
    name = "enchanted-locomotive",
    icon = "__base__/graphics/icons/locomotive.png",
    icon_size = 64,
    subgroup = "train-transport",
    order = "a[train-system]-f[enchanted-locomotive]",
    stack_size = 5,
    weight = 500 * kg,
    random_tint_color = { 0.8, 0.2, 1.0, 1 },
}

-- Enchanted Cargo Wagon
local enchanted_cargo_wagon = {
    type = "item",
    name = "enchanted-cargo-wagon",
    icon = "__base__/graphics/icons/cargo-wagon.png",
    icon_size = 64,
    subgroup = "train-transport",
    order = "a[train-system]-g[enchanted-cargo-wagon]",
    stack_size = 5,
    weight = 500 * kg,
    random_tint_color = { 0.8, 0.2, 1.0, 1 },
}

-- Enchanted Fluid Wagon
local enchanted_fluid_wagon = {
    type = "item",
    name = "enchanted-fluid-wagon",
    icon = "__base__/graphics/icons/fluid-wagon.png",
    icon_size = 64,
    subgroup = "train-transport",
    order = "a[train-system]-h[enchanted-fluid-wagon]",
    stack_size = 5,
    weight = 500 * kg,
    random_tint_color = { 0.8, 0.2, 1.0, 1 },
}

return { enchanted_locomotive, enchanted_cargo_wagon, enchanted_fluid_wagon }
