local util = require("util")

-- Map Generation with 5x5 starting island, 25x25 water area, control.lua handles lava

data:extend {
	{
		type = "noise-expression",
		name = util.mod_prefix .. "three-zone-elevation",
		intended_property = "elevation",
		-- 5x5 island: high elevation (land)
		-- 25x25 water area: low elevation (water)
		-- Everything else: high elevation (land, will be converted to lava by control.lua)
		expression = "if(abs(x)<=2.5, 100, if(abs(x)<=12.5, -200, 100)) + if(abs(y)<=2.5, 100, if(abs(y)<=12.5, -200, 100)) - 50"
	}
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
			["water"] = { size = 0 }
		},
	},
	advanced_settings = {
		pollution = { enabled = false },
		enemy_evolution = { enabled = false },
		enemy_expansion = { enabled = false }
	}
}

--Inserting the new map preset without altering the others
data.raw["map-gen-presets"].default[util.mod_prefix .. "island"] = lava_block_island_preset
