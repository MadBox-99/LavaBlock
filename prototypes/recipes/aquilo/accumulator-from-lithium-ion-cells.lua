-- An accumulator built on lithium-ion cells: two cells in place of the
-- five lead-acid batteries. The batteries cost a lead plate, an iron plate
-- and twenty acid each, and Aquilo, where the cells are made, has neither
-- lead nor acid; the cells cost lithium, which it has, and the metals the
-- island ships. Not cheaper, but buildable where the batteries are not.
return {
    type = "recipe",
    name = "accumulator-from-lithium-ion-cells",
    categories = { "crafting", "electromagnetics" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "iron-plate",       amount = 2 },
        { type = "item", name = "lithium-ion-cell", amount = 2 },
    },
    results = {
        { type = "item", name = "accumulator", amount = 1 },
    },
    auto_recycle = false,
    icons = {
        { icon = "__base__/graphics/icons/accumulator.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/lithium-ion-cell.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "energy",
    order = "e[accumulator]-a[accumulator]-b[lithium-ion]",
}
