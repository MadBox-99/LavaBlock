-- The oldest way there is to make a brick: wet the crushed rock, tread it,
-- press it into a mould and leave it in the sun. This machine does the first
-- three; the sun is the item's own drying timer.
--
-- What it is really for is the furnace, not the lava. A brick out of the
-- chemical plant costs 5000 lava; crushed and fired it costs about 333, so
-- the smelting recipe is already a first-ten-minutes thing by the time
-- anyone reads this. What the crushing route still needs is a furnace and
-- fuel for the last step, and that is what drying replaces: the same bricks
-- out of the same gravel, with no kiln and no fuel, paid for in time and in
-- the space to stack them while they dry.
local pug_mill = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
pug_mill.name = "pug-mill"
pug_mill.minable.result = "pug-mill"
pug_mill.crafting_categories = { "adobe-mixing" }
pug_mill.crafting_speed = 1.0
-- Low. It turns a paddle through wet grit; it does not heat anything, and
-- the whole argument for the machine is that it costs no fuel.
pug_mill.energy_usage = "90kW"
pug_mill.next_upgrade = nil
pug_mill.fast_replaceable_group = nil

pug_mill.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    -- Almost nothing: mixing mud is not combustion. The Quench Pit pollutes
    -- twelve a minute for comparison, and a chemical plant four.
    emissions_per_minute = { pollution = 1 },
}

pug_mill.module_slots = 2
pug_mill.allowed_effects = { "speed", "consumption", "pollution", "productivity" }

-- Water in on the north face only. One inlet, filtered: the machine takes
-- exactly one fluid and a named filter puts its icon on the connection, so a
-- misplumbed pipe shows before it is built.
pug_mill.fluid_boxes = {
    {
        production_type = "input",
        filter = "water",
        volume = 400,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north,
              position = { 0, -1 } },
        },
    },
}
pug_mill.fluid_boxes_off_when_no_fluid_recipe = false

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
pug_mill.icon = "__LavaBlock-graphics__/graphics/icons/items/pug-mill.png"
pug_mill.icon_size = 64
pug_mill.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
-- A fired-clay tub with an iron paddle turning through the mix, and a timber
-- bench of moulds beside it. Deliberately the least mechanical building in
-- the mod: everything else here is plate and pipe, and this one's whole
-- argument is that it needs no furnace and hardly any power.
--
-- Four facings, unlike the Quench Pit's one: the water inlet and the bench
-- are on named sides and both have to turn with the entity.
local GFX = "__LavaBlock-graphics__/graphics/entity/pug-mill/"

local function layer(kind, dir, extra)
    local name = "pug-mill-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/pug-mill/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Slow. It is an ox-walk paddle through wet grit, not a fan.
        animation_speed = 0.4,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function mill_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

pug_mill.graphics_set = {
    animation = {
        north = { layers = mill_layers("north") },
        east = { layers = mill_layers("east") },
        south = { layers = mill_layers("south") },
        west = { layers = mill_layers("west") },
    },
}

return pug_mill
