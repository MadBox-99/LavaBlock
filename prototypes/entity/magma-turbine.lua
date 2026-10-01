-- The magma turbine: fifteen tiles of turbine and generator on one shaft,
-- and the island's version of the fusion generator. Magma plasma goes in at
-- one end, 250 MW and hot molten salt come out of the other.
--
-- A fusion generator underneath, so it behaves exactly like one: the
-- plasma pipes only join a reactor or another turbine, never a pipe, and a
-- turbine passes plasma on to the next one through its far end and its
-- sides the way Space Age's do.
--
-- 10 plasma a second at 25 MJ is the 250 MW. A reactor makes 40, so it
-- runs four of these - one on each of its four plasma nozzles. At two to a
-- reactor, a machine as dear as the reactor left half its nozzles empty.
require("__base__.prototypes.entity.pipecovers")

local turbine = table.deepcopy(data.raw["fusion-generator"]["fusion-generator"])
turbine.name = "magma-turbine"
turbine.localised_name = nil
turbine.factoriopedia_description = nil
turbine.minable = { mining_time = 1, result = "magma-turbine" }
turbine.max_health = 3000
turbine.corpse = "big-remnants"
turbine.fast_replaceable_group = "magma-turbine"
turbine.icon = "__LavaBlock-graphics__/graphics/icons/items/magma-turbine.png"
turbine.icon_size = 64
turbine.icons = nil

turbine.collision_box = { { -1.4, -7.4 }, { 1.4, 7.4 } }
turbine.selection_box = { { -1.5, -7.5 }, { 1.5, 7.5 } }

turbine.energy_source.output_flow_limit = "250MW"
turbine.max_fluid_usage = 10 / 60

-- Plasma in at the south end, and on through the north end and both sides
-- for the next turbine along - the same seven connections as a fusion
-- generator, stretched out over fifteen tiles.
local PLASMA = { "magma-plasma" }
turbine.input_fluid_box = {
    production_type = "input",
    volume = 10,
    volume_reservation_fraction = 0.5,
    filter = "magma-plasma",
    pipe_connections = {
        { flow_direction = "input",  direction = defines.direction.south, position = { -1, 7 },  connection_category = PLASMA },
        { flow_direction = "input",  direction = defines.direction.south, position = { 1, 7 },   connection_category = PLASMA },
        { flow_direction = "output", direction = defines.direction.north, position = { 0, -7 },  connection_category = PLASMA },
        { flow_direction = "output", direction = defines.direction.west,  position = { -1, 0 },  connection_category = PLASMA },
        { flow_direction = "output", direction = defines.direction.east,  position = { 1, 0 },   connection_category = PLASMA },
        { flow_direction = "output", direction = defines.direction.west,  position = { -1, -1 }, connection_category = PLASMA },
        { flow_direction = "output", direction = defines.direction.east,  position = { 1, -1 },  connection_category = PLASMA },
    },
}
-- Hot salt out of the north end, on either side of the plasma port.
turbine.output_fluid_box = {
    production_type = "output",
    volume = 100,
    filter = "molten-salt-hot",
    pipe_covers = pipecoverspictures(),
    pipe_connections = {
        { flow_direction = "output", direction = defines.direction.north, position = { -1, -7 } },
        { flow_direction = "output", direction = defines.direction.north, position = { 1, -7 } },
    },
}

-- Custom model, built and rendered in Blender (see docs/blender-renders.md
-- and tools/blender/magma_turbine.py). The plasma inlet and its high
-- pressure casing at the south end, a big low pressure casing in the
-- middle, and the generator with its exciter at the north end; a governor
-- spinning over the hot end and two fans turning on the generator's back.
--
-- Four sheets, not two: the plasma end and the salt end are different
-- ends, so south is not north seen from behind. The glow of the plasma
-- windows is its own sheet and drawn only while the turbine runs.
local GFX = "__LavaBlock-graphics__/graphics/entity/magma-turbine/"

local function layer(kind, dir, extra)
    local name = "magma-turbine-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/magma-turbine/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        animation_speed = 0.5,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function direction_set(dir)
    return {
        animation = {
            layers = {
                layer("entity", dir),
                layer("shadow", dir, { draw_as_shadow = true }),
            },
        },
        working_light = {
            layers = {
                layer("tint", dir, { blend_mode = "additive", draw_as_glow = true }),
            },
        },
        -- One entry for each of the seven plasma connections. Space Age
        -- draws a hose on the ones in use; the model carries its own ports,
        -- so these stay empty.
        fluid_input_graphics = { {}, {}, {}, {}, {}, {}, {} },
    }
end

turbine.graphics_set = {
    glow_color = { 1.0, 0.45, 0.85, 1 },
    north_graphics_set = direction_set("north"),
    east_graphics_set = direction_set("east"),
    south_graphics_set = direction_set("south"),
    west_graphics_set = direction_set("west"),
}

return turbine
