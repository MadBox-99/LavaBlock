-- Slag remelted on the crystal hearth with sulfur and coal, and grown out
-- slowly. What grows is down to chance.
--
-- Each result rolls on its own, so a craft can give anything from nothing
-- to all five; on average it gives about one and a half:
--
--   pyrite, olivine   one in two  - the sulfur's, and the slag's own mineral
--   ruby, sapphire    one in five - corundum, from the alumina
--   diamond           one in 20   - the coal's carbon
--
-- The sixth crystal, magnetite, is not rolled for here: it needs molten iron
-- and has a recipe of its own (magnetite-growing).
--
-- The sulfur is what the pyrite is made of and the coal is what the
-- diamond is made of, which is why both go in and not just the slag.
--
-- Productivity is allowed, as it is on every recipe this hearth runs. The
-- crystals do not come back round into slag, so there is nothing to farm.
return {
    type = "recipe",
    name = "crystal-growing",
    categories = { "lava-crystallizing" },
    subgroup = "lava-block-crystals",
    order = "0[growing]",
    enabled = false,
    energy_required = 10,
    icon = "__LavaBlock-graphics__/graphics/icons/parts/crystal-assortment.png",
    icon_size = 64,
    ingredients = {
        { type = "item", name = "lava-slag", amount = 5 },
        { type = "item", name = "sulfur",    amount = 1 },
        { type = "item", name = "coal",      amount = 1 },
    },
    results = {
        { type = "item", name = "pyrite",   amount = 1, independent_probability = 0.5 },
        { type = "item", name = "olivine",  amount = 1, independent_probability = 0.5 },
        { type = "item", name = "ruby",     amount = 1, independent_probability = 0.2 },
        { type = "item", name = "sapphire", amount = 1, independent_probability = 0.2 },
        { type = "item", name = "diamond",  amount = 1, independent_probability = 0.05 },
    },
    crafting_machine_tint = {
        primary = { r = 0.85, g = 0.12, b = 0.20, a = 1.0 },
        secondary = { r = 1.00, g = 0.42, b = 0.08, a = 1.0 },
    },
    allow_productivity = true,
}
