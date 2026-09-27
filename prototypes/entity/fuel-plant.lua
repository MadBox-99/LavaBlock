-- The last building in the ethanol line: it turns petroleum gas and steam
-- into ethanol over a catalyst, and charges ethanol with oxygen into rocket
-- fuel. Two jobs in one plant because they are the two ends of the same
-- fuel - one makes the spirit without growing anything, the other is what
-- the spirit is for - and neither is a chemical plant's work.
local fuel_plant = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
fuel_plant.name = "fuel-plant"
fuel_plant.minable.result = "fuel-plant"
fuel_plant.crafting_categories = { "fuel-synthesizing" }
fuel_plant.crafting_speed = 1.0
-- The oxygen sphere has to be kept cold, and the reactor hot. A chemical
-- plant draws 210 kW; this does both of those and runs a press.
fuel_plant.energy_usage = "250kW"
fuel_plant.next_upgrade = nil
fuel_plant.fast_replaceable_group = nil

fuel_plant.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = 3 },
}

fuel_plant.module_slots = 3
fuel_plant.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}

-- No pipe_picture or pipe_covers: the model carries its own ports.
--
-- Two feeds on the south face and one product on the north. The feeds are
-- not filtered because the recipe decides them - gas and steam for ethanol,
-- ethanol and oxygen for rocket fuel - and the north port only carries
-- anything while the plant is making ethanol; rocket fuel leaves by
-- inserter.
fuel_plant.fluid_boxes = {
    {
        production_type = "input",
        volume = 1000,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.south,
              position = { -1, 1 } },
        },
    },
    {
        production_type = "input",
        volume = 1000,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.south,
              position = { 1, 1 } },
        },
    },
    {
        production_type = "output",
        volume = 1000,
        pipe_connections = {
            { flow_direction = "output", direction = defines.direction.north,
              position = { 0, -1 } },
        },
    },
}
fuel_plant.fluid_boxes_off_when_no_fluid_recipe = false

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
fuel_plant.icon = "__LavaBlock-graphics__/graphics/icons/items/fuel-plant.png"
fuel_plant.icon_size = 64
fuel_plant.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
-- A white oxygen sphere on legs, a rust-red lagged reactor beside it, and a
-- filling press across the front with a dosing pump's flywheel turning
-- flat beside it.
local GFX = "__LavaBlock-graphics__/graphics/entity/fuel-plant/"

local function layer(kind, dir, extra)
    local name = "fuel-plant-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/fuel-plant/" .. name)
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

local function plant_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

fuel_plant.graphics_set = {
    animation = {
        north = { layers = plant_layers("north") },
        east = { layers = plant_layers("east") },
        south = { layers = plant_layers("south") },
        west = { layers = plant_layers("west") },
    },
}

return fuel_plant
