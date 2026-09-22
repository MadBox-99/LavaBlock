local utils = require("lib.utils")

local gas_combiner = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
gas_combiner.name = "gas-combiner"
gas_combiner.minable.result = "gas-combiner"
gas_combiner.crafting_categories = { "gas-combining" }
gas_combiner.crafting_speed = 1.0
-- A blower and a metering pump. Blending gas is cheap next to making one.
gas_combiner.energy_usage = "200kW"
gas_combiner.module_slots = 2
-- Productivity is allowed: a better-metered blend really does waste less
-- of what goes in, and there is no loop to farm - shielding gas is only
-- ever consumed, by the crystallizer, and nothing downstream makes argon.
gas_combiner.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
gas_combiner.next_upgrade = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
gas_combiner.icon = "__LavaBlock__/graphics/icons/items/gas-combiner.png"
gas_combiner.icon_size = 64
gas_combiner.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
--
-- Two upright receivers at the back, a mixing drum across the front with a
-- lit sight glass in it, and a blower wheel standing up on the right facing
-- the camera. Brass and deep blue, to stay apart from the air compressor's
-- cold grey - the two stand next to each other in any gas build.
local GFX = "__LavaBlock__/graphics/entity/gas-combiner/"

local function layer(kind, dir, extra)
    local name = "gas-combiner-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock__/graphics/entity/gas-combiner/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        animation_speed = 0.35,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function skid_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

gas_combiner.graphics_set = {
    animation = {
        north = { layers = skid_layers("north") },
        east = { layers = skid_layers("east") },
        south = { layers = skid_layers("south") },
        west = { layers = skid_layers("west") },
    },
}

-- No pipe_picture or pipe_covers: the model carries its own ports. See
-- docs/blender-renders.md for why the two cannot be mixed.
--
-- Two inputs on the flanks and the blend out at the back, each where the
-- model draws its stub. Modelled -X is west and +X is east - X keeps its
-- sign - while the outlet modelled at +Y is north, which is {0,-1},
-- because Factorio counts Y southwards and the render puts +Y at the top.
--
-- Neither input is filtered, the way a chemical plant's are not. Factorio
-- assigns a recipe's fluid ingredients to the input boxes in order, so the
-- game labels the ports itself once a recipe is set, and there is no
-- wrong-side trap for two ports the model draws identically.
gas_combiner.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            {
                direction = defines.direction.west,
                position = { -1, 0 },
                flow_direction = "input",
            }
        },
        volume = 400,
    },
    {
        production_type = "input",
        pipe_connections = {
            {
                direction = defines.direction.east,
                position = { 1, 0 },
                flow_direction = "input",
            }
        },
        volume = 400,
    },
    {
        production_type = "output",
        pipe_connections = {
            {
                direction = defines.direction.north,
                position = { 0, -1 },
                flow_direction = "output",
            }
        },
        volume = 400,
    },
}

-- The ports are part of the model and always visible, so a pipe has to be
-- able to reach them on an empty machine.
gas_combiner.fluid_boxes_off_when_no_fluid_recipe = nil
utils.remove_pipe_covers(gas_combiner)

return gas_combiner
