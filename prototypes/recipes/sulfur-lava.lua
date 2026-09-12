local sulfur_lava = {
    type = "recipe",
    name = "sulfur-lava",
    energy_required = 1,
    enabled = false,
    ingredients = {
        { type = "fluid", name = "petroleum-gas", amount = 30 },
        { type = "fluid", name = "lava",          amount = 1000 }
    },
    results = {
        { type = "item", name = "sulfur", amount = 2 }
    },
    icon = "__base__/graphics/icons/sulfur.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
    -- Only craftable on the LavaBlock lava-ocean world. The vanilla `sulfur`
    -- recipe gets the complementary condition in data-final-fixes.lua, so the
    -- two never overlap and every other planet (including modded ones) keeps
    -- the vanilla recipe.
    surface_conditions = { { property = "lava-block-lava-ocean", min = 1, max = 1 } },
}
return sulfur_lava
