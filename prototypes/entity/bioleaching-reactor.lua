-- A bioleaching reactor: two open stirred tanks in cascade, where bacteria
-- that live on sulfur and iron eat the sulfide ore away from the metal in
-- it. Air is blown in from below, because the bacteria breathe it. Gleba's
-- machine; the bacteria come from Gleba too, and spoil.
--
-- Five by five: the two tanks side by side, the inoculation vessel between
-- them at the back, the aeration blower at the front.
--
-- 300 kW, for two mixers and a blower. The bacteria do the work, which is
-- the point of bioleaching: no furnace, no arc, no acid bought in. An arc
-- furnace smelting the same ore draws ten times as much.
local utils = require("lib.utils")

local machine = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
machine.name = "bioleaching-reactor"
machine.minable = { mining_time = 1, result = "bioleaching-reactor" }
machine.max_health = 600
machine.corpse = "big-remnants"
machine.crafting_categories = { "ore-bioleaching" }
machine.crafting_speed = 1.0
machine.energy_usage = "300kW"
machine.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = 1 },
}
machine.module_slots = 2
machine.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
machine.next_upgrade = nil
machine.fast_replaceable_group = nil

machine.collision_box = { { -2.4, -2.4 }, { 2.4, 2.4 } }
machine.selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }

-- assembling-machine-2's circuit connector is placed for a 3x3 body.
machine.circuit_connector = nil
machine.circuit_wire_max_distance = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
machine.icon = "__LavaBlock-graphics__/graphics/icons/items/bioleaching-reactor.png"
machine.icon_size = 64
machine.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md
-- and tools/blender/bioleaching_reactor.py). Facing north: the inoculation
-- vessel at the back with its green sight glass, piped to the rim of each
-- tank; the two tanks side by side with the launder between them and a
-- side-entry mixer in each back corner; the aeration blower at the front
-- with its fan turning, an air header to the foot of each tank; the water
-- coming in on the west flank and the acid going out on the east.
--
-- The liquor in the tanks is its own sheet, tinted by the recipe - green
-- for nickel, pale for zinc, rust red for the pyrite's iron - and drawn
-- only while the reactor runs, so an idle one shows dark settled slurry.
local GFX = "__LavaBlock-graphics__/graphics/entity/bioleaching-reactor/"

local function layer(kind, dir, extra)
    local name = "bioleaching-reactor-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/bioleaching-reactor/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Slow: the liquor turns one lobe over the sheet, and a tank this
        -- size is stirred, not whisked.
        animation_speed = 0.25,
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
    working_visualisations = {
        {
            apply_recipe_tint = "primary",
            north_animation = layer("tint", "north"),
            east_animation = layer("tint", "east"),
            south_animation = layer("tint", "south"),
            west_animation = layer("tint", "west"),
        },
    },
}

-- No pipe_picture or pipe_covers: the model carries its own ports.
--
-- Water in on the west flank and acid out on the east, both at the front,
-- where the model's pipes leave the plinth. Only the pyrite recipe makes
-- acid; the others leave the output empty. Modelled +Y is north and
-- Factorio counts Y southwards, so the stubs modelled at y = -1 are
-- { x, 1 } here.
machine.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            {
                direction = defines.direction.west,
                position = { -2, 1 },
                flow_direction = "input",
            },
        },
        volume = 1000,
    },
    {
        production_type = "output",
        pipe_connections = {
            {
                direction = defines.direction.east,
                position = { 2, 1 },
                flow_direction = "output",
            },
        },
        volume = 1000,
    },
}

-- The ports are part of the model and always drawn, so a pipe has to be
-- able to reach them on an idle reactor.
machine.fluid_boxes_off_when_no_fluid_recipe = nil
utils.remove_pipe_covers(machine)

return machine
