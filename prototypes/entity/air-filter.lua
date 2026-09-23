local utils = require("lib.utils")

local air_filter = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
air_filter.name = "air-filter"
air_filter.minable.result = "air-filter"
air_filter.crafting_categories = { "air-filtering" }
-- The same speed the air compressor ran adsorption at, so moving the recipe
-- off it changes where the air is cleaned and not how fast. A split that
-- also cut throughput would read as a nerf dressed up as a building.
air_filter.crafting_speed = 2.0
-- Far less than the compressor's 1500 kW, because this machine does none of
-- the compressing. Charging a tower and turning an impeller is cheap next to
-- squeezing steam into compressed air, and the air line comes out cheaper
-- in power for the price of a second building and the belt between them.
air_filter.energy_usage = "600kW"
air_filter.module_slots = 2
-- No productivity. Fluid in, the same fluid count out: productivity here
-- would be free matter, and unlike the crystallizer there is no solid
-- product for it to be honest about.
air_filter.allowed_effects = {
    "consumption", "speed", "pollution", "quality",
}
air_filter.next_upgrade = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
air_filter.icon = "__LavaBlock__/graphics/icons/items/air-filter.png"
air_filter.icon_size = 64
air_filter.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
--
-- An electrostatic precipitator, built to the shape the mod already had a
-- placeholder drawing of: a flared furnace tower ringed with grey
-- buttresses, louvred rust panels recessed between them, an open chase down
-- the front, and a small orange impeller turning in a dark well at the top
-- with a second one turning against it in the throat below. That drawing
-- sat in the repo for months with nothing behind it.
--
-- A round tower is also the one silhouette that is equally right in all
-- four facings, and an impeller lying flat is the one moving part a
-- rotatable machine can never turn edge-on.
local GFX = "__LavaBlock__/graphics/entity/air-filter/"

local function layer(kind, dir, extra)
    local name = "air-filter-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock__/graphics/entity/air-filter/" .. name)
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

local function filter_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

air_filter.graphics_set = {
    animation = {
        north = { layers = filter_layers("north") },
        east = { layers = filter_layers("east") },
        south = { layers = filter_layers("south") },
        west = { layers = filter_layers("west") },
    },
}

-- No pipe_picture or pipe_covers: the model carries its own ports. See
-- docs/blender-renders.md for why the two cannot be mixed.
--
-- Dirty compressed air in on the west, clean air out on the east, each
-- where the model draws its stub. X keeps its sign between the model and
-- the prototype - it is Y that flips.
--
-- The input is filtered, because there is exactly one fluid this machine
-- can ever clean and a stray line of anything else would stall it with a
-- fluid no recipe here will consume.
air_filter.fluid_boxes = {
    {
        production_type = "input",
        filter = "compressed-air",
        pipe_connections = {
            {
                direction = defines.direction.west,
                position = { -1, 0 },
                flow_direction = "input",
            }
        },
        volume = 1000,
    },
    {
        production_type = "output",
        pipe_connections = {
            {
                direction = defines.direction.east,
                position = { 1, 0 },
                flow_direction = "output",
            }
        },
        volume = 1000,
    },
}

-- The ports are part of the model and always visible, so a pipe has to be
-- able to reach them on an empty machine.
air_filter.fluid_boxes_off_when_no_fluid_recipe = nil
utils.remove_pipe_covers(air_filter)

return air_filter
