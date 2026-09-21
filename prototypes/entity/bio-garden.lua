local bio_garden = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
bio_garden.name = "bio-garden"
bio_garden.minable.result = "bio-garden"
bio_garden.crafting_categories = { "bio-garden" }
bio_garden.crafting_speed = 1.0
-- Lamps and a circulation pump; the planting does the work.
bio_garden.energy_usage = "150kW"
bio_garden.module_slots = 2
-- Everything is allowed here, unlike the condenser. Getting more substance
-- out of the same harvest is what a better press does, so productivity is
-- honest here. Productivity modules also carry a pollution effect, which
-- multiplies a negative emission - so a productivity-stuffed garden scrubs
-- slightly harder, which is the right way round. Efficiency modules cut
-- consumption and therefore cut absorption too, which is the trade the
-- player gets to make.
bio_garden.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
bio_garden.fluid_boxes_off_when_no_fluid_recipe = true
bio_garden.next_upgrade = nil

-- The point of the building. Emissions scale with how hard the machine is
-- working, so a garden only scrubs while it is actually running a craft -
-- feed it water and power or it cleans nothing. Matched to Space Age's
-- biochamber, the one vanilla machine that also absorbs; a vanilla tree is
-- 0.06 a minute, so one garden stands in for roughly seventeen trees, which
-- is the thing this island does not have.
bio_garden.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = -1 },
}

-- Same icon as the item, so alt-mode and Factoriopedia match the new model
bio_garden.icon = "__LavaBlock__/graphics/icons/items/bio-garden.png"
bio_garden.icon_size = 64
bio_garden.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
-- A ribbed glass dome over a settling pan and a press: round and small
-- against the arboretum's big square glasshouse, so the two read as the same
-- family without being the same building. The culture tubes that used to
-- stand in here moved to the algae tank along with the growing.
local GFX = "__LavaBlock__/graphics/entity/bio-garden/"

local function layer(kind, dir, extra)
    local name = "bio-garden-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock__/graphics/entity/bio-garden/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Slow. The tubes fill over one pass of the sheet, and growth that
        -- takes half a second does not read as growth.
        animation_speed = 0.12,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function garden_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

-- No idle_animation: Factorio requires it to match `animation`'s frame count,
-- and with `animation` alone the stirrer simply stops when the machine does.
--
-- The algae is a working visualisation rather than part of the animation, for
-- two reasons. Factorio multiplies it by the recipe's primary tint, so one
-- sheet shows green, blue or red cultures depending on what is piped in; and
-- a working visualisation is only drawn while the machine runs, so an idle
-- garden correctly shows six empty tubes.
bio_garden.graphics_set = {
    animation = {
        north = { layers = garden_layers("north") },
        east = { layers = garden_layers("east") },
        south = { layers = garden_layers("south") },
        west = { layers = garden_layers("west") },
    },
    working_visualisations = {
        {
            apply_recipe_tint = "primary",
            north_animation = layer("tint", "north"),
            east_animation = layer("tint", "east"),
            south_animation = layer("tint", "south"),
            west_animation = layer("tint", "west"),
        },
    },
}

-- No pipe_picture or pipe_covers: the model carries its own ports. See
-- docs/blender-renders.md for why the two cannot be mixed.
--
-- Water in, liquid nitrogen out. Only one of the three recipes touches fluid
-- at all - fibre pressing and calcite precipitation are solids both ends -
-- so the pipes vanish on those, which is what
-- `fluid_boxes_off_when_no_fluid_recipe` is for.
bio_garden.fluid_boxes = {
    {
        production_type = "input",
        filter = "water",
        pipe_connections = {
            { direction = 0, position = { 0, -1 }, flow_direction = "input", }
        },
        volume = 1000,
    },
    {
        production_type = "output",
        filter = "liquid-nitrogen",
        pipe_connections = {
            { direction = 8, position = { 0, 1 }, flow_direction = "output", }
        },
        volume = 1000,
    }
}

return bio_garden
