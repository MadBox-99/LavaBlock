-- A hole in the crust with a machine built over it. Whatever you pipe in
-- goes down into the lava the island floats on and comes back as weather.
--
-- Why this exists: nothing in the mod produced a byproduct you were forced
-- to get rid of, so every surplus fluid had to be stored or the line had to
-- be throttled. That is the wrong kind of difficulty - it is bookkeeping,
-- not a decision. A sink makes the surplus a cost instead: you can always
-- get rid of it, and getting rid of it dirties the air.
--
-- The pollution is the whole balance. Quenching is free of items, free of
-- research after the first technology, and available from early on; if it
-- were clean it would be a button that deletes a problem. At 12 per minute
-- it is three chemical plants' worth of smoke for one pit, which is enough
-- that a base voiding a lot of fluid has to answer for it somewhere - and
-- the Bio Garden is the only thing on this island that answers.
local quench_pit = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
quench_pit.name = "quench-pit"
quench_pit.minable.result = "quench-pit"
quench_pit.crafting_categories = { "fluid-quenching" }
quench_pit.crafting_speed = 1.0
quench_pit.energy_usage = "150kW"
quench_pit.next_upgrade = nil
quench_pit.fast_replaceable_group = nil

quench_pit.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = 12 },
}

-- Efficiency modules are the point of having slots at all: they are the
-- only way to make voiding cleaner, which turns "how much do I dump" into a
-- question with an answer the player can buy. Productivity is deliberately
-- absent - there is no product to multiply, and quality would be nonsense.
quench_pit.module_slots = 2
quench_pit.allowed_effects = { "speed", "consumption", "pollution" }

-- One unfiltered input, reachable from all four sides. Unfiltered because
-- the machine's whole job is that it does not care what arrives; the recipe
-- decides what it drinks, and a pump's filter is what guards the line.
--
-- The buffer is deliberately large. A pit is fed by whatever overflows, in
-- surges rather than in a steady stream, and a small tank would back the
-- surge up into the pipe it is supposed to be relieving.
quench_pit.fluid_boxes = {
    {
        production_type = "input",
        volume = 2000,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } },
            { flow_direction = "input", direction = defines.direction.east,  position = { 1, 0 } },
            { flow_direction = "input", direction = defines.direction.south, position = { 0, 1 } },
            { flow_direction = "input", direction = defines.direction.west,  position = { -1, 0 } },
        },
    },
}
quench_pit.fluid_boxes_off_when_no_fluid_recipe = false

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
quench_pit.icon = "__LavaBlock-graphics__/graphics/icons/items/quench-pit.png"
quench_pit.icon_size = 64
quench_pit.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
-- Black basalt and hazard yellow: every other machine in the mod is steel,
-- teal, blue-grey or orange, and none of them is black, which is the right
-- colour for the one building whose job is to destroy what you feed it.
--
-- ONE SHEET, NOT FOUR. Every other machine here needs a sheet per facing
-- because its modelled ports have to rotate with its fluid connections. This
-- one has the same connection on all four sides, so a rotated pit is
-- indistinguishable from an unrotated one and three of the four sheets would
-- be identical pictures - a quarter of the render time and a quarter of the
-- download for exactly the same result.
local GFX = "__LavaBlock-graphics__/graphics/entity/quench-pit/"

local function layer(kind, extra)
    local name = "quench-pit-" .. kind .. "-north"
    local sheet = require("__LavaBlock-graphics__/graphics/entity/quench-pit/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Slow. The rams are dosing and the melt is breathing, not racing;
        -- at 1.0 a 32-frame loop of a heave reads as a vibration.
        animation_speed = 0.5,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

quench_pit.graphics_set = {
    animation = {
        layers = {
            layer("entity"),
            layer("shadow", { draw_as_shadow = true }),
        },
    },
}

return quench_pit
