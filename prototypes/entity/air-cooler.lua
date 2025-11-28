require("__core__.lualib.util")
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.assemblerpipes")
local pump = table.deepcopy(data.raw["pump"]["pump"])
-- Start with chemical plant
local air_cooler = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
air_cooler.name = "air-cooler"
air_cooler.minable.result = "air-cooler"

-- Set custom crafting category (only cryogenic-cooling recipes)
air_cooler.crafting_categories = { "cryogenic-cooling" }

-- Resize to 1x3 with pump-like boxes
air_cooler.collision_box = { { -0.29, -1.4 }, { 0.29, 1.4 } }
air_cooler.selection_box = { { -0.5, -1.5 }, { 0.5, 1.5 } }
air_cooler.tile_width = 1
air_cooler.tile_height = 3

-- Use pump icon
air_cooler.icon = pump.icon
air_cooler.icon_size = pump.icon_size
if pump.icons then
    air_cooler.icons = pump.icons
end

air_cooler.graphics_set = {
    animation = {
        north = {
            layers = { pump.animations.north }
        },
        east = {
            layers = { pump.animations.east }
        },
        south = {
            layers = { pump.animations.south }
        },
        west = {
            layers = { pump.animations.west }
        }
    }
}

air_cooler.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } }
        },
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        volume = 1000,

    },
    {
        production_type = "input",
        draw_only_when_connected = true,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.west, position = { 0, 0 } }
        },
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        volume = 1000,

    },
    {
        production_type = "output",
        pipe_connections = {
            { flow_direction = "output", direction = defines.direction.south, position = { 0, 1 } }
        },
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        volume = 1000,
    },
}

return air_cooler