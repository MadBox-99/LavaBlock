local utils = require("lib.utils")
require("__core__.lualib.util")
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.assemblerpipes")

-- Base on centrifuge
local lava_centrifuge = table.deepcopy(data.raw["assembling-machine"]["centrifuge"])
lava_centrifuge.name = "lava-centrifuge"
lava_centrifuge.minable.result = "lava-centrifuge"

-- Same icon as the item, so alt-mode and Factoriopedia match the new model
lava_centrifuge.icon = "__LavaBlock__/graphics/icons/items/lava-centrifuge.png"
lava_centrifuge.icon_size = 64
lava_centrifuge.icons = nil

-- Custom crafting category for lava centrifuge recipes
lava_centrifuge.crafting_categories = { "lava-centrifuge" }

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
-- Orthographic camera at 45 deg elevation, 6 tile frame at 384 px => 64 px per
-- tile, so scale = 32/64 = 0.5. Sheets are cropped to the union bounding box of
-- all frames, and `shift` is the crop centre's offset from the entity origin.
-- The rotor turns 120 deg over the 32 frames; the three arms are 120 deg apart,
-- so the loop is seamless.
local GFX = "__LavaBlock__/graphics/entity/lava-centrifuge/"

-- One sheet pair per facing. The fluid connections rotate with the entity, so
-- the modelled pipe stubs have to rotate with them; a single sheet would leave
-- the stubs pointing the wrong way on any rotated machine.
--
-- Dimensions and shift come from the data files spritter writes next to each
-- sheet, so a re-pack never needs numbers copied by hand. Every facing is
-- cropped on its own, which is why they differ.
local function layer(kind, dir, extra)
    local name = "lava-centrifuge-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock__/graphics/entity/lava-centrifuge/" .. name)
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

local function spin_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

-- No idle_animation on purpose: Factorio requires it to have the same frame
-- count as `animation`, and with `animation` alone the machine simply freezes
-- on its current frame when it stops crafting, which is what we want.
lava_centrifuge.graphics_set = {
    animation = {
        north = { layers = spin_layers("north") },
        east = { layers = spin_layers("east") },
        south = { layers = spin_layers("south") },
        west = { layers = spin_layers("west") },
    },
    working_visualisations = {
        {
            fadeout = true,
            light = {
                intensity = 0.45,
                size = 6,
                shift = { 0, -0.2 },
                color = { r = 1.0, g = 0.45, b = 0.12 },
            },
        },
    },
}

-- Smoke off the spindle. The positions are the topmost opaque pixel of each
-- facing's own sheet, measured rather than calculated; the spindle is over
-- the centre, so they barely move as the machine turns.
for _, v in pairs(utils.stack_smoke({
    north = { -0.05, -2.28 },
    east = { 0.00, -2.25 },
    south = { 0.03, -2.28 },
    west = { -0.01, -2.36 },
})) do
    table.insert(lava_centrifuge.graphics_set.working_visualisations, v)
end

-- Energy and performance settings
lava_centrifuge.energy_usage = "500kW"
lava_centrifuge.crafting_speed = 1
lava_centrifuge.module_slots = 4

-- Add fluid boxes for lava input and secondary fluid input
-- The east and south pipe graphics sit correctly against the model; only the
-- north one is a problem, because the machine is tall enough that its body
-- covers the north connection tile, so the pipe ends up drawn across the
-- glowing drum. secondary_draw_orders pushes it behind the entity, which is
-- exactly what assembling machine 2 and 3 do with their north connections.
local PIPE_BEHIND_AT_NORTH = { north = -1 }

lava_centrifuge.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } }
        },
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        secondary_draw_orders = PIPE_BEHIND_AT_NORTH,
        volume = 2000,
    },
    {
        production_type = "input",
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.east, position = { 1, 0 } }
        },
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        secondary_draw_orders = PIPE_BEHIND_AT_NORTH,
        volume = 1000,
    },
    {
        production_type = "output",
        pipe_connections = {
            { flow_direction = "output", direction = defines.direction.south, position = { 0, 1 } }
        },
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        secondary_draw_orders = PIPE_BEHIND_AT_NORTH,
        volume = 2000,
    },
}

return lava_centrifuge
