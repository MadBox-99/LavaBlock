-- An EUV lithography machine: a laser fired at droplets of tin turns each
-- one to plasma, and the plasma's light prints microchips onto silicon
-- wafers. The light source is fed in as an item - the laser source - and
-- wears out; the tin goes in with every craft.
--
-- Two tiles by eight, the shape of the real thing: the light source at one
-- end, the scanner in the middle and the wafer stage at the other.
--
-- 5 MW. An EUV source turns well under a percent of its laser's power into
-- light the optics can use, and the real machines draw a megawatt each for
-- it; a chip printer that ran on an assembler's power would make the most
-- precise machine on the island the cheapest to keep running.
local machine = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
machine.name = "lithography-machine"
machine.minable = { mining_time = 1, result = "lithography-machine" }
machine.max_health = 1000
machine.corpse = "big-remnants"
machine.crafting_categories = { "chip-lithography" }
machine.crafting_speed = 1.0
machine.energy_usage = "5MW"
machine.module_slots = 4
machine.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
machine.next_upgrade = nil
machine.fast_replaceable_group = nil

machine.collision_box = { { -0.9, -3.9 }, { 0.9, 3.9 } }
machine.selection_box = { { -1, -4 }, { 1, 4 } }

-- Nothing to pipe in or out: wafers, tin and laser sources all go in by
-- inserter.
machine.fluid_boxes = nil
machine.fluid_boxes_off_when_no_fluid_recipe = nil

-- assembling-machine-2's circuit connector is placed for a 3x3 body and
-- would hang off the side of a two-tile one.
machine.circuit_connector = nil
machine.circuit_wire_max_distance = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
machine.icon = "__LavaBlock-graphics__/graphics/icons/items/lithography-machine.png"
machine.icon_size = 64
machine.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md
-- and tools/blender/lithography_machine.py). Facing north: the source at
-- the north end - a steel vessel with the tin droplet generator on top and
-- the laser source upright beside it - the clean-room scanner in the
-- middle, and the open wafer stage at the south end, its chuck scanning a
-- wafer side to side. Nothing stands over the stage.
--
-- Four sheets: the two ends are different, so south is not north seen from
-- behind. The glow of the plasma windows, the laser's ruby slots and the
-- exposure line is its own sheet, drawn only while the machine prints.
local GFX = "__LavaBlock-graphics__/graphics/entity/lithography-machine/"

local function layer(kind, dir, extra)
    local name = "lithography-machine-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/lithography-machine/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- One scan of the wafer a second.
        animation_speed = 0.4,
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

local function glow(dir)
    return layer("tint", dir, { blend_mode = "additive", draw_as_glow = true })
end

machine.graphics_set = {
    animation = {
        north = body("north"),
        east = body("east"),
        south = body("south"),
        west = body("west"),
    },
    working_visualisations = {
        {
            fadeout = true,
            north_animation = glow("north"),
            east_animation = glow("east"),
            south_animation = glow("south"),
            west_animation = glow("west"),
        },
    },
}

return machine
