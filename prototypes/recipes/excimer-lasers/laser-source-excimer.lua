-- A laser source built round a krypton fluoride excimer tube: the 248
-- nanometre light most of the world's chips have been printed with.
--
-- The neon source's recipe with 50 excimer gas in place of its helium-neon
-- fill: still one ruby, the crystal circuit board's. What it changes is
-- where the gas comes from - krypton out of liquid air and fluorine out of
-- volcanic gas, instead of neon and the radon off uranium ore.
return {
    type = "recipe",
    name = "laser-source-excimer",
    categories = { "crafting-with-fluid" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "quartz-lens",           amount = 2 },
        { type = "item",  name = "crystal-circuit-board", amount = 1 },
        { type = "item",  name = "tin-plate",             amount = 4 },
        { type = "item",  name = "steel-plate",           amount = 4 },
        { type = "fluid", name = "excimer-gas",           amount = 50 },
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
            icon = "__LavaBlock-graphics__/graphics/icons/gas/excimer-gas.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "z[lavablock]-l[laser-source]-c[excimer]",
}
