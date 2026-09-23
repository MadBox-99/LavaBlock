require("__core__.lualib.util")
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.assemblerpipes")
local geo_thermal_turbine = table.deepcopy(data.raw["generator"]["steam-turbine"])
geo_thermal_turbine.name = "geo-thermal-turbine"
geo_thermal_turbine.flags = { "placeable-neutral", "player-creation" }
geo_thermal_turbine.minable = { mining_time = 1, result = "geo-thermal-turbine" }
geo_thermal_turbine.max_health = 400
geo_thermal_turbine.corpse = "big-remnants"
geo_thermal_turbine.dying_explosion = "medium-explosion"
geo_thermal_turbine.effectivity = 1
geo_thermal_turbine.fluid_usage_per_tick = 1
geo_thermal_turbine.maximum_temperature = 2500
geo_thermal_turbine.burns_fluid = true
geo_thermal_turbine.fluid_box.filter = "lava"
geo_thermal_turbine.fluid_box.minimum_temperature = 1000
geo_thermal_turbine.fast_replaceable_group = "geo-thermal-turbine"

-- Same icon as the item, so alt-mode and Factoriopedia match the model. It
-- wore the vanilla steam turbine's icon until now, which said the one thing
-- about this machine that is not true: there is no steam in it anywhere.
geo_thermal_turbine.icon = "__LavaBlock__/graphics/icons/items/geo-thermal-turbine.png"
geo_thermal_turbine.icon_size = 64
geo_thermal_turbine.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
--
-- A lava-fired engine: a lagged barrel with a glowing feed running up its
-- west flank, scorched ochre at the hot end and clean steel at the generator
-- end, three rams working in sequence up the east flank, a spoked flywheel
-- standing above the casing and an extractor lying flat on the generator
-- can.
--
-- A generator takes two animations, not four. Factorio asks for
-- `vertical_animation` and `horizontal_animation` and never for a direction,
-- so the model is rendered north for the vertical one and east for the
-- horizontal one - half the frames a rotatable machine needs.
local GFX = "__LavaBlock__/graphics/entity/geo-thermal-turbine/"

local function layer(kind, dir, extra)
    local name = "geo-thermal-turbine-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock__/graphics/entity/geo-thermal-turbine/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- A turbine runs fast. This is the quickest animation in the mod
        -- and it should be: everything else here stirs, grows or breathes.
        animation_speed = 1.0,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function turbine_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

-- North is the vertical sheet and east is the horizontal one, which is the
-- only mapping that exists: the model's long axis runs north-south.
geo_thermal_turbine.vertical_animation = { layers = turbine_layers("north") }
geo_thermal_turbine.horizontal_animation = { layers = turbine_layers("east") }

-- No pipe_picture or pipe_covers: the model carries its own ports, one at
-- each end, the way the steam turbine it replaces does. See
-- docs/blender-renders.md for why the two cannot be mixed.
geo_thermal_turbine.fluid_box.pipe_covers = nil
geo_thermal_turbine.fluid_box.pipe_picture = nil

return geo_thermal_turbine
