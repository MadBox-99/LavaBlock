require("__core__.lualib.util")
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.assemblerpipes")

-- Base on centrifuge
local lava_centrifuge = table.deepcopy(data.raw["assembling-machine"]["centrifuge"])
lava_centrifuge.name = "lava-centrifuge"
lava_centrifuge.minable.result = "lava-centrifuge"

-- Custom crafting category for lava centrifuge recipes
lava_centrifuge.crafting_categories = { "lava-centrifuge" }

-- Orange/red tint for lava theme
lava_centrifuge.crafting_machine_tint = {
    primary = { r = 1.0, g = 0.4, b = 0.0, a = 1.0 },
    secondary = { r = 1.0, g = 0.2, b = 0.0, a = 1.0 },
}

-- Energy and performance settings
lava_centrifuge.energy_usage = "500kW"
lava_centrifuge.crafting_speed = 1
lava_centrifuge.module_slots = 4

-- Add fluid boxes for lava input and secondary fluid input
lava_centrifuge.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } }
        },
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        volume = 2000,
    },
    {
        production_type = "input",
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.east, position = { 1, 0 } }
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
        volume = 2000,
    },
}

return lava_centrifuge
