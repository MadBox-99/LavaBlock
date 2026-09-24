-- Three gravel and water give two bricks. Crushed and fired, the same three
-- gravel give four stone and therefore two bricks as well - so this is the
-- same yield from the same input, and what it actually buys is the furnace:
-- no kiln in the line and no fuel burnt. It is paid for in the two minutes
-- the bricks take to dry and in the space to stack them while they do.
return {
    type = "recipe",
    name = "adobe-bricks",
    category = "adobe-mixing",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "basalt-gravel", amount = 3 },
        { type = "fluid", name = "water",         amount = 30 },
    },
    results = {
        { type = "item", name = "wet-adobe-brick", amount = 2 }
    },
    allow_productivity = true,
    subgroup = "raw-resource",
    order = "a[basalt]-g[adobe]-a[plain]",
}
