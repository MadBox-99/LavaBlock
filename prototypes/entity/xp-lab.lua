-- XP Lab - Dedicated lab for XP science packs only
local xp_lab = table.deepcopy(data.raw["lab"]["lab"])
xp_lab.name = "xp-lab"
xp_lab.minable.result = "xp-lab"

-- Only accepts XP science packs - keeps base lab separate
xp_lab.inputs = { "xp-science-pack" }

-- Purple/violet theme for RPG aesthetic
xp_lab.light = {
    intensity = 0.75,
    size = 8,
    color = { r = 0.7, g = 0.3, b = 1.0 }
}

-- Performance settings
xp_lab.researching_speed = 1
xp_lab.energy_usage = "100kW"
xp_lab.module_slots = 2

-- Same icon as the item, so alt-mode and Factoriopedia match the model. It
-- was the vanilla lab's icon under a violet tint, which made this building
-- a recoloured copy of the one standing next to it rather than its own
-- thing.
xp_lab.icon = "__LavaBlock-graphics__/graphics/icons/items/xp-lab.png"
xp_lab.icon_size = 64
xp_lab.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
--
-- Cut stone with amethyst growing out of it: four buttresses with crystal
-- tips, a reading desk on the south face, and a six-sided crystal floating
-- and turning over the central pedestal with four smaller ones orbiting it.
-- The only non-industrial building in the mod, because what it reads is the
-- enchanted science pack and not a bottle of chemicals. The amethyst is the
-- same material the crystallizer grows.
--
-- One sheet, not four: a lab has no facing. Factorio asks for an
-- `on_animation` and an `off_animation` and never for a direction.
local GFX = "__LavaBlock-graphics__/graphics/entity/xp-lab/"

local function layer(kind, extra)
    local name = "xp-lab-" .. kind .. "-north"
    local sheet = require("__LavaBlock-graphics__/graphics/entity/xp-lab/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Slow. A crystal turning over a pedestal is not a fan, and at any
        -- speed that reads as machinery the whole conceit falls over.
        animation_speed = 0.25,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

-- The idle sheet is the running sheet read one frame deep. Rendering a
-- second sheet for it would cost as much again and differ from this one by
-- nothing: an idle lab is this machine with its crystals held still, which
-- is exactly frame zero.
local function still(l)
    l.frame_count = 1
    l.line_length = 1
    return l
end

xp_lab.on_animation = {
    layers = {
        layer("entity"),
        layer("shadow", { draw_as_shadow = true }),
    },
}
xp_lab.off_animation = {
    layers = {
        still(layer("entity")),
        still(layer("shadow", { draw_as_shadow = true })),
    },
}
-- Inherited from the vanilla lab and now wrong twice over: it points at the
-- base lab's sheet, and this building has no snow-covered variant of its
-- own to point at instead.
xp_lab.frozen_patch = nil

return xp_lab
