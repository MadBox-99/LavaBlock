-- A lithium-ion cell line: foil reels, a winder that rolls cathode, anode
-- and separator into a jelly roll, a conveyor of cans being filled and
-- closed, and a formation rack where the finished cells are charged for
-- the first time. Aquilo's machine, where the lithium is.
--
-- Three by six, laid out the way a real line runs: reels at one end,
-- formation at the other.
--
-- 2 MW. Coating and drying the electrodes is the hungry part of a real
-- cell line, and the formation rack charges every cell it makes: less
-- than the arc furnace, which melts metal, more than any assembler.
local utils = require("lib.utils")

local machine = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
machine.name = "cell-assembly-line"
machine.minable = { mining_time = 1, result = "cell-assembly-line" }
machine.max_health = 500
machine.corpse = "big-remnants"
machine.crafting_categories = { "cell-assembling" }
machine.crafting_speed = 1.0
machine.energy_usage = "2MW"
machine.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = 1 },
}
machine.module_slots = 4
machine.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
machine.next_upgrade = nil
machine.fast_replaceable_group = nil

machine.collision_box = { { -1.4, -2.9 }, { 1.4, 2.9 } }
machine.selection_box = { { -1.5, -3 }, { 1.5, 3 } }

-- assembling-machine-2's circuit connector is placed for a 3x3 body.
machine.circuit_connector = nil
machine.circuit_wire_max_distance = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
machine.icon = "__LavaBlock-graphics__/graphics/icons/items/cell-assembly-line.png"
machine.icon_size = 64
machine.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md
-- and tools/blender/cell_assembly_line.py). Facing north the line runs
-- south to north: the copper and aluminium foil reels at the south end,
-- the winding head turning in the middle, the cell conveyor up the east
-- side to the formation rack along the west, and the electrolyte drum at
-- the west edge by the port.
--
-- Four sheets, because the reels, the rack and the port sit on named
-- sides. The formation rack's charge lights are their own sheet, lit only
-- while the line runs.
local GFX = "__LavaBlock-graphics__/graphics/entity/cell-assembly-line/"

local function layer(kind, dir, extra)
    local name = "cell-assembly-line-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/cell-assembly-line/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- The turntable moves one mandrel along and the conveyor one cell
        -- along over the sheet: at half speed, about two cells a second.
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

local function glow(dir)
    return layer("tint", dir, { blend_mode = "additive", draw_as_glow = true })
end

machine.graphics_set = {
    animation = {
        north = body("north"),
        east = body("east"),
        south = body("south"),
        west = body("west"),
    },
    working_visualisations = {
        {
            fadeout = true,
            north_animation = glow("north"),
            east_animation = glow("east"),
            south_animation = glow("south"),
            west_animation = glow("west"),
        },
    },
}

-- No pipe_picture or pipe_covers: the model carries its own port.
--
-- One input, the electrolyte, on the west edge beside the drum. Modelled
-- +Y is north and Factorio counts Y southwards, so the stub modelled at
-- y = +0.5 is { -1, -0.5 }.
machine.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            {
                direction = defines.direction.west,
                position = { -1, -0.5 },
                flow_direction = "input",
            },
        },
        volume = 1000,
    },
}

-- The port is part of the model and always drawn, so a pipe has to be
-- able to reach it while the line presses cathodes, which take no fluid.
machine.fluid_boxes_off_when_no_fluid_recipe = nil
utils.remove_pipe_covers(machine)

return machine
