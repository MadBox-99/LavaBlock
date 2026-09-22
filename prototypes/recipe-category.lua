data:extend({
    {
        type = "recipe-category",
        name = "chemical"
    },
    {
        type = "recipe-category",
        name = "cryogenic-cooling"
    },
    {
        type = "recipe-category",
        name = "gas-mix"
    },
    {
        type = "recipe-category",
        name = "gas"
    },
    {
        type = "recipe-category",
        name = "lava-centrifuge"
    },
    {
        type = "recipe-category",
        name = "water-condensing"
    },
    {
        type = "recipe-category",
        name = "arboretum"
    },
    {
        type = "recipe-category",
        name = "bio-garden"
    },
    {
        type = "recipe-category",
        name = "algae-tank"
    },
    {
        -- Not "crushing": that is Space Age's, for the asteroid crusher on
        -- space platforms. Sharing it would let this machine run asteroid
        -- recipes and the asteroid crusher grind basalt.
        type = "recipe-category",
        name = "rock-crushing"
    },
    {
        -- Only the industrial crusher has this one, so the oiled recipes
        -- cannot be run on a machine with no lubricant port.
        type = "recipe-category",
        name = "rock-crushing-oiled"
    },
    {
        -- Prefixed, like the centrifuge's. "crystallizing" on its own is a
        -- name any mod with a crystallizer would reach for, and a shared
        -- category would let its machine run these recipes and this machine
        -- run its - which is the same trap `rock-crushing` above avoids.
        type = "recipe-category",
        name = "lava-crystallizing"
    },
    {
        type = "recipe-category",
        name = "lava-centrifuge",
    }
})