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
        -- Prefixed for the same reason as the one above: "gas-combining"
        -- shared with another mod would let its blender run these recipes.
        type = "recipe-category",
        name = "gas-combining"
    },
    {
        -- Filtering, not compressing and not separating. The air compressor
        -- keeps "gas" (it makes compressed air) and "gas-mix" (it pulls
        -- metal and argon back out of air); only the adsorption step moves
        -- here, because that step is a filter's work and not a pump's.
        type = "recipe-category",
        name = "air-filtering"
    }
})