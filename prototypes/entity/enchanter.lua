require("__core__.lualib.util")
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.assemblerpipes")

-- Start with centrifuge (uranium enrichment machine)
local enchanter = table.deepcopy(data.raw["assembling-machine"]["centrifuge"])
enchanter.name = "enchanter"
enchanter.minable.result = "enchanter"

-- Set custom crafting category for enchanting recipes
enchanter.crafting_categories = { "enchanting" }

-- Modify the machine specs
enchanter.crafting_speed = 1
enchanter.energy_usage = "500kW"
enchanter.module_slots = 4

-- Change the icon to use centrifuge icon with tint
enchanter.icon = "__base__/graphics/icons/centrifuge.png"
enchanter.icon_size = 64

-- Add fluid boxes for enchanting processes
enchanter.fluid_boxes = {
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
        production_type = "output",
        pipe_connections = {
            { flow_direction = "output", direction = defines.direction.south, position = { 0, 1 } }
        },
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        volume = 1000,
    },
}

return enchanter
