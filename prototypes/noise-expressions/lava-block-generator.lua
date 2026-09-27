-- Factorio 2.0 compatible: all noise and autoplace expressions must be string-based

-- Terrain for the LavaBlock Nauvis: a lava ocean, a starting island with a
-- ragged coast, and small islands scattered out in the ocean.
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
        -- still come from cliff_elevation = elevation, which peaks at 5 on
        -- the starting island, under the first cliff line at 10: the island
        -- is as cliff-free as it was, it just no longer errors.
        expression = "cliffiness_basic"
    },
    {
        type = "noise-expression",
        name = "lava-elevation",
        intended_property = "elevation",
        -- The starting island is a cone around the nearest starting point,
        -- 40 tiles to the coast, with the coastline pushed in or out by up
        -- to 12 tiles of noise. The noise is clamped, so the island is never
        -- smaller than 28 tiles in any direction - well clear of the 25x25
        -- landfill pad control.lua lays at spawn - and never larger than 52.
        --
        -- The old version meant to do this and did not: its noise term was
        -- -8 plus at most 3, never above zero, so the island came out a
        -- perfect circle on every seed.
        --
        -- Small islands stand at elevation 1, the ocean at -4.
        local_expressions = {
            coast = [[clamp(multioctave_noise{x = x, y = y,
                                              seed0 = map_seed, seed1 = 40000,
                                              octaves = 3, persistence = 0.55,
                                              input_scale = 1/24,
                                              output_scale = 1}, -1, 1)]],
            spots = [[lava_block_island_spot(1/100, 11111, 22222, 33333)
                    | lava_block_island_spot(1/150, 33333, 44444, 77777)
                    | lava_block_island_spot(1/80, 55555, 66666, 22221)
                    | lava_block_island_spot(1/120, 77777, 88888, 66665)
                    | lava_block_island_spot(1/90, 99999, 11111, 11110)]],
        },
        expression = "max((40 - distance + 12 * coast) / 10, 5 * spots - 4)"
    }
}

-- grass-1 is the land tile: wherever elevation is above zero it beats lava,
-- whose probability is 0 - elevation.
data.raw.tile["grass-1"].autoplace = {
    probability_expression = "elevation",
    richness_expression = "1",
    order = "z[grass-spot]"
}
