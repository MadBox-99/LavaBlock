-- Straw in the mud, which is what makes adobe adobe: the fibre holds the
-- block together as it dries instead of letting it crack, so more of the
-- batch survives. Half as many bricks again for one straw.
--
-- It is also the only place in the mod where the Arboretum and the rock
-- line meet. Everything else grown there goes into things made of wood;
-- this puts it into the stone chain, which is the chain that actually gates
-- island expansion. It took a log of wood until the Arboretum learned to
-- grow grass - a whole log chopped into the mud for what is, in a real
-- adobe yard, a handful of cut stalks.
return {
    type = "recipe",
    name = "adobe-bricks-reinforced",
    categories = { "adobe-mixing" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "basalt-gravel", amount = 3 },
        { type = "item",  name = "straw",         amount = 1 },
        { type = "fluid", name = "water",         amount = 30 },
    },
    results = {
        { type = "item", name = "wet-adobe-brick", amount = 3 }
    },
    allow_productivity = true,
    subgroup = "raw-resource",
    order = "a[basalt]-g[adobe]-b[reinforced]",
}
