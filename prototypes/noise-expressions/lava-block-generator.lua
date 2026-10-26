-- Factorio 2.0 compatible: all noise and autoplace expressions must be string-based

-- Terrain for the LavaBlock Nauvis: a lava ocean, the 25x25 starting pad in
-- a lava moat, and small islands scattered out in the ocean.
--
-- Everything is decided by elevation. Land is elevation > 0 and the ocean
-- is below it; the lava tile's probability is set to `0 - elevation` on the
-- planet (island-generation.lua) and grass-1's to `elevation` here, so the
-- two tiles meet exactly at the coastline. The small islands used to be a
-- grass-1 autoplace of their own laid over a lava elevation, which left
-- them as grass painted on the ocean: they are part of the elevation now,
-- so anything that asks "is this land" - enemy bases, cliffs, the tile
-- itself - gets the same answer.

data:extend {
    {
        -- One patch of scattered small islands: land wherever three
        -- independent noises all sit near their extremes at once, which is
        -- rare and gives small, irregular blobs.
        --
        -- Same thresholds and scales as the old grass spots, so the islands
        -- are as many and as big as they were. What changed is how the noise
        -- is asked for: seed0 is always map_seed and the layers differ by
        -- seed1, and scale goes through input_scale rather than multiplying
        -- x and y, which keeps the fast x = x, y = y path.
        type = "noise-function",
        name = "lava_block_island_spot",
        parameters = { "scale", "s1", "s2", "s3" },
        expression = [[
            (abs(basis_noise{x = x, y = y, seed0 = map_seed, seed1 = s1,
                             input_scale = scale, output_scale = 1}) > 0.88)
          & (abs(basis_noise{x = x, y = y, seed0 = map_seed, seed1 = s2,
                             input_scale = scale * 0.5, output_scale = 1}) > 0.85)
          & (abs(basis_noise{x = x, y = y, seed0 = map_seed, seed1 = s3,
                             input_scale = scale * 0.3, output_scale = 1}) > 0.87)
        ]]
    },
    {
        -- The lava tile's probability on this planet: the deeper below sea
        -- level, the surer. Its own named expression because a planet's
        -- property_expression_names can only point at a name.
        type = "noise-expression",
        name = "lava-block-lava-probability",
        expression = "0 - elevation"
    },
    {
        type = "noise-expression",
        name = "lava-cliffiness",
        intended_property = "cliffiness",
        -- The vanilla basic cliffiness. The old expression here was carried
        -- over from 1.1 and named `tier` and
        -- `control_setting_cliffs_richness_multiplier`, neither of which
        -- exists in 2.0, so it failed to compile on every map load. Cliffs
        -- still come from cliff_elevation = elevation, which peaks at 1.2 on
        -- the starting pad, under the first cliff line at 10: the island is
        -- as cliff-free as it was, it just no longer errors.
        expression = "cliffiness_basic"
    },
    {
        type = "noise-expression",
        name = "lava-elevation",
        intended_property = "elevation",
        -- The starting island is the 25x25 landfill pad control.lua lays
        -- round the origin and nothing more. The noise raises the ground
        -- under the pad, so the spawn is land before the pad goes down, and
        -- keeps every other island out to 52 tiles, so the pad stands alone
        -- in a lava moat.
        --
        -- Not a bigger island round the pad: from 0.1.4 a grass island 28 to
        -- 52 tiles out came for free with every map, several times the pad's
        -- 625 tiles, on a world where land is the thing research pays for.
        -- 0.1.4 took the old ocean-only elevation for a bug; the pad alone
        -- was the island from the first release. 52 is as far as that grass
        -- reached, so the map beyond it is the same as before.
        --
        -- The pad peaks at 1.2, small islands stand at 1, the ocean at -4.
        local_expressions = {
            spots = [[lava_block_island_spot(1/100, 11111, 22222, 33333)
                    | lava_block_island_spot(1/150, 33333, 44444, 77777)
                    | lava_block_island_spot(1/80, 55555, 66666, 22221)
                    | lava_block_island_spot(1/120, 77777, 88888, 66665)
                    | lava_block_island_spot(1/90, 99999, 11111, 11110)]],
        },
        expression = [[max((12 - max(abs(x), abs(y))) / 10,
                           5 * spots * (x * x + y * y > 52 * 52) - 4)]]
    }
}

-- grass-1 is the land tile: wherever elevation is above zero it beats lava,
-- whose probability is 0 - elevation.
data.raw.tile["grass-1"].autoplace = {
    probability_expression = "elevation",
    richness_expression = "1",
    order = "z[grass-spot]"
}
