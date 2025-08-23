local util = require("util")


-- Map Generation

local island_size = 25
-- The "-200" at the end of the elevation definition requires BOTH clauses to be true while also making the water deep enough for fish to spawn.
local island_noise_expression = "if(abs(x)<=" .. island_size .. ", 100, 0) + if(abs(y)<=" ..
	island_size .. ", 100, 0) - 200"

--We can't use a runtime-variable here, so the options are to: Switch to a 'startup' setting (which requires a restart to change), or to have the mapgen look incorrect but allow the user to resize the island by creating a new map.
--local island_noise_expression = "if(abs(x)<=var('lava-block-starting-island-size'), 100, 0) + if(abs(y)<=var('lava-block-starting-island-size'), 100, 0) - 200"

data:extend {
	{
		type = "noise-expression",
		name = util.mod_prefix .. "square-island",
		intended_property = "elevation",
		expression = island_noise_expression
	}
}

-- Adding misc auto-place controls
local empty_autoplace_controls = {
	["enemy-base"] = { size = 0 },
	["trees"] = { size = 0 }

}

-- Add auto-place settings for all of the infinite resources
for _, resoure in pairs(util.resources_to_clone) do
	--Updating names for when the resource name and entity name don't match	
	if resoure == "nullius-fumarole" then
		resoure = "nullius-geothermal"
	end

	if util.mod_table["bzlead"] ~= nil then
		if resoure == "lead" then
			resoure = "lead-ore"
		end
	end

	if util.mod_table["bztitanium"] ~= nil then
		if resoure == "titanium" then
			resoure = "titanium-ore"
		end
	end

	empty_autoplace_controls[resoure] = { size = 0 }
end

local lava_block_island_preset                                   = {
	order = "i",
	basic_settings = {
		property_expression_names = {
			elevation                             = util.mod_prefix .. "square-island",
			-- This turns off ALL ore placement, enemy placement, and tree placement
			default_enable_all_autoplace_controls = false,
		},
		autoplace_controls = empty_autoplace_controls,
	},
	advanced_settings = {
		pollution       = {
			enabled = false
		},
		enemy_evolution = {
			enabled = false
		},
		enemy_expansion = {
			enabled = false
		}
	}
}

--Inserting the new map preset without altering the others
data.raw["map-gen-presets"].default[util.mod_prefix .. "island"] = lava_block_island_preset
