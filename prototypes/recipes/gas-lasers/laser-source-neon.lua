-- A gas laser source: a tube of neon in place of the ruby rod. Excimer
-- lasers, the light of every deep-ultraviolet chip printer, are almost all
-- neon by fill.
--
-- The plain recipe's ruby becomes 20 neon - 4000 air, eight hundred steam
-- through the compressor - and nothing else changes. The crystal circuit
-- board still carries a ruby of its own, so a laser source goes from two
-- rubies to one. Rubies come one craft in five off the crystal hearth, and
-- a lithography line burns a source every fifty prints; halving that is
-- what the air line buys.
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
        { type = "fluid", name = "neon",                  amount = 20 },
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
            icon = "__LavaBlock-graphics__/graphics/icons/gas/neon.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "z[lavablock]-l[laser-source]-b[neon]",
}
