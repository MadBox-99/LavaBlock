-- A gas laser source: a helium-neon tube in place of the ruby rod. The
-- helium takes the energy of the discharge and hands it to the neon, which
-- lases; neon alone barely does.
--
-- The plain recipe's ruby and xenon become 50 helium-neon - 5 neon, a
-- thousand air through the compressor, and 45 helium off decaying radon -
-- and nothing else changes. The crystal circuit board still carries a ruby
-- of its own, so a laser source goes from two rubies to one. Rubies come
-- one craft in five off the crystal hearth, and a lithography line burns a
-- source every fifty prints; halving that is what the gas lines buy.
return {
    type = "recipe",
    name = "laser-source-neon",
    categories = { "crafting-with-fluid" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "quartz-lens",           amount = 2 },
        { type = "item",  name = "crystal-circuit-board", amount = 1 },
        { type = "item",  name = "tin-plate",             amount = 4 },
        { type = "item",  name = "steel-plate",           amount = 4 },
        { type = "fluid", name = "helium-neon",           amount = 50 },
    },
    results = {
        { type = "item", name = "laser-source", amount = 1 },
    },
    -- Laser sources keep recycling into the ruby recipe's ingredients.
    auto_recycle = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/laser-source.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/helium-neon.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "z[lavablock]-l[laser-source]-b[neon]",
}
