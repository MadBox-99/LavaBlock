require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.assemblerpipes")
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

-- Same icon as the item, so alt-mode and Factoriopedia match the model. It
-- used the vanilla pump's icon before, which said nothing about the machine.
air_cooler.icon = "__LavaBlock__/graphics/icons/items/air-cooler.png"
air_cooler.icon_size = 64
air_cooler.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
--
-- A cryogenic chiller: a louvred plant box with two counter-rotating axial
-- fans on its roof, a rime-covered expansion drum across the front and a
-- compressor working beside it. Frost is the identity - it is the only white
-- machine in the mod, which is what marks the start of the nitrogen line.
--
-- The old sprite was one 256 px animation reused for all four facings, so
-- the machine never turned. This one is rendered per facing like the rest.
local GFX = "__LavaBlock__/graphics/entity/air-cooler/"

local function layer(kind, dir, extra)
    local name = "air-cooler-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock__/graphics/entity/air-cooler/" .. name)
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

local function cooler_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

air_cooler.graphics_set = {
    animation = {
        north = { layers = cooler_layers("north") },
        east = { layers = cooler_layers("east") },
        south = { layers = cooler_layers("south") },
        west = { layers = cooler_layers("west") },
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