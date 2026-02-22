-- Pyroclast planet noise expressions
-- Factorio 2.0 compatible: all expressions are string-based
--
-- Key differences from Nauvis LavaBlock approach:
--   1. Uses map_seed → different terrain every game (like base game planets)
--   2. Uses multioctave_noise → richer, more varied volcanic terrain
--   3. Cliffiness uses map_seed for local variation in cliff placement

data:extend({
    -- Rock probability expressions for huge-volcanic-rock and big-volcanic-rock.
    -- Both entities hardcode autoplace.probability_expression in their definitions,
    -- so we override them via property_expression_names in the planet map_gen_settings.
    --
    -- aux (= pyroclast-aux): 0 = rocky/basalt, 1 = ashy
    -- vulcanus_rock_noise: generic multioctave noise from space-age (seed0=map_seed, ≈ ±0.4)
    {
        type = "noise-expression",
        name = "pyroclast_rock_huge",
        -- Rare large rocks in rocky zones (aux < 0.35).  At aux=0: max ≈ 0.20.
        expression = "min(0.20, clamp(0.35 - aux, 0, 0.35) + vulcanus_rock_noise - 0.20)"
    },
    {
        type = "noise-expression",
        name = "pyroclast_rock_big",
        -- More common medium rocks, wider rocky zone (aux < 0.45).  At aux=0: max ≈ 0.35.
        expression = "min(0.35, clamp(0.45 - aux, 0, 0.45) + vulcanus_rock_noise - 0.15)"
    },
    -- Geyser generation — mirrors Aquilo's fluorine-vent pattern exactly:
    --   1. spot_size constant  (controls cluster radius at default size slider)
    --   2. pyroclast_geyser_spot helper function  (wraps spot_noise with biome favourability)
    --   3. _spots expressions  (one per type, different seed / skip_offset so they never overlap)
    --   4. _prob / _rich expressions  (thin wrappers used in property_expression_names)
    --
    -- spot radius = spot_size * sqrt(size_slider)  →  scales with the size slider
    -- probability per tile inside a spot = 0.012  (≈ same as aquilo fluorine vent 0.008)
    -- region_size = 300 + 200 / freq  →  default (freq=1): ~2 clusters per 500×500 tiles per type
    {
        type = "noise-expression",
        name = "pyroclast_geyser_spot_size",
        -- Radius in tiles at size=1.  Cluster area ≈ π·20² ≈ 1256 tiles → ~15 geysers per cluster.
        expression = 20
    },
    {
        -- Helper: identical to aquilo_spot_noise but with rocky-biome favourability.
        -- Spots are only placed where aux < 0.25 (= volcanic-smooth-stone zone).
        type = "noise-function",
        name = "pyroclast_geyser_spot",
        parameters = {"seed", "count", "skip_off", "freq", "radius"},
        expression = "spot_noise{x = x, y = y,\z
                                 seed0 = map_seed, seed1 = seed,\z
                                 candidate_spot_count = count,\z
                                 suggested_minimum_candidate_point_spacing = 128,\z
                                 skip_span = 2, skip_offset = skip_off,\z
                                 region_size = 300 + 200 / freq,\z
                                 density_expression = 1,\z
                                 spot_quantity_expression = radius * radius,\z
                                 spot_radius_expression = radius,\z
                                 hard_region_target_quantity = 0,\z
                                 spot_favorability_expression = clamp(0.25 - aux, 0, 0.25) * 4,\z
                                 basement_value = -1,\z
                                 maximum_spot_basement_radius = radius * 2}"
    },
    {
        type = "noise-expression",
        name = "pyroclast_iron_geyser_spots",
        -- skip_off=0 → uses candidates 0, 2 from each region (2 clusters per 500×500 default)
        expression = "pyroclast_geyser_spot{seed = 23000, count = 3, skip_off = 0,\z
                                            freq = control:pyroclast_iron_geyser:frequency,\z
                                            radius = pyroclast_geyser_spot_size * sqrt(control:pyroclast_iron_geyser:size)}"
    },
    {
        type = "noise-expression",
        name = "pyroclast_copper_geyser_spots",
        -- skip_off=1 → uses candidate 1 from each region (1 cluster per 500×500 default)
        -- Different seed too, so clusters never coincide with iron ones.
        expression = "pyroclast_geyser_spot{seed = 47000, count = 3, skip_off = 1,\z
                                            freq = control:pyroclast_copper_geyser:frequency,\z
                                            radius = pyroclast_geyser_spot_size * sqrt(control:pyroclast_copper_geyser:size)}"
    },
    {
        type = "noise-expression",
        name = "pyroclast_iron_geyser_prob",
        expression = "(control:pyroclast_iron_geyser:size > 0)\z
                      * max(0, pyroclast_iron_geyser_spots) * 0.012"
    },
    {
        type = "noise-expression",
        name = "pyroclast_iron_geyser_rich",
        expression = "max(0, pyroclast_iron_geyser_spots) * 300000 * control:pyroclast_iron_geyser:richness"
    },
    {
        type = "noise-expression",
        name = "pyroclast_copper_geyser_prob",
        expression = "(control:pyroclast_copper_geyser:size > 0)\z
                      * max(0, pyroclast_copper_geyser_spots) * 0.012"
    },
    {
        type = "noise-expression",
        name = "pyroclast_copper_geyser_rich",
        expression = "max(0, pyroclast_copper_geyser_spots) * 300000 * control:pyroclast_copper_geyser:richness"
    },
    {
        -- Biome variation noise: low=rocky, high=ashy (0 to 1)
        type = "noise-expression",
        name = "pyroclast-aux",
        intended_property = "aux",
        expression = [[
            clamp(
                multioctave_noise{
                    x = x, y = y,
                    seed0 = map_seed, seed1 = 91000,
                    octaves = 4, persistence = 0.6,
                    input_scale = 1/150, output_scale = 0.5
                } + 0.5,
                0, 1
            )
        ]]
    },
    {
        type = "noise-expression",
        name = "pyroclast-cliffiness",
        intended_property = "cliffiness",
        -- Cliff density grows with distance from spawn (tier), scaled by map cliff settings.
        -- Local variation from map_seed makes cliff clusters look more natural.
        expression = [[
            clamp(
                (tier - 0.15) * ceil(control_setting_cliffs_richness_multiplier),
                0, 1
            ) * 120
            + multioctave_noise{
                x = x, y = y,
                seed0 = map_seed, seed1 = 55000,
                octaves = 3, persistence = 0.5,
                input_scale = 1/120, output_scale = 20
            }
        ]]
    },
    {
        type = "noise-expression",
        name = "pyroclast-elevation",
        intended_property = "elevation",
        -- multioctave_noise with map_seed: different terrain every game.
        -- 4 octaves at scale 1/300 gives large volcanic features + smaller details.
        -- persistence=0.6 means each octave adds ~60% of the previous layer's amplitude.
        -- Result: mostly lava (negative), with scattered rocky formations (positive).
        expression = [[
            max(
                multioctave_noise{
                    x = x, y = y,
                    seed0 = map_seed, seed1 = 71000,
                    octaves = 4, persistence = 0.6,
                    input_scale = 1/300, output_scale = 1
                },
                0
            ) * 5 - (9.4 * (5 - 1))
        ]]
    }
})
