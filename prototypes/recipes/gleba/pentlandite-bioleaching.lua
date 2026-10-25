-- Pentlandite leached by bacteria, the way the Talvivaara mine in Finland
-- won its nickel and cobalt: the culture eats the sulfide, both metals go
-- into solution, and they are won back out of it as plate.
--
-- Three nickel and a cobalt from six pentlandite, where leaching with
-- sulfuric acid gets two nickel and a cobalt and smelting gets three
-- nickel and no cobalt. No acid and no furnace; a culture of bacteria a
-- run instead. It is the cheapest cobalt there is, about half the price of
-- leaching it with acid, and Gleba's reason to ship bacteria home.
--
-- Six seconds a run, not twenty. At twenty the reactor's own time cost more
-- than the furnace and acid it saves, and every bioleaching recipe made
-- dearer metal than the island's routes did.
return {
    type = "recipe",
    name = "pentlandite-bioleaching",
    categories = { "ore-bioleaching" },
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "item",  name = "pentlandite",       amount = 6 },
        { type = "item",  name = "leaching-bacteria", amount = 1 },
        { type = "fluid", name = "water",             amount = 100 },
    },
    results = {
        { type = "item", name = "nickel-plate", amount = 3 },
        { type = "item", name = "cobalt-plate", amount = 1 },
    },
    allow_productivity = true,
    -- Nickel and cobalt keep recycling the way they did.
    auto_recycle = false,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/parts/nickel-plate.png", icon_size = 64 },
        { icon = "__LavaBlock-graphics__/graphics/icons/items/leaching-bacteria.png", icon_size = 64, scale = 0.25, shift = { -8, -8 } },
    },
    subgroup = "agriculture-processes",
    order = "b[agriculture]-d[bacteria]-g[bioleaching]-a[pentlandite]",
    crafting_machine_tint = {
        -- Nickel sulfate green.
        primary = { r = 0.30, g = 0.62, b = 0.36, a = 1 },
        secondary = { r = 0.22, g = 0.45, b = 0.28, a = 1 },
    },
}
