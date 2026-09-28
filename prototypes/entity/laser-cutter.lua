-- A ruby laser over a cutting bed. It cuts crystal into the thin, flat
-- pieces electronics are built on: silica into silicon wafers, sapphire into
-- substrate.
--
-- 800 kW, which is a lot for a 3x3 machine that moves one arm. A laser turns
-- most of what it draws into heat rather than light, and a cutter that ran
-- on crafting-machine power would make a precision tool the cheapest thing
-- on the grid.
local laser_cutter = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
laser_cutter.name = "laser-cutter"
laser_cutter.minable.result = "laser-cutter"
laser_cutter.crafting_categories = { "laser-cutting" }
laser_cutter.crafting_speed = 1.0
laser_cutter.energy_usage = "800kW"
laser_cutter.module_slots = 2
laser_cutter.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}
laser_cutter.next_upgrade = nil
laser_cutter.fast_replaceable_group = nil

-- Nothing to pipe in or out: it cuts solids. assembling-machine-2's boxes
-- would put ports on a machine whose model has none.
laser_cutter.fluid_boxes = nil
laser_cutter.fluid_boxes_off_when_no_fluid_recipe = nil

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
laser_cutter.icon = "__LavaBlock-graphics__/graphics/icons/items/laser-cutter.png"
laser_cutter.icon_size = 64
laser_cutter.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md):
-- a slatted bed at the front, the ruby rod glowing red in its housing along
-- the back, and a yellow boom swinging the cutting head back and forth over
-- the blank. Nothing stands over the bed but the boom itself.
--
-- ONE SHEET, NOT FOUR. There are no fluid connections to turn with the
-- machine, so every facing is the same picture; see the quench pit.
local GFX = "__LavaBlock-graphics__/graphics/entity/laser-cutter/"

local function layer(kind, extra)
    local name = "laser-cutter-" .. kind .. "-north"
    local sheet = require("__LavaBlock-graphics__/graphics/entity/laser-cutter/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Unhurried. A cutting head that sweeps its whole arc twice a second
        -- is a windscreen wiper, not a laser.
        animation_speed = 0.35,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

laser_cutter.graphics_set = {
    animation = {
        layers = {
            layer("entity"),
            layer("shadow", { draw_as_shadow = true }),
        },
    },
    -- The blank on the bed takes the recipe's colour, and is drawn only
    -- while the machine runs: an idle cutter has an empty bed.
    working_visualisations = {
        {
            apply_recipe_tint = "primary",
            animation = layer("tint"),
        },
    },
}

return laser_cutter
