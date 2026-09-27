-- Island link poles take at most two copper wires.
--
-- Factorio has no per-pole wire limit and no event for a wire being
-- connected, so the limit is kept two ways: whenever any electric pole is
-- built, the link poles it may have auto-connected to are trimmed at once,
-- and every second all link poles are checked for wires a player dragged on
-- by hand. When a pole has more than two, wires to other link poles are
-- kept first - the line across the lava is the point of the pole - and the
-- rest are cut.

local NAME = "island-link-pole"
local MAX_WIRES = 2
local SWEEP_TICKS = 60

local M = {}

local function poles()
    storage.island_link_poles = storage.island_link_poles or {}
    return storage.island_link_poles
end

local function track(entity)
    poles()[entity.unit_number] = entity
end

-- Cut wires down to MAX_WIRES. Returns true if anything was cut.
local function trim(pole)
    local connector = pole.get_wire_connector(defines.wire_connector_id.pole_copper, false)
    if not connector or connector.connection_count <= MAX_WIRES then
        return false
    end
    local links, others = {}, {}
    for _, connection in pairs(connector.connections) do
        if connection.target.owner.name == NAME then
            links[#links + 1] = connection
        else
            others[#others + 1] = connection
        end
    end
    local kept = 0
    for _, list in ipairs({ links, others }) do
        for _, connection in ipairs(list) do
            if kept < MAX_WIRES then
                kept = kept + 1
            else
                connector.disconnect_from(connection.target, connection.origin)
            end
        end
    end
    return true
end

local function tell(player_index, entity)
    local player = player_index and game.get_player(player_index)
    if player then
        player.create_local_flying_text({
            text = { "lava-block.island-link-pole-full", MAX_WIRES },
            position = entity.position,
        })
    end
end

local function on_built(event)
    local entity = event.entity
    if not (entity and entity.valid) or entity.type ~= "electric-pole" then
        return
    end
    if entity.name == NAME then
        track(entity)
        if trim(entity) then
            tell(event.player_index, entity)
        end
        return
    end
    -- An ordinary pole may have auto-connected to a link pole next to it.
    local connector = entity.get_wire_connector(defines.wire_connector_id.pole_copper, false)
    if not connector then
        return
    end
    for _, connection in pairs(connector.connections) do
        local other = connection.target.owner
        if other.name == NAME and trim(other) then
            tell(event.player_index, other)
        end
    end
end

local function sweep()
    local list = poles()
    for unit, pole in pairs(list) do
        if pole.valid then
            trim(pole)
        else
            list[unit] = nil
        end
    end
end

-- Rebuild the list from the map, for a save that had link poles before
-- this script tracked them.
function M.rescan()
    storage.island_link_poles = {}
    for _, surface in pairs(game.surfaces) do
        for _, pole in pairs(surface.find_entities_filtered({ name = NAME })) do
            track(pole)
        end
    end
end

function M.register()
    local built = {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity,
        defines.events.on_space_platform_built_entity,
        defines.events.script_raised_built,
        defines.events.script_raised_revive,
    }
    for _, id in pairs(built) do
        script.on_event(id, on_built)
    end
    script.on_nth_tick(SWEEP_TICKS, sweep)
end

return M
