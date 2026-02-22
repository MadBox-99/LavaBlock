require("prototypes.noise-expressions.pyroclast-generator")

local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

data:extend({
    {
        type = "planet",
        name = "pyroclast",
        -- Dark volcanic tint on Vulcanus icon (reused graphics)
        icons = {
            {
                icon = "__space-age__/graphics/icons/vulcanus.png",
                icon_size = 64,
                tint = { r = 0.12, g = 0.08, b = 0.08, a = 1 }
            }
        },
        starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
        starmap_icon_size = 512,
        -- gravity_pull: used for space platform fuel calculations (higher = more fuel)
        gravity_pull = 15,
        distance = 15,
        orientation = 0.25,
        magnitude = 1.2,
        order = "c[pyroclast]",
        subgroup = "planets",
        pollutant_type = nil,
        -- Solar power while orbiting (further from star = less solar power)
        solar_power_in_space = 400,
        surface_properties = {
            ["day-night-cycle"] = 0,     -- Tidally locked (no day/night cycle)
            ["magnetic-field"] = 10,
            ["solar-power"] = 200,
            pressure = 6000,             -- Higher than Vulcanus (4000)
            gravity = 60,                -- Higher than Vulcanus (40)
        },
        -- Landing/departure animations (reuse Vulcanus volcanic animations)
        platform_procession_set = {
            arrival = { "planet-to-platform-b" },
            departure = { "platform-to-planet-a" }
        },
        planet_procession_set = {
            arrival = { "platform-to-planet-b" },
            departure = { "planet-to-platform-a" }
        },
        asteroid_spawn_influence = 1,
        -- 0.9 = position along nauvis_vulcanus route → returns simplified orbital format for planet surface
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus, 0.9),
        map_gen_settings = {
            property_expression_names = {
                elevation = "pyroclast-elevation",
                moisture = "moisture_basic",
                aux = "pyroclast-aux",
                cliffiness = "pyroclast-cliffiness",
                cliff_elevation = "cliff_elevation_from_elevation",
                trees_forest_path_cutout = 1,
                -- Override the Vulcanus-specific rock expressions with Pyroclast versions
                ["entity:huge-volcanic-rock:probability"] = "pyroclast_rock_huge",
                ["entity:big-volcanic-rock:probability"]  = "pyroclast_rock_big",
                -- Molten-metal geysers (entity autoplace = 0 by default, overridden here)
                ["entity:molten-iron-geyser:probability"]    = "pyroclast_iron_geyser_prob",
                ["entity:molten-iron-geyser:richness"]       = "pyroclast_iron_geyser_rich",
                ["entity:molten-copper-geyser:probability"]  = "pyroclast_copper_geyser_prob",
                ["entity:molten-copper-geyser:richness"]     = "pyroclast_copper_geyser_rich",
            },
            cliff_settings = {
                -- Less smoothing = more jagged, dramatic volcanic cliffs
                cliff_smoothing = 0.5,
            },
            territory_settings = {
                units = { "small-demolisher", "medium-demolisher", "big-demolisher" },
                territory_index_expression = "demolisher_territory_expression",
                territory_variation_expression = "demolisher_variation_expression",
                minimum_territory_size = 10
            },
            autoplace_controls = {
                ["enemy-base"] = {
                    size = 150,
                    frequency = 4,
                    richness = 4
                },
                ["trees"] = { size = 0 },
                ["water"] = { size = 0 },
                -- Pyroclast-specific geyser controls (map-gen sliders)
                ["pyroclast_iron_geyser"]   = {},
                ["pyroclast_copper_geyser"] = {},
            },
            default_enable_all_autoplace_controls = false,
            autoplace_settings = {
                tile = {
                    treat_missing_as_default = false,
                    settings = {
                        ["lava"] = {},
                        -- Tiny habitable patches (same as Nauvis LavaBlock)
                        ["grass-1"] = {},
                        -- Volcanic biome tiles (probability overridden in data-final-fixes.lua)
                        ["volcanic-smooth-stone"] = {},
                        ["volcanic-ash-soil"] = {},
                        ["volcanic-ash-dark"] = {},
                        ["volcanic-folds"] = {},
                        -- Sulfuric acid lakes: pumpable with offshore pump
                        ["sulfuric-acid-lake"] = {},
                    }
                },
                entity = {
                    treat_missing_as_default = false,
                    settings = {
                        -- Minable volcanic rocks; probability driven by pyroclast_rock_* expressions
                        ["huge-volcanic-rock"]    = {},
                        ["big-volcanic-rock"]     = {},
                        -- Molten-metal geysers; mined by offshore pump
                        ["molten-iron-geyser"]   = {},
                        ["molten-copper-geyser"] = {},
                    }
                },
            }
        },
    },
    -- Space connection: Vulcanus → Pyroclast (late-game volcanic route)
    -- Longer than standard routes (20000 vs 15000) due to greater distance
    -- Note: icons defined explicitly because Pyroclast uses 'icons' (not 'icon'),
    --       which bypasses Space Age's auto-icon generation in data-updates.lua
    {
        type = "space-connection",
        name = "vulcanus-pyroclast",
        subgroup = "planet-connections",
        from = "vulcanus",
        to = "pyroclast",
        order = "z[vulcanus-pyroclast]",
        length = 20000,
        icons = {
            { icon = "__space-age__/graphics/icons/planet-route.png", icon_size = 64 },
            { icon = "__space-age__/graphics/icons/vulcanus.png", icon_size = 64,
              scale = 0.333, shift = { -6, -6 } },
            { icon = "__space-age__/graphics/icons/vulcanus.png", icon_size = 64,
              scale = 0.333, shift = { 6, 6 },
              tint = { r = 0.12, g = 0.08, b = 0.08, a = 1 } },
        },
        -- no planet parameter → returns spawn_points format required for space-connection routes
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus),
    },
})
