local algae_tank = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
algae_tank.name = "algae-tank"
algae_tank.minable.result = "algae-tank"
algae_tank.crafting_categories = { "algae-tank" }
algae_tank.crafting_speed = 1.0
-- Circulation pumps, grow lamps and a chiller on the culture.
algae_tank.energy_usage = "200kW"
algae_tank.module_slots = 2
-- Growing matter is the one case where a productivity bonus is not invented
-- mass: a better-run culture really does yield more harvest off the same
-- feed. Everything else is allowed too, because a productivity module
-- carries consumption, pollution and speed effects and cannot be inserted
-- unless all of them are permitted.
algae_tank.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
algae_tank.fluid_boxes_off_when_no_fluid_recipe = true
algae_tank.next_upgrade = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
algae_tank.icon = "__LavaBlock__/graphics/icons/items/algae-tank.png"
algae_tank.icon_size = 64
algae_tank.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
--
-- A sealed photobioreactor: four tall culture columns behind armoured glass,
-- with nothing standing over them. Growing is now this building's only job -
-- the bio garden presses the harvest - so the culture is what the model is
-- almost entirely made of, and it fills and drains where you can see it.
local GFX = "__LavaBlock__/graphics/entity/algae-tank/"

local function layer(kind, dir, extra)
    local name = "algae-tank-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock__/graphics/entity/algae-tank/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Slow. The columns fill over one pass of the sheet, and growth that
        -- takes half a second does not read as growth.
        animation_speed = 0.12,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function tank_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

-- The culture is a working visualisation rather than part of the animation,
-- for two reasons. Factorio multiplies it by the recipe's primary tint, so
-- one sheet shows green, blue or red algae depending on what is piped in;
-- and a working visualisation is only drawn while the machine runs, so an
-- idle tank correctly shows empty glass.
algae_tank.graphics_set = {
    animation = {
        north = { layers = tank_layers("north") },
        east = { layers = tank_layers("east") },
        south = { layers = tank_layers("south") },
        west = { layers = tank_layers("west") },
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

-- No pipe_picture or pipe_covers: the model carries its own ports. See
-- docs/blender-renders.md for why the two cannot be mixed.
--
-- Two inputs and no fluid output: the harvest leaves as items on a belt. The
-- north box is pinned to water, which every strain drinks; the south box is
-- deliberately unfiltered, because the second feed is what picks the strain -
-- lava for green, air for blue, steam for red. Swapping the recipe swaps what
-- that pipe has to carry, which is the whole reason the tank has two.
algae_tank.fluid_boxes = {
    {
        production_type = "input",
        filter = "water",
        pipe_connections = {
            { direction = 0, position = { 0, -1 }, flow_direction = "input", }
        },
        volume = 1000,
    },
    {
        production_type = "input",
        pipe_connections = {
            { direction = 8, position = { 0, 1 }, flow_direction = "input", }
        },
        volume = 1000,
    }
}

return algae_tank
