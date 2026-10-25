-- A hot isostatic press: a furnace inside a pressure vessel, filled with
-- argon and heated until whatever is inside is squeezed solid from every
-- side at once. Vulcanus's machine, and the only one that sinters
-- tungsten carbide and cobalt into cemented carbide.
--
-- Four by four: the vessel standing in its wire-wound frame, the argon
-- bottles behind, the compressor that charges the vessel and the chiller
-- that cools its jacket.
--
-- 3 MW, the arc furnace's draw. The vessel has to be heated past 1300
-- degrees and the compressor has to drive argon up to a thousand
-- atmospheres every cycle, and both are paid for in electricity.
local utils = require("lib.utils")

local machine = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
machine.name = "isostatic-press"
machine.minable = { mining_time = 1, result = "isostatic-press" }
machine.max_health = 800
machine.corpse = "big-remnants"
machine.crafting_categories = { "isostatic-pressing" }
machine.crafting_speed = 1.0
machine.energy_usage = "3MW"
-- Nothing burns here and the argon goes back into the bottles; what it
-- gives off is the furnace's heat and the compressor's oil.
machine.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = 2 },
}
machine.module_slots = 4
machine.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
machine.next_upgrade = nil
machine.fast_replaceable_group = nil

machine.collision_box = { { -1.9, -1.9 }, { 1.9, 1.9 } }
machine.selection_box = { { -2, -2 }, { 2, 2 } }

-- assembling-machine-2's circuit connector is placed for a 3x3 body.
machine.circuit_connector = nil
machine.circuit_wire_max_distance = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
machine.icon = "__LavaBlock-graphics__/graphics/icons/items/isostatic-press.png"
machine.icon_size = 64
machine.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md
-- and tools/blender/isostatic_press.py). Facing north: three argon bottles
-- at the back right; the vessel left of centre in its frame, a column on
-- either side and the round-backed yoke over the top; the compressor at the
-- front right, its crossheads sliding in open guides; the chiller with its
-- fan in the front left corner, and the control cabinet between them.
--
-- Four sheets, because the bottles, the compressor and the port sit on
-- named sides. No glow sheet: the furnace is inside the vessel.
local GFX = "__LavaBlock-graphics__/graphics/entity/isostatic-press/"

local function layer(kind, dir, extra)
    local name = "isostatic-press-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/isostatic-press/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- One stroke of the compressor over the sheet: at half speed about
        -- two strokes a second, a slow industrial compressor.
        animation_speed = 0.5,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function body(dir)
    return {
        layers = {
            layer("entity", dir),
            layer("shadow", dir, { draw_as_shadow = true }),
        },
    }
end

machine.graphics_set = {
    animation = {
        north = body("north"),
        east = body("east"),
        south = body("south"),
        west = body("west"),
    },
}

-- No pipe_picture or pipe_covers: the model carries its own port.
--
-- One input, the argon, on the north edge at the back right where the
-- bottles' header leaves the model. Modelled +Y is north and Factorio
-- counts Y southwards, so the stub modelled at y = +1.5 is { 1.5, -1.5 }.
machine.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            {
                direction = defines.direction.north,
                position = { 1.5, -1.5 },
                flow_direction = "input",
            },
        },
        volume = 1000,
    },
}

-- The port is part of the model and always drawn, so a pipe has to be
-- able to reach it on an idle press.
machine.fluid_boxes_off_when_no_fluid_recipe = nil
utils.remove_pipe_covers(machine)

return machine
