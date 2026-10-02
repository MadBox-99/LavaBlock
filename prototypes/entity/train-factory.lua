-- A train factory: an erecting shop with an open assembly bay in front of
-- it, where welding robots put locomotives and wagons together on a length
-- of track. Every piece of rolling stock on the island is built here and
-- nowhere else - an assembler two tiles across was the wrong place for a
-- thousand gears and a hundred thousand lava.
--
-- Six tiles by twelve, the length of a locomotive and the shop behind it.
--
-- 1 MW: four robots welding all day and a foundry in the shop, against an
-- assembling machine's few hundred kilowatts.
local factory = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
factory.name = "train-factory"
factory.minable = { mining_time = 1, result = "train-factory" }
factory.max_health = 1500
factory.corpse = "big-remnants"
factory.crafting_categories = { "rolling-stock-assembling" }
factory.crafting_speed = 1.0
factory.energy_usage = "1MW"
factory.module_slots = 2
factory.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
factory.next_upgrade = nil
factory.fast_replaceable_group = nil

factory.collision_box = { { -2.9, -5.9 }, { 2.9, 5.9 } }
factory.selection_box = { { -3, -6 }, { 3, 6 } }

-- Lava in through either side wall of the shop, at its north end. Input
-- only, so the volume follows the recipe's lava and a pipe cannot pass
-- through the factory from one side to the other. The ports are modelled,
-- so neither pipe_picture nor pipe_covers is drawn over them.
factory.fluid_boxes = {
    {
        production_type = "input",
        volume = 1000,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.west, position = { -2.5, -4.5 } },
            { flow_direction = "input", direction = defines.direction.east, position = { 2.5, -4.5 } },
        },
    },
}
-- The artillery wagon takes no lava; the ports stay connected for it all
-- the same, since the model shows them whatever is being built.
factory.fluid_boxes_off_when_no_fluid_recipe = false

-- assembling-machine-2's circuit connector is placed for a 3x3 body.
factory.circuit_connector = nil
factory.circuit_wire_max_distance = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
factory.icon = "__LavaBlock-graphics__/graphics/icons/items/train-factory.png"
factory.icon_size = 64
factory.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md
-- and tools/blender/train_factory.py). Facing north: the shop at the north
-- end under a sawtooth roof, its foundry glowing through the door; the bay
-- in front with the track down the middle and two welding robots on each
-- side; wheelsets and beams staged at the front corners. Nothing stands
-- over the vehicle - the robots work it from the sides.
--
-- Four sheets: the lava ports are on the shop's side walls at the north
-- end only, so no facing is another seen from behind. The vehicle on the
-- track is its own sheet, coloured by the recipe and drawn only while the
-- factory works: an idle factory has an empty track.
local GFX = "__LavaBlock-graphics__/graphics/entity/train-factory/"

local function layer(kind, dir, extra)
    local name = "train-factory-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/train-factory/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- A robot sweeps its seam and back in a little over a second.
        animation_speed = 0.3,
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

factory.graphics_set = {
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

return factory
