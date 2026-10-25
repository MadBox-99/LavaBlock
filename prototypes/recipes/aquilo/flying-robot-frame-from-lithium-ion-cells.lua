-- A flying robot frame with a lithium-ion cell in place of its two
-- lead-acid batteries: the battery a robot actually flies on, a quarter of
-- the weight for the charge. The rest of the frame is vanilla's.
return {
    type = "recipe",
    name = "flying-robot-frame-from-lithium-ion-cells",
    enabled = false,
    energy_required = 20,
    ingredients = {
        { type = "item", name = "electric-engine-unit", amount = 1 },
        { type = "item", name = "lithium-ion-cell",     amount = 1 },
        { type = "item", name = "steel-plate",          amount = 1 },
        { type = "item", name = "electronic-circuit",   amount = 3 },
    },
    results = {
        { type = "item", name = "flying-robot-frame", amount = 1 },
    },
    auto_recycle = false,
    icons = {
        { icon = "__base__/graphics/icons/flying-robot-frame.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/lithium-ion-cell.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "c[advanced-intermediates]-c[flying-robot-frame]-b[lithium-ion]",
}
