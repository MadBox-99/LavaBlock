-- Factorio 2.0 compatible: all noise and autoplace expressions must be string-based

-- Grass-1 tiny island spots for Nauvis LavaBlock.
-- Uses map_seed so island positions differ each game.
data.raw.tile["grass-1"].autoplace = {
    local_functions = {
        tiny_spot = {
            type = "noise-function",
            parameters = { "scale", "seed1", "seed2" },
            -- seed0 = map_seed ensures different layouts per game
            expression =
            "(abs(basis_noise(x, y, map_seed, seed1, scale, 1)) > 0.88) & (abs(basis_noise(x + 50, y + 50, map_seed + 1000, seed2, scale * 0.5, 1)) > 0.85) & (abs(basis_noise(x - 50, y - 50, map_seed + 5000, seed1 + seed2, scale * 0.3, 1)) > 0.87)"
        }
    },
    probability_expression =
    "tiny_spot(1/100, 11111, 22222) | tiny_spot(1/150, 33333, 44444) | tiny_spot(1/80, 55555, 66666) | tiny_spot(1/120, 77777, 88888) | tiny_spot(1/90, 99999, 11111)",
    richness_expression = "1",
    order = "a"
}

-- Factorio 2.0 noise-expression definitions

data:extend {
    {
        type = "noise-expression",
        name = "lava-cliffiness",
        intended_property = "cliffiness",
        expression = "clamp((tier - 0.2) * ceil(control_setting_cliffs_richness_multiplier), 0, 1) * 100"
    },
    {
        type = "noise-expression",
        name = "lava-elevation",
        intended_property = "elevation",
        -- Uses map_seed so different seeds produce different lava/island layouts.
        -- multioctave_noise gives more natural terrain variation than single basis_noise.
        expression = [[
            max(
                multioctave_noise{
                    x = x, y = y,
                    seed0 = map_seed, seed1 = 40000,
                    octaves = 3, persistence = 0.6,
                    input_scale = 1/300, output_scale = 1
                },
                0
            ) * 5 - (9.4 * (5 - 1))
        ]]
    }
}
