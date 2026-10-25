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
        -- Mixing and moulding, not firing. Deliberately its own category and
        -- not shared with "chemistry": a pug mill is a tub with a paddle,
        -- and letting a chemical plant press bricks would delete the point
        -- of building one.
        type = "recipe-category",
        name = "adobe-mixing"
    },
    {
        -- Prefixed for the reason the others are: a bare "quenching" or
        -- "voiding" is a name any mod with a fluid sink would take, and a
        -- shared category would let its machine run these recipes.
        type = "recipe-category",
        name = "fluid-quenching"
    },
    {
        -- Filtering, not compressing and not separating. The air compressor
        -- keeps "gas" (it makes compressed air) and "gas-mix" (it pulls
        -- argon back out of air); only the adsorption step moves
        -- here, because that step is a filter's work and not a pump's.
        type = "recipe-category",
        name = "air-filtering"
    },
    {
        -- Biomass and water to wash. Not "fermentation", which a mod with
        -- a brewery or a biochamber of its own would reach for first.
        type = "recipe-category",
        name = "biomass-fermenting"
    },
    {
        -- The column's one job. Prefixed with what it distils for the same
        -- reason: a bare "distillation" is the first name any oil mod takes.
        type = "recipe-category",
        name = "wash-distilling"
    },
    {
        -- The Fuel Plant: ethanol from gas, and rocket fuel from ethanol.
        -- Kept off "chemistry" so a chemical plant cannot run either.
        type = "recipe-category",
        name = "fuel-synthesizing"
    },
    {
        -- The laser cutter's. "laser-cutting" and not "cutting", which is the
        -- first name a sawmill or a stonecutter in another mod would take.
        type = "recipe-category",
        name = "laser-cutting"
    },
    {
        -- The lithography machine's. Not a bare "lithography", which a mod
        -- with a printing press or a chip line of its own would take first.
        type = "recipe-category",
        name = "chip-lithography"
    },
    {
        -- The train factory's, and the only place locomotives and wagons
        -- are built. Not "train-assembly" or the like, which a railway mod
        -- would reach for first.
        type = "recipe-category",
        name = "rolling-stock-assembling"
    },
    {
        -- The coil winder's. Not a bare "winding", which a textile mod or a
        -- cable mod would take first.
        type = "recipe-category",
        name = "coil-winding"
    },
    {
        -- The arc furnace's. Not a bare "smelting" (vanilla's furnaces) and
        -- not "arc-furnace", which names a building rather than what it
        -- does: everything here is smelted by electricity - alloys under the
        -- arcs, and the metals won in molten-salt cells the industry also
        -- calls smelters.
        type = "recipe-category",
        name = "arc-smelting"
    },
    {
        -- The isostatic press's. Not a bare "pressing", which every mod with
        -- a plate press or an oil press takes first, and which Space Age
        -- 2.0 used for one of its own combined categories.
        type = "recipe-category",
        name = "isostatic-pressing"
    },
    {
        -- The eddy current separator's. Named for what it does to what:
        -- not a bare "separating" or "sorting", and not "magnetic-
        -- separation", which a mod with a magnetic ore separator would take
        -- and which would be wrong besides - the separator throws out the
        -- metals a magnet does not hold.
        type = "recipe-category",
        name = "scrap-separating"
    },
    {
        -- The bioleaching reactor's. Not a bare "bioleaching" or
        -- "leaching": the chemical plant here already leaches with acid,
        -- and a mod with a heap leach pad would take the plain word.
        type = "recipe-category",
        name = "ore-bioleaching"
    }
})