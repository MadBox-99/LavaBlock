-- A tree grown with fertiliser worked into its bed: twelve wood where the
-- plain recipe gets eight, for a fertiliser.
--
-- Not strictly better: a fertiliser is an eighth of an ammonia craft plus a
-- quarter of a phosphorus and a potash, and the four wood it adds are what
-- an arboretum makes in ten seconds anyway. It is for the player short of
-- arboretums, not of nitrogen.
return {
    type = "recipe",
    name = "tree-cultivation-fertilized",
    categories = { "arboretum" },
    enabled = false,
    energy_required = 20,
    ingredients = {
        { type = "item",  name = "tree-seed",  amount = 1 },
        { type = "item",  name = "fertilizer", amount = 1 },
        { type = "fluid", name = "water",      amount = 200 },
    },
    results = {
        { type = "item", name = "wood", amount = 12 },
    },
    allow_productivity = true,
    -- Wood recycles through the plain recipe.
    auto_recycle = false,
    icons = {
        { icon = "__base__/graphics/icons/wood.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/fertilizer.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "a[wood]-b[tree-cultivation]-b[fertilized]",
}
