-- Copper ore out of lava in a chemical plant: the island's copper until
-- concentrated ore extraction in the lava centrifuge.
--
-- Five for 1000 lava, eight seconds: 0.63 a second a plant, a little more
-- than vanilla's electric mining drill gets out of a patch. At four
-- seconds the island's early plates cost a third less than vanilla's, and
-- red and green science came in under vanilla's cost; at eight a plate
-- costs about what vanilla's does and the two sciences a tenth more.
local copper_extraction = {
    type = "recipe",
    name = "copper-extraction",
    energy_required = 8,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 1000 },
    },
    results = {
        { type = "item", name = "copper-ore", amount = 5 }
    },
    icons = {
        {
            icon = "__base__/graphics/icons/copper-ore.png"
        },
        {
            icon = "__space-age__/graphics/icons/fluid/lava.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    icon_size = 64,
    categories = { "chemistry" },
    subgroup = "lava-block-lava-extraction",
}
return copper_extraction