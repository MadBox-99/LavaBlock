-- An electric arc furnace: three graphite electrodes lowered through the
-- roof of a water-cooled shell, with arcs between them and the charge hot
-- enough to melt what no fuel-fired furnace can. The island's smelter for
-- alloys, ferroalloys and the metals that are won by electricity rather
-- than by fire.
--
-- Five by five, the size of the arboretum: a round shell three tiles
-- across, the masts behind it and the transformer beside it.
--
-- 3 MW. A real arc furnace is the hungriest single load on any grid, and
-- the point of the machine is that it buys heat with electricity instead
-- of coal: an electric furnace makes a steel plate on 1.44 MJ, this one on
-- 6 MJ, and the difference is what it pays for doing in one building what
-- takes four steel furnaces.
local utils = require("lib.utils")

local machine = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
machine.name = "arc-furnace"
machine.minable = { mining_time = 1, result = "arc-furnace" }
machine.max_health = 800
machine.corpse = "big-remnants"
machine.crafting_categories = { "arc-smelting" }
machine.crafting_speed = 1.0
machine.energy_usage = "3MW"
-- Twice a steel furnace's smoke and less than a boiler bank's: the arcs
-- burn the electrodes and the slag fumes, but nothing here burns fuel.
machine.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = 8 },
}
machine.module_slots = 4
machine.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
machine.next_upgrade = nil
machine.fast_replaceable_group = nil

machine.collision_box = { { -2.4, -2.4 }, { 2.4, 2.4 } }
machine.selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }

-- assembling-machine-2's circuit connector is placed for a 3x3 body.
machine.circuit_connector = nil
machine.circuit_wire_max_distance = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
machine.icon = "__LavaBlock-graphics__/graphics/icons/items/arc-furnace.png"
machine.icon_size = 64
machine.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md
-- and tools/blender/arc_furnace.py). Facing north: three yellow masts in a
-- row behind the shell, their copper arms reaching forward to the three
-- electrodes; the transformer in the back left corner with its fan on top;
-- the fume offtake leaving the roof towards the north east and coming down
-- to the gas port; the slag door in the south west of the shell, and the
-- tap spout in the south east running down into a tundish at the metal
-- port.
--
-- Four sheets, because the transformer and the ports sit on named sides.
-- The light round the electrode feet - blue-white, the one cold glow on the
-- island - the slag door and the metal in the launder are their own
-- sheet, drawn only while the furnace runs.
local GFX = "__LavaBlock-graphics__/graphics/entity/arc-furnace/"

local function layer(kind, dir, extra)
    local name = "arc-furnace-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/arc-furnace/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- About a second for the electrodes to ride up and down once.
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

-- No pipe_picture or pipe_covers: the model carries its own ports.
--
-- Two inputs low on the front of each flank, where the model's feed pipes
-- run into the hearth. Two outputs, because a furnace that melts metal
-- also gives off gas: the molten metal from the tundish at the front,
-- {1, 2}, and the gas from the foot of the fume offtake on the back of the
-- east flank, {2, -1}. Every arc recipe names its outputs by index -
-- 1 the metal, 2 the gas - so the melt never comes out of the offtake.
-- Modelled +Y is north and Factorio counts Y southwards, so the feeds
-- modelled at y = -1 are { x, 1 } here.
machine.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            {
                direction = defines.direction.west,
                position = { -2, 1 },
                flow_direction = "input",
            },
        },
        volume = 1000,
    },
    {
        production_type = "input",
        pipe_connections = {
            {
                direction = defines.direction.east,
                position = { 2, 1 },
                flow_direction = "input",
            },
        },
        volume = 1000,
    },
    {
        production_type = "output",
        pipe_connections = {
            {
                direction = defines.direction.south,
                position = { 1, 2 },
                flow_direction = "output",
            },
        },
        volume = 1000,
    },
    {
        production_type = "output",
        pipe_connections = {
            {
                direction = defines.direction.east,
                position = { 2, -1 },
                flow_direction = "output",
            },
        },
        volume = 1000,
    },
}

-- The ports are part of the model and always drawn, so a pipe has to be
-- able to reach them on an idle furnace.
machine.fluid_boxes_off_when_no_fluid_recipe = nil
utils.remove_pipe_covers(machine)

return machine
