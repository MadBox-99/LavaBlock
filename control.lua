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
	-- Only call freeplay startup configs if the mod is in freeplay mode instead of scenarios
	if remote.interfaces["freeplay"] ~= nil then
		remote.call("freeplay", "set_disable_crashsite", true)
		remote.call("freeplay", "set_skip_intro", true)
	end

	-- Forcing the starting block to not contain water.
	local surface = game.get_surface("nauvis")
end)

-- Adding starting items & display helpful hints
script.on_event(defines.events.on_player_created, function(event)
	local player = game.get_player(event.player_index)

	--Skip providing items for mods that have you spawn with items.
	if util.mod_table["nullius"] == nil then
		player.insert { name = "burner-mining-drill", count = 9 }
		player.insert { name = "stone-furnace", count = 9 }
		player.insert { name = "coal", count = 50 }
		player.insert { name = "wooden-chest", count = 50 }
	end

	player.print({ "lava-block.on-start-mechanics-explanation-1" })
	player.print({ "lava-block.on-start-mechanics-explanation-2" })
	player.print({ "lava-block.on-start-mechanics-explanation-3" })
	player.print({ "lava-block.on-start-mechanics-explanation-4" })
	player.print({ "lava-block.on-start-mechanics-explanation-5" })
end)

-- Replace tiles outside the 25x25 water area with lava
script.on_event(defines.events.on_chunk_generated, function(event)
	local surface = event.surface
	local area = event.area

	local tiles_to_replace = {}
	local tile_index = 1

	for x = area.left_top.x, area.right_bottom.x - 1 do
		for y = area.left_top.y, area.right_bottom.y - 1 do
			-- Only place lava outside the 25x25 area (beyond coordinates ±12.5)
			if (math.abs(x) > 12.5 or math.abs(y) > 12.5) then
				local tile = surface.get_tile(x, y)
				-- Replace any non-water tile with lava (so grass, dirt, etc. become lava)
				if tile.name ~= "water" and tile.name ~= "deepwater" and tile.name ~= "lava" then
					tiles_to_replace[tile_index] = { name = "lava", position = { x, y } }
					tile_index = tile_index + 1
				end
			end
		end
	end

	if #tiles_to_replace > 0 then
		surface.set_tiles(tiles_to_replace)
	end
end)
--[[ script.on_event(defines.events.on_player_joined_game, function(e)
	local player = game.players[e.player_index]
	if player.surface.name == "nauvis" then
		game.players[e.player_index].force.set_spawn_position({ x = 0, y = 0 }, game.surfaces["nauvis"])
	end
end) ]]
