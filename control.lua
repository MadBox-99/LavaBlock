local util = require("util")

-- Check if player is wearing lava-mech-armor
local function is_wearing_lava_mech_armor(player)
    if not player.character then return false end
    local armor_inventory = player.get_inventory(defines.inventory.character_armor)
    if not armor_inventory or armor_inventory.is_empty() then return false end
    local armor = armor_inventory[1]
    return armor and armor.valid and armor.name == "lava-mech-armor"
end

-- Update player speed based on armor
local function update_player_speed(player)
    if not player or not player.character then return end

    if is_wearing_lava_mech_armor(player) then
        -- Extremely slow - 90% speed reduction
        player.character_running_speed_modifier = -0.9
    else
        player.character_running_speed_modifier = 0
    end
end

-- Helper function to disable freeplay crashsite and intro
local function disable_freeplay()
    if remote.interfaces["freeplay"] then
        remote.call("freeplay", "set_disable_crashsite", true)
        remote.call("freeplay", "set_skip_intro", true)
        remote.call("freeplay", "set_created_items", {})
        remote.call("freeplay", "set_respawn_items", {})
    end
end

-- Helper function to give starting items to a player
local function give_starting_items(player)
    -- Give starting items
    player.insert({ name = "chemical-plant", count = 1 })
    player.insert({ name = "solar-panel", count = 2 })
    player.insert({ name = "small-electric-pole", count = 1 })
    player.insert({ name = "iron-gear-wheel", count = 2 })
    player.insert({ name = "pipe", count = 3 })

    -- Equip lava-mech-armor if setting is enabled and item exists
    if settings.global["lava-block-mech-armor-start"].value and prototypes.item["lava-mech-armor"] then
        player.insert({ name = "lava-mech-armor", count = 1 })
    end

    -- Display helpful hints
    player.print({ "lava-block.on-start-mechanics-explanation-1" })
    player.print({ "lava-block.on-start-mechanics-explanation-2" })
    player.print({ "lava-block.on-start-mechanics-explanation-3" })
end

-- Disable a recipe for a specific force
local function disable_recipe_for_force(force, recipe_name)
    local recipes = force.recipes
    if recipes[recipe_name] then
        recipes[recipe_name].enabled = false
        game.print({ "lava-block.recipe-disabled", {"recipe-name." .. recipe_name} })
    end
end

-- Get technology effects (handles both LuaTechnology and LuaTechnologyPrototype)
local function get_tech_effects(technology)
    if technology.object_name == "LuaTechnology" then
        return technology.prototype.effects
    end
    return technology.effects
end

-- Initialize game on first load
script.on_init(function()
    storage.players_needing_items = {}

    -- Disable crashsite and intro FIRST
    disable_freeplay()

    -- Research steam power for all forces
    util.research_technology_for_all_forces("steam-power")

    -- Create 25x25 landfill area at spawn
    local surface = game.get_surface("nauvis")
    if surface then
        local tiles = {}
        for x = -12, 12 do
            for y = -12, 12 do
                table.insert(tiles, { name = "landfill", position = { x, y } })
            end
        end
        surface.set_tiles(tiles)
    end
end)

-- Handle mod updates on existing saves
script.on_configuration_changed(function(data)
    storage.players_needing_items = storage.players_needing_items or {}
    disable_freeplay()

    -- Re-apply recipe disable for all researched technologies with disable-recipe effects
    for _, force in pairs(game.forces) do
        for _, tech in pairs(force.technologies) do
            local effects = get_tech_effects(tech)
            if tech.researched and effects then
                for _, effect in pairs(effects) do
                    if effect.type == "nothing" and effect.effect_description then
                        local desc = effect.effect_description
                        if desc[1] == "technology-effect.disable-recipe" then
                            local recipe_name = desc[2]
                            -- Silently disable without printing message
                            if force.recipes[recipe_name] then
                                force.recipes[recipe_name].enabled = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Give starting items when player is created
script.on_event(defines.events.on_player_created, function(event)
    storage.players_needing_items[event.player_index] = true
end)

-- Give items when cutscene is cancelled (skip intro)
script.on_event(defines.events.on_cutscene_cancelled, function(event)
    if not storage.players_needing_items[event.player_index] then
        return
    end
    local player = game.get_player(event.player_index)
    if player then
        give_starting_items(player)
    end
    storage.players_needing_items[event.player_index] = nil
end)

-- Fallback: give items on tick if cutscene was skipped entirely
script.on_event(defines.events.on_tick, function(event)
    if not storage.players_needing_items or not next(storage.players_needing_items) then return end

    -- Wait for freeplay to finish its setup
    if event.tick < 30 then return end

    for player_index, _ in pairs(storage.players_needing_items) do
        local player = game.get_player(player_index)
        if player then
            give_starting_items(player)
        end
        storage.players_needing_items[player_index] = nil
    end
end)

-- Handle technology effects (disable-recipe via "nothing" effect type)
script.on_event(defines.events.on_research_finished, function(event)
    local force = event.research.force
    local effects = get_tech_effects(event.research)
    if not effects then return end
    for _, effect in pairs(effects) do
        if effect.type == "nothing" and effect.effect_description then
            local desc = effect.effect_description
            if desc[1] == "technology-effect.disable-recipe" then
                local recipe_name = desc[2]
                disable_recipe_for_force(force, recipe_name)
            end
        end
    end
end)

-- Update speed when armor changes
script.on_event(defines.events.on_player_armor_inventory_changed, function(event)
    local player = game.get_player(event.player_index)
    update_player_speed(player)
end)

-- Update speed when player respawns
script.on_event(defines.events.on_player_respawned, function(event)
    local player = game.get_player(event.player_index)
    update_player_speed(player)
end)

