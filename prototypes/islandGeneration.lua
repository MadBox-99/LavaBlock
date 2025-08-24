local util = require("util")

local three_zone_elevation = {
	type = "noise-expression",
	name = util.mod_prefix .. "three-zone-elevation",
	intended_property = "elevation",
	expression =
	"if(sqrt(x*x + y*y)<=2.5, 100, if(sqrt(x*x + y*y)<=12.5, -200, 100)) - 50"
}

local lava_block_island_preset = {
	order = "i",
	basic_settings = {
		property_expression_names = {
			elevation = util.mod_prefix .. "three-zone-elevation",
			default_enable_all_autoplace_controls = false,
		},
		autoplace_controls = {
			["enemy-base"] = { size = 0 },
			["trees"] = { size = 0 },
			["water"] = { size = 0 },
		},
	},
	advanced_settings = {
		pollution = { enabled = false },
		enemy_evolution = { enabled = false },
		enemy_expansion = { enabled = false }
	}
}
-- Deepcopy nauvis so we don't modify the original
local nauvis_copy = table.deepcopy(data.raw["planet"]["nauvis"])
nauvis_copy.map_gen_settings.autoplace_controls["water"] = nil
nauvis_copy.map_gen_settings.autoplace_controls["deepwater"] = nil

nauvis_copy.map_gen_settings.default_enable_all_autoplace_controls = false
nauvis_copy.map_gen_settings.autoplace_controls = {
	["enemy-base"] = { size = 0 },
	["trees"] = { size = 0 },
}
nauvis_copy.map_gen_settings.autoplace_settings.tile.settings = {}
nauvis_copy.map_gen_settings.autoplace_settings.tile.settings["lava"] = {}




--Inserting the new map preset without altering the others
data.raw["map-gen-presets"].default[util.mod_prefix .. "island"] = lava_block_island_preset

data:extend {
	three_zone_elevation,
}
data:extend({ nauvis_copy, })
