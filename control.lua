local util = require("util")
local created_items = { ["pistol"] = 1, ["firearm-magazine"] = 10 }
local function research_technology_for_all_forces(tech_name)
	for _, force in pairs(game.forces) do
		if force.technologies[tech_name] then
			force.technologies[tech_name].researched = true
		end
	end
end

script.on_init(function()
	research_technology_for_all_forces("steam-power")
end)
--Disabling crash-site to avoid player obligation to keep it and to make the on player created function work.
script.on_init(function()
	-- Create 25x25 landfill area at spawn
	local surface = game.get_surface("nauvis")
	if surface then
		for x = -12, 12 do
			for y = -12, 12 do
				surface.set_tiles({ { name = "landfill", position = { x, y } } })
			end
		end
	end

	-- Only call freeplay startup configs if the mod is in freeplay mode instead of scenarios
	if remote.interfaces["freeplay"] ~= nil then
		remote.call("freeplay", "set_disable_crashsite", true)
		remote.call("freeplay", "set_skip_intro", true)
	end
end)

-- Adding starting items & display helpful hints
script.on_event(defines.events.on_player_created, function(event)
	local player = game.get_player(event.player_index)
	player.clear_items_inside()

	player.insert { name = "chemical-plant", count = 1 }
	player.insert { name = "solar-panel", count = 1 }
	player.insert { name = "small-electric-pole", count = 1 }
	player.insert { name = "iron-gear-wheel", count = 2 }
	player.insert { name = "pipe", count = 3 }

	player.print({ "lava-block.on-start-mechanics-explanation-1" })
	player.print({ "lava-block.on-start-mechanics-explanation-2" })
	player.print({ "lava-block.on-start-mechanics-explanation-3" })
	player.print({ "lava-block.on-start-mechanics-explanation-4" })
	player.print({ "lava-block.on-start-mechanics-explanation-5" })
end)
