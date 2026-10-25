-- Steel remelted with a tenth of manganese: Hadfield's steel, the first
-- alloy steel there was. Nine steel and a manganese plate make a hundred
-- units, ten plates; manganese goes into steel as solid metal, as it
-- always has.
return {
    type = "recipe",
    name = "molten-manganese-steel",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "item", name = "steel-plate",     amount = 9 },
        { type = "item", name = "manganese-plate", amount = 1 },
    },
    results = {
        { type = "fluid", name = "molten-manganese-steel", amount = 100, fluidbox_index = 1 },
    },
    allow_productivity = true,
    subgroup = "lava-block-alloy-melts",
    order = "n[alloy]-b[molten-manganese-steel]",
}
