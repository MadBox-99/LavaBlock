local water_condenser = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
water_condenser.name = "water-condenser"
water_condenser.minable.result = "water-condenser"
water_condenser.crafting_categories = { "water-condensing" }
water_condenser.crafting_speed = 1.0
-- Condensing means throwing heat away, and on a lava island there is nowhere
-- cool to throw it: the fans have to do the work. That power draw is the price
-- of the far better steam-to-water ratio this machine gives over a chemical
-- plant, and it is what keeps the water route a real decision.
water_condenser.energy_usage = "600kW"
water_condenser.module_slots = 3
-- No productivity: the recipe turns one fluid into another, so a productivity
-- bonus would be free matter rather than a better process.
water_condenser.allowed_effects = { "consumption", "speed", "pollution" }
water_condenser.fluid_boxes_off_when_no_fluid_recipe = true
water_condenser.next_upgrade = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the new model
water_condenser.icon = "__LavaBlock-graphics__/graphics/icons/items/water-condenser.png"
water_condenser.icon_size = 64
water_condenser.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
-- Light steel and teal against the compressor's dark blue-grey and the
-- centrifuge's orange: three machines, three silhouettes, told apart at a
-- glance on a crowded base.
-- One sheet pair per facing: the fluid connections rotate with the entity, so
-- the modelled ports have to rotate with them. Dimensions and shift are read
-- from the data files spritter writes next to each sheet, so a re-pack never
-- needs numbers copied by hand.
local GFX = "__LavaBlock-graphics__/graphics/entity/water-condenser/"

local function layer(kind, dir, extra)
    local name = "water-condenser-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/water-condenser/" .. name)
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
water_condenser.graphics_set = {
    animation = {
        north = { layers = fan_layers("north") },
        east = { layers = fan_layers("east") },
        south = { layers = fan_layers("south") },
        west = { layers = fan_layers("west") },
    },
}

-- Filtered on both sides. The machine does one job, and a named filter puts
-- the fluid icon on the connection so a misplumbed pipe is visible before it
-- is built rather than after the steam has gone somewhere it should not.
--
-- No pipe_picture or pipe_covers: the model carries its own ports. Both are
-- one-tile sprites drawn on the connection's own tile, so neither can meet a
-- modelled stub that reaches past it - the cover lands as a brass disc
-- floating half a tile up the body. It is one or the other, and here it is
-- the model. See docs/blender-renders.md.
water_condenser.fluid_boxes = {
    {
        production_type = "input",
        filter = "steam",
        pipe_connections = {
            { direction = 0, position = { 0, -1 }, flow_direction = "input", }
        },
        volume = 1000,
    },
    {
        production_type = "output",
        filter = "water",
        pipe_connections = {
            { direction = 8, position = { 0, 1 }, flow_direction = "output", }
        },
        volume = 1000,
    }
}

return water_condenser
