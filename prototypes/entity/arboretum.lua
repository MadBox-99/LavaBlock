local arboretum = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
arboretum.name = "arboretum"
arboretum.minable.result = "arboretum"
arboretum.crafting_categories = { "arboretum" }
arboretum.crafting_speed = 1.0
-- Grow lamps and an irrigation pump, on a world with no sun worth the name.
arboretum.energy_usage = "800kW"
arboretum.module_slots = 4
-- Productivity is allowed here, unlike the condenser: this is cultivation, not
-- a fluid changing state, so a better process genuinely yields more timber.
arboretum.allowed_effects = { "consumption", "speed", "pollution", "productivity" }
arboretum.fluid_boxes_off_when_no_fluid_recipe = true
arboretum.next_upgrade = nil

-- Five by five. Everything else in the mod is 3x3, so the boxes have to be set
-- explicitly; Factorio derives the tile footprint from the collision box, and
-- an inherited 3x3 box would leave the sprite hanging over its own tiles.
arboretum.collision_box = { { -2.4, -2.4 }, { 2.4, 2.4 } }
arboretum.selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }

-- Same icon as the item, so alt-mode and Factoriopedia match the new model
arboretum.icon = "__LavaBlock__/graphics/icons/items/arboretum.png"
arboretum.icon_size = 64
arboretum.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
-- Green and glass against the compressor's blue-grey, the condenser's teal and
-- the centrifuge's orange. One sheet pair per facing: the water connection
-- rotates with the entity, so the modelled port has to rotate with it.
-- Dimensions and shift are read from the data files spritter writes next to
-- each sheet, so a re-pack never needs numbers copied by hand.
local GFX = "__LavaBlock__/graphics/entity/arboretum/"

local function layer(kind, dir, extra)
    local name = "arboretum-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock__/graphics/entity/arboretum/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Slower than the fans: an irrigation boom that whipped round would
        -- look like a helicopter rather than a sprinkler.
        animation_speed = 0.35,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function boom_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

-- No idle_animation: Factorio requires it to match `animation`'s frame count,
-- and with `animation` alone the boom simply stops when the machine stops.
arboretum.graphics_set = {
    animation = {
        north = { layers = boom_layers("north") },
        east = { layers = boom_layers("east") },
        south = { layers = boom_layers("south") },
        west = { layers = boom_layers("west") },
    },
}

-- Water only, and only on the north face. The seed recipe needs no fluid at
-- all, which is what fluid_boxes_off_when_no_fluid_recipe is for: the pipe
-- stops being drawn when the machine is set to make seeds.
arboretum.fluid_boxes = {
    {
        production_type = "input",
        filter = "water",
        pipe_connections = {
            { direction = 0, position = { 0, -2 }, flow_direction = "input", }
        },
        volume = 2000,
    },
}

return arboretum
