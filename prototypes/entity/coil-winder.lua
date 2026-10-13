-- A vertical coil winder: the coil stands on a turntable and turns, and a
-- guide carriage riding a column beside it lays the wire on in layers.
-- Vertical because that is how large windings are really made, and
-- because a coil turning about a horizontal axis would be seen end-on in
-- two of the four facings.
--
-- 200 kW. A winder turns a coil and holds a wire taut, which is lighter
-- work than an assembler's pressing and stamping; it gets a little more
-- than an assembling machine 2's 150 kW for the turntable's drive under a
-- full coil.
local machine = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
machine.name = "coil-winder"
machine.minable = { mining_time = 0.5, result = "coil-winder" }
machine.max_health = 350
machine.corpse = "medium-remnants"
machine.crafting_categories = { "coil-winding" }
machine.crafting_speed = 1.0
machine.energy_usage = "200kW"
machine.module_slots = 2
machine.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
machine.next_upgrade = nil
machine.fast_replaceable_group = nil

machine.collision_box = { { -1.4, -1.4 }, { 1.4, 1.4 } }
machine.selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } }

-- Nothing to pipe in or out: iron and cable go in by inserter.
machine.fluid_boxes = nil
machine.fluid_boxes_off_when_no_fluid_recipe = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
machine.icon = "__LavaBlock-graphics__/graphics/icons/items/coil-winder.png"
machine.icon_size = 64
machine.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md
-- and tools/blender/coil_winder.py). Facing north: the coil on its
-- turntable in the middle, the guide column in the back right corner with
-- its carriage riding up and down, the payoff spool low in the front right
-- and the control cabinet in the front left. Nothing stands over the coil.
--
-- Four sheets: the column, spool and cabinet sit on named corners.
local GFX = "__LavaBlock-graphics__/graphics/entity/coil-winder/"

local function layer(kind, dir, extra)
    local name = "coil-winder-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/coil-winder/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- The coil turns a quarter turn over the sheet: at half speed that
        -- is about fourteen turns a minute, which is what a winder laying
        -- heavy wire on a big coil runs at.
        animation_speed = 0.5,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function body(dir)
    return {
        layers = {
            layer("entity", dir),
            layer("shadow", dir, { draw_as_shadow = true }),
        },
    }
end

machine.graphics_set = {
    animation = {
        north = body("north"),
        east = body("east"),
        south = body("south"),
        west = body("west"),
    },
}

return machine
