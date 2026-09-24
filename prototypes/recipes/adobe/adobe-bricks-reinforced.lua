-- Straw in the mud, which is what makes adobe adobe: the fibre holds the
-- block together as it dries instead of letting it crack, so more of the
-- batch survives. Half as many bricks again for one wood.
--
-- It is also the only place in the mod where the timber line and the rock
-- line meet. Everything grown in the Arboretum has so far gone into things
-- made of wood; this puts it into the stone chain, which is the chain that
-- actually gates island expansion.
return {
    type = "recipe",
    name = "adobe-bricks-reinforced",
    category = "adobe-mixing",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "basalt-gravel", amount = 3 },
        { type = "item",  name = "wood",          amount = 1 },
        { type = "fluid", name = "water",         amount = 30 },
    },
    results = {
        { type = "item", name = "wet-adobe-brick", amount = 3 }
    },
    allow_productivity = true,
    subgroup = "raw-resource",
    order = "a[basalt]-g[adobe]-b[reinforced]",
}
