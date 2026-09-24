local utils = require("lib.utils")

local crystallizer = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
crystallizer.name = "crystallizer"
crystallizer.minable.result = "crystallizer"
crystallizer.crafting_categories = { "lava-crystallizing" }
crystallizer.crafting_speed = 1.0
-- A hearth held just under the freezing point of rock, plus the drive for
-- the rabble. Most of it goes on holding a temperature, not on changing one.
crystallizer.energy_usage = "300kW"
crystallizer.module_slots = 2
-- Productivity is allowed. Growing crystal out of a melt genuinely returns
-- more of what went in when it is done slowly and cleanly, and there is no
-- loop to farm: silica goes to glass and glass goes into buildings, and
-- nothing downstream makes lava.
crystallizer.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
crystallizer.next_upgrade = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
crystallizer.icon = "__LavaBlock-graphics__/graphics/icons/items/crystallizer.png"
crystallizer.icon_size = 64
crystallizer.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
--
-- A hexagonal hearth: an open pan of melt with three rabble arms turning in
-- it, and six clusters of crystal growing on the shelf around the rim. The
-- crystals grow and are taken on staggered schedules, so the ring always has
-- something at every stage.
local GFX = "__LavaBlock-graphics__/graphics/entity/crystallizer/"

local function layer(kind, dir, extra)
    local name = "crystallizer-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/crystallizer/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Slow. Crystal growth that takes half a second is not growth, and
        -- the rabble is a stirrer, not a fan.
        animation_speed = 0.20,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function hearth_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

crystallizer.graphics_set = {
    animation = {
        north = { layers = hearth_layers("north") },
        east = { layers = hearth_layers("east") },
        south = { layers = hearth_layers("south") },
        west = { layers = hearth_layers("west") },
    },
}

-- No pipe_picture or pipe_covers: the model carries its own ports. See
-- docs/blender-renders.md for why the two cannot be mixed.
--
-- Two inputs, on the two flanks, each where the model draws its stub: the
-- melt on the west in a heavy pipe, the gas on the east in a thin brass
-- one. The front edge is taken by the product chute and the back by the
-- switchgear. Modelled -X is west and +X is east - X keeps its sign
-- between the model and the prototype, unlike Y.
--
-- The melt box is unfiltered on purpose: the hearth takes raw lava early
-- and purified lava once the centrifuge is running, and a filter would pin
-- it to whichever of the two was named here and break the other recipe.
--
-- The gas box is filtered, because there is only ever one gas it can take,
-- and the filter is what stops a stray oxygen line stalling the machine
-- with a fluid no recipe here will ever consume.
crystallizer.fluid_boxes = {
    {
        production_type = "input",
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
        production_type = "input",
        filter = "shielding-gas",
        pipe_connections = {
            {
                direction = defines.direction.east,
                position = { 1, 0 },
                flow_direction = "input",
            }
        },
        volume = 400,
    }
}

-- assembling-machine-2 hides its fluid boxes until a fluid recipe is set.
-- That is wrong here: the ports are part of the model and always visible,
-- so a pipe has to be able to reach them on an empty machine.
crystallizer.fluid_boxes_off_when_no_fluid_recipe = nil
utils.remove_pipe_covers(crystallizer)

return crystallizer
