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
	local tiles = {}
	local tileIndex = 0
	local island_size = settings.global["lava-block-starting-island-size"].value
	local island_radius = 0

	--local minDist = -island_size + 1
	--local maxDist = island_size

	--Initializing these variabls so they're inscope
	local minDist = 0
	local maxDist = 0

	--Even sized island, leans positive X/Y from origin
	if (island_size % 2) == 0 then
		island_radius = island_size / 2
		minDist = -island_radius + 1
		maxDist = island_radius
	else
		--Odd sized island, centered on the origin
		island_radius = (island_size - 1) / 2
		minDist = -island_radius
		maxDist = island_radius
	end

	for x = minDist, maxDist do
		for y = minDist, maxDist do
			local current_tile = surface.get_tile(x, y)
			if current_tile.name == "water" then
				tiles[tileIndex] = { name = 'grass-1', position = { x, y } }
				tileIndex = tileIndex + 1
			end
		end
	end

	surface.set_tiles(tiles)

	-- If the player enabled starting with all landfill island we convert the square here.
	if settings.global["lava-block-landfill-starting-island"].value == true then
		--Forcing water tiles to be under the starting island
		tiles = {}
		tileIndex = 0

		-- If the starting area is set to be smaller than the default island size (50) we need to increase the erasing area to 50 to ensure the starting zone is sized correctly
		local waterPlacementMinDist = minDist
		local waterPlacementMaxDist = maxDist
		if (island_radius < 25) then
			waterPlacementMinDist = (-25) + 1
			waterPlacementMaxDist = 25
		end

		for x = waterPlacementMinDist, waterPlacementMaxDist do
			for y = waterPlacementMinDist, waterPlacementMaxDist do
				tiles[tileIndex] = { name = 'lava', position = { x, y } }
				tileIndex = tileIndex + 1
			end
		end

		surface.set_tiles(tiles)

		--Forcing landfill on top
		tiles = {}
		tileIndex = 0

		for x = minDist, maxDist do
			for y = minDist, maxDist do
				tiles[tileIndex] = { name = 'landfill', position = { x, y } }
				tileIndex = tileIndex + 1
			end
		end

		surface.set_tiles(tiles)
	end
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

	player.print({ "factories-in-tight-spaces.on-start-mechanics-explanation-1" })
	player.print({ "factories-in-tight-spaces.on-start-mechanics-explanation-2" })
	player.print({ "factories-in-tight-spaces.on-start-mechanics-explanation-3" })
	player.print({ "factories-in-tight-spaces.on-start-mechanics-explanation-4" })
	player.print({ "factories-in-tight-spaces.on-start-mechanics-explanation-5" })
end)
--[[ script.on_event(defines.events.on_player_joined_game, function(e)
	local player = game.players[e.player_index]
	if player.surface.name == "nauvis" then
		game.players[e.player_index].force.set_spawn_position({ x = 0, y = 0 }, game.surfaces["nauvis"])
	end
end) ]]
