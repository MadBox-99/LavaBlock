-- A distillation column: the tower every distillery and refinery is built
-- around. Wash goes in part way up, steam heats the reboiler at the foot,
-- the ethanol climbs the trays and leaves the top as vapour, and the water
-- it was dissolved in runs out of the bottom.
--
-- It has one recipe and is fixed to it. There is nothing else for a
-- purpose-built ethanol column to do, and a recipe picker with one entry is
-- a click the player does not need.
local distillation_column = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
distillation_column.name = "distillation-column"
distillation_column.minable.result = "distillation-column"
distillation_column.crafting_categories = { "wash-distilling" }
distillation_column.fixed_recipe = "wash-distillation"
distillation_column.crafting_speed = 1.0
-- Only the reflux pump and the air cooler's fan. The heat that does the
-- actual distilling comes in as steam, not as electricity.
distillation_column.energy_usage = "100kW"
distillation_column.next_upgrade = nil
distillation_column.fast_replaceable_group = nil

distillation_column.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = 1 },
}

distillation_column.module_slots = 2
-- No productivity: the recipe forbids it, because separating a fluid cannot
-- make more of what was in it.
distillation_column.allowed_effects = { "consumption", "speed", "pollution" }

-- The tower stands well above its footprint, so the game has to be told to
-- keep drawing it while only the top is on screen.
distillation_column.drawing_box_vertical_extension = 2.5

-- No pipe_picture or pipe_covers: the model carries its own ports.
--
-- Feeds in on the south face, products out on the north, the way a column
-- is plumbed: wash and steam come from the process side, ethanol and water
-- leave for storage. Every box is filtered, because four unmarked ports on
-- one building is four chances to cross two pipes.
distillation_column.fluid_boxes = {
    {
        production_type = "input",
        filter = "fermented-wash",
        volume = 1000,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.south,
              position = { -1, 1 } },
        },
    },
    {
        production_type = "input",
        filter = "steam",
        volume = 200,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.south,
              position = { 1, 1 } },
        },
    },
    {
        production_type = "output",
        filter = "ethanol",
        volume = 1000,
        pipe_connections = {
            { flow_direction = "output", direction = defines.direction.north,
              position = { 1, -1 } },
        },
    },
    {
        production_type = "output",
        filter = "water",
        volume = 1000,
        pipe_connections = {
            { flow_direction = "output", direction = defines.direction.north,
              position = { -1, -1 } },
        },
    },
}
distillation_column.fluid_boxes_off_when_no_fluid_recipe = false

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
distillation_column.icon = "__LavaBlock-graphics__/graphics/icons/items/distillation-column.png"
distillation_column.icon_size = 64
distillation_column.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
-- The column on the west half with its tray flanges and manways, the
-- reboiler lying at its foot, and a fin-fan air cooler on the east half
-- whose fan is the part that turns. Nothing crosses over the fan.
local GFX = "__LavaBlock-graphics__/graphics/entity/distillation-column/"

local function layer(kind, dir, extra)
    local name = "distillation-column-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/distillation-column/" .. name)
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

local function column_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

distillation_column.graphics_set = {
    animation = {
        north = { layers = column_layers("north") },
        east = { layers = column_layers("east") },
        south = { layers = column_layers("south") },
        west = { layers = column_layers("west") },
    },
}

return distillation_column
