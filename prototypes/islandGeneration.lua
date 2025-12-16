require("noise-expressions/lava-block-generator")
local util = require("util")



local lava_block_island_preset = {
    order = "i",
    basic_settings = {
        property_expression_names =
        {
            elevation = "lava-elevation",
            moisture = "moisture_basic",
            aux = "aux_basic",
            cliffiness = "lava-cliffiness",
            cliff_elevation = "cliff_elevation_from_elevation",
            trees_forest_path_cutout = 1
        },
        cliff_settings =
        {
            cliff_smoothing = 1
        },
        territory_settings =
        {
            units = { "small-demolisher", "medium-demolisher", "big-demolisher" },
            territory_index_expression = "demolisher_territory_expression",
            territory_variation_expression = "demolisher_variation_expression",
            minimum_territory_size = 10
        },
        autoplace_controls = {
            ["enemy-base"] = {
                size = 200,    -- Much larger enemy bases
                frequency = 6, -- Much more frequent enemy bases
                richness = 6   -- Richer/bigger individual bases
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
-- Deepcopy nauvis so we don't modify the original
local nauvis_copy = table.deepcopy(data.raw["planet"]["nauvis"])
nauvis_copy.map_gen_settings.autoplace_controls["water"] = nil
nauvis_copy.map_gen_settings.autoplace_controls["deepwater"] = nil

nauvis_copy.map_gen_settings.default_enable_all_autoplace_controls = false
nauvis_copy.map_gen_settings.autoplace_controls = {
    ["enemy-base"] = {
        size = 200,    -- Much larger enemy bases (was 20)
        frequency = 6, -- Much more frequent enemy bases
        richness = 6   -- Richer/bigger individual bases
    },
    ["trees"] = { size = 0 },
}
nauvis_copy.map_gen_settings.autoplace_settings.tile.settings = {}
nauvis_copy.map_gen_settings.autoplace_settings.tile.settings["lava"] = {}
nauvis_copy.map_gen_settings.autoplace_settings.tile.settings["grass-1"] = {}





--Inserting the new map preset without altering the others
data.raw["map-gen-presets"].default["lava-block-island"] = lava_block_island_preset

data:extend {
    nauvis_copy,
}