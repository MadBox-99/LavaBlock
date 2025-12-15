local calcite_synthesis = {
    type = "recipe",
    name = "calcite-synthesis",
    energy_required = 1,
    enabled = true,
    ingredients = {
        { type = "item",  name = "coal",        amount = 20 },
        { type = "item",  name = "stone-brick", amount = 40 },
        { type = "fluid", name = "lava",        amount = 5000 },
    },
    results = {
        { type = "item", name = "calcite", amount = 10 }
    },
    icon = "__space-age__/graphics/icons/calcite.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    surface_conditions = { { property = "pressure", min = 1000, max = 1000 }, { property = "gravity", min = 10, max = 10 } },
}
return calcite_synthesis
