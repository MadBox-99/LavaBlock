-- An eddy current separator: scrap rides a belt onto a drum with a magnet
-- rotor spinning inside it, and the currents the rotor drives through every
-- piece of copper, aluminium and brass throw those pieces clear of the
-- belt. Iron, plastic and stone drop straight off the end. Fulgora's
-- machine, and the island's metals out of Fulgora's scrap.
--
-- Three by five: the belt runs the length of it, with the two bins and the
-- splitter plate between them at the head end.
--
-- 500 kW. A belt and one rotor, with nothing heated: a little over an
-- electric furnace's 180 kW for the rotor, which turns at thousands of
-- revolutions a minute against the eddy currents it is making.
local machine = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
machine.name = "eddy-current-separator"
machine.minable = { mining_time = 0.5, result = "eddy-current-separator" }
machine.max_health = 400
machine.corpse = "big-remnants"
machine.crafting_categories = { "scrap-separating" }
machine.crafting_speed = 1.0
machine.energy_usage = "500kW"
machine.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = 1 },
}
machine.module_slots = 2
machine.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
machine.next_upgrade = nil
machine.fast_replaceable_group = nil

machine.collision_box = { { -1.4, -2.4 }, { 1.4, 2.4 } }
machine.selection_box = { { -1.5, -2.5 }, { 1.5, 2.5 } }

-- assembling-machine-2's circuit connector is placed for a 3x3 body.
machine.circuit_connector = nil
machine.circuit_wire_max_distance = nil

-- Nothing to pipe in or out: scrap goes in and metal comes out by inserter.
machine.fluid_boxes = nil
machine.fluid_boxes_off_when_no_fluid_recipe = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
machine.icon = "__LavaBlock-graphics__/graphics/icons/items/eddy-current-separator.png"
machine.icon_size = 64
machine.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md
-- and tools/blender/eddy_current_separator.py). Facing north the belt runs
-- from the feed chute at the south end to the head drum at the north,
-- carrying mixed scrap; the metal is thrown in an arc over the splitter
-- plate into the far bin and the rest drops into the near one. The drum's
-- motor is on its east end and the control cabinet in the south west
-- corner.
--
-- Four sheets, because the bins and the motor sit on named ends.
local GFX = "__LavaBlock-graphics__/graphics/entity/eddy-current-separator/"

local function layer(kind, dir, extra)
    local name = "eddy-current-separator-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/eddy-current-separator/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- The belt moves the scrap one pattern pitch, four fifths of a tile,
        -- over the sheet: at half speed about a tile and a half a second,
        -- the speed a separator's feed belt runs at.
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
