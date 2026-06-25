require("prototypes.noise-expressions.lava-block-generator")
local util = require("util")

-- Map generation preset for Lava Block Island
local lava_block_island_preset = {
    order = "i",
    basic_settings = {
        property_expression_names = {
            elevation = "lava-elevation",
            moisture = "moisture_basic",
            aux = "aux_basic",
            cliffiness = "lava-cliffiness",
            cliff_elevation = "cliff_elevation_from_elevation",
            trees_forest_path_cutout = 1
        },
        cliff_settings = {
            cliff_smoothing = 1
        },
        autoplace_controls = {
            -- size is a MapGenSize (valid range 0 / 1/6..6); 6 = max. 200 was invalid.
            ["enemy-base"] = {
                size = 6,
                frequency = 6,
                richness = 6
            },
            ["trees"] = { size = 0 },
            ["water"] = { size = 0 },
        },
    },
    advanced_settings = {
        pollution = { enabled = true },
        enemy_evolution = { enabled = true },
        enemy_expansion = { enabled = true }
    }
}

-- Modified Nauvis settings for Lava Block
local nauvis_copy = table.deepcopy(data.raw["planet"]["nauvis"])
nauvis_copy.map_gen_settings.autoplace_controls["water"] = nil
nauvis_copy.map_gen_settings.autoplace_controls["deepwater"] = nil
---@diagnostic disable-next-line: inject-field
nauvis_copy.map_gen_settings.default_enable_all_autoplace_controls = false
nauvis_copy.map_gen_settings.autoplace_controls = {
    -- size is a MapGenSize (valid range 0 / 1/6..6); 6 = max. 200 was invalid.
    -- Enemies can only spawn on land (positive elevation), i.e. the starting
    -- patch and the scattered grass spots — the lava ocean stays clear.
    ["enemy-base"] = {
        size = 6,
        frequency = 6,
        richness = 6
    },
    ["trees"] = { size = 0 },
}

-- The island terrain MUST live on the planet itself, not only in the map-gen
-- preset. Space Age's planet-based new-game flow uses the planet's
-- property_expression_names as the base, so a preset override is unreliable —
-- without this the planet generated default (full-land) Nauvis.
nauvis_copy.map_gen_settings.property_expression_names = {
    elevation = "lava-elevation",
    moisture = "moisture_basic",
    aux = "aux_basic",
    cliffiness = "lava-cliffiness",
    cliff_elevation = "cliff_elevation_from_elevation",
    trees_forest_path_cutout = 1,
    -- The base "lava" tile autoplaces via Vulcanus-only noise ranges, which
    -- never trigger on Nauvis. Override its probability per-planet so it fills
    -- everything below sea level (negative elevation) with lava.
    ["tile:lava:probability"] = "0 - elevation",
}

nauvis_copy.map_gen_settings.autoplace_settings.tile.settings = {}
nauvis_copy.map_gen_settings.autoplace_settings.tile.settings["lava"] = {}
nauvis_copy.map_gen_settings.autoplace_settings.tile.settings["grass-1"] = {}

-- Register map preset and modified nauvis
data.raw["map-gen-presets"].default["lava-block-island"] = lava_block_island_preset
data:extend({ nauvis_copy })