-- Coal out of lava in a chemical plant, the island's only coal mine.
--
-- Five for 1000 lava, eight seconds, as iron and copper ore take: the
-- furnaces' fuel comes out of the same plants at the same pace as the ore
-- they smelt. At four seconds the island's early plates cost a third less
-- than vanilla's; at eight about the same.
local coal_extraction = {
    type = "recipe",
    name = "coal-extraction",
    energy_required = 8,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 1000 }
    },
    results = {
        { type = "item", name = "coal", amount = 5 }
    },
    icon = "__base__/graphics/icons/coal.png",
    icon_size = 64,
    categories = { "chemistry" },
    subgroup = "lava-block-lava-extraction"
}
return coal_extraction
