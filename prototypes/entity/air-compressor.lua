local air_compressor = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
air_compressor.name = "air-compressor"
air_compressor.minable.result = "air-compressor"
air_compressor.crafting_categories = { "gas", "gas-mix" }
air_compressor.crafting_speed = 2.0
-- Inherited from assembling-machine-3 this was 375 kW, which made the air route
-- cheaper in energy AND in area than the lava route. Extracting ore from air is
-- meant to trade power for lava, so state the cost explicitly.
air_compressor.energy_usage = "1500kW"
air_compressor.fluid_boxes_off_when_no_fluid_recipe = true

-- Same icon as the item, so alt-mode and Factoriopedia match the model. The
-- rendered icon has existed since this machine got its model, but only the
-- item was pointed at it, so the entity went on wearing assembling machine
-- 3's picture everywhere the item icon is not what gets drawn.
air_compressor.icon = "__LavaBlock__/graphics/icons/items/air-compressor.png"
air_compressor.icon_size = 64
air_compressor.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
-- Cold grey against the lava centrifuge's orange, because this is the air
-- route rather than the lava route and the two need telling apart at a glance.
-- One sheet pair per facing: the fluid connections rotate with the entity, so
-- the modelled ports have to rotate with them. Dimensions and shift are read
-- from the data files spritter writes next to each sheet, so a re-pack never
-- needs numbers copied by hand.
local GFX = "__LavaBlock__/graphics/entity/air-compressor/"

local function layer(kind, dir, extra)
    local name = "air-compressor-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock__/graphics/entity/air-compressor/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        animation_speed = 1.0,          -- it is a fan, it should look busy
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function fan_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

-- No idle_animation: Factorio requires it to match `animation`'s frame count,
-- and with `animation` alone the fan simply freezes when the machine stops.
air_compressor.graphics_set = {
    animation = {
        north = { layers = fan_layers("north") },
        east = { layers = fan_layers("east") },
        south = { layers = fan_layers("south") },
        west = { layers = fan_layers("west") },
    },
}
air_compressor.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            { direction = 0, position = { 0, -1 }, flow_direction = "input", }
        },
        base_area = 10,
        base_level = -1,
        height = 2,
        --pipe_picture = assembler2pipepictures(),
        --pipe_covers = pipecoverspictures(),
        volume = 1000,
    },
    {
        production_type = "output",
        pipe_connections = {
            { direction = 8, position = { 0, 1 }, flow_direction = "output", }
        },
        base_area = 10,
        base_level = 1,
        height = 2,
        --pipe_picture = assembler2pipepictures(),
        --pipe_covers = pipecoverspictures(),
        volume = 1000,
    }
}

return air_compressor