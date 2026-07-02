require("__core__.lualib.util")
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.assemblerpipes")
local pump = table.deepcopy(data.raw["pump"]["pump"])
-- Start with chemical plant
local air_cooler = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
air_cooler.name = "air-cooler"
air_cooler.minable.result = "air-cooler"
-- Clear any next_upgrade inherited from the source prototype (e.g. mods like 5Dim
-- add next_upgrade to the chemical-plant). The upgrade target would have a
-- different bounding box than this 3x3 entity and cause a load error.
air_cooler.next_upgrade = nil

-- Set custom crafting category (only cryogenic-cooling recipes)
air_cooler.crafting_categories = { "cryogenic-cooling" }

-- Resize to 3x3
air_cooler.collision_box = { { -1.4, -1.4 }, { 1.4, 1.4 } }
air_cooler.selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } }
air_cooler.tile_width = 3
air_cooler.tile_height = 3

-- Use pump icon
air_cooler.icon = pump.icon
air_cooler.icon_size = pump.icon_size
if pump.icons then
    air_cooler.icons = pump.icons
end

-- Custom animated cryo cooling unit, rendered in Blender via the Factorio Utils
-- addon. Two layers: colour + a separate shadow (draw_as_shadow), each with an
-- HR (2x) version. The entity can't be rotated, so the same animation is used
-- for all directions. scale = 32 * ortho_scale / render_res (32*5.5/256 = 0.6875,
-- HR = 32*5.5/512 = 0.34375). Model built at true tile size & centred on origin.
local GFX = "__LavaBlock__/graphics/entity/air-cooler/"
local color_layer = {
    filename = GFX .. "air-cooler-animation.png",
    priority = "high",
    width = 256, height = 256,
    frame_count = 24, line_length = 24,
    animation_speed = 0.5,
    scale = 0.6875,
    shift = util.by_pixel(0, 0),
    hr_version = {
        filename = GFX .. "hr-air-cooler-animation.png",
        priority = "high",
        width = 512, height = 512,
        frame_count = 24, line_length = 24,
        animation_speed = 0.5,
        scale = 0.34375,
        shift = util.by_pixel(0, 0),
    },
}
local shadow_layer = {
    filename = GFX .. "air-cooler-shadow.png",
    priority = "high",
    width = 256, height = 256,
    frame_count = 24, line_length = 24,
    animation_speed = 0.5,
    scale = 0.6875,
    shift = util.by_pixel(0, 0),
    draw_as_shadow = true,
    hr_version = {
        filename = GFX .. "hr-air-cooler-shadow.png",
        priority = "high",
        width = 512, height = 512,
        frame_count = 24, line_length = 24,
        animation_speed = 0.5,
        scale = 0.34375,
        shift = util.by_pixel(0, 0),
        draw_as_shadow = true,
    },
}
local cooler_layers = { color_layer, shadow_layer }

air_cooler.graphics_set = {
    animation = {
        north = { layers = cooler_layers },
        east = { layers = cooler_layers },
        south = { layers = cooler_layers },
        west = { layers = cooler_layers },
    }
}

air_cooler.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } }
        },
        volume = 1000,

    },
    {
        production_type = "input",
        draw_only_when_connected = true,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.west, position = { -1, 0 } }
        },
        volume = 1000,

    },
    {
        production_type = "output",
        pipe_connections = {
            { flow_direction = "output", direction = defines.direction.south, position = { 0, 1 } }
        },
        volume = 1000,
    },
}

return air_cooler