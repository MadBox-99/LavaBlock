local utils = require("lib.utils")

-- Three roll crushers off one base. They are the same machine mechanically -
-- two toothed rolls turning towards each other - and differ only in what
-- drives them, so the prototype is written once and the differences listed
-- in a table rather than copied into three near-identical files.
--
-- Each has its own sprite folder, because each carries its own tell on the
-- drive bed: a chimney, a motor, an oil tank. The rest of the sprite is the
-- same model rendered three times.

local GFX = "__LavaBlock-graphics__/graphics/entity/"

local function layers(dir_name, dir)
    local out = {}
    for _, kind in ipairs({ "entity", "shadow" }) do
        local name = dir_name .. "-" .. kind .. "-" .. dir
        local sheet = require(GFX .. dir_name .. "/" .. name)
        out[#out + 1] = {
            filename = GFX .. dir_name .. "/" .. name .. ".png",
            priority = "high",
            width = sheet.width,
            height = sheet.height,
            frame_count = sheet.sprite_count,
            line_length = sheet.line_length,
            -- The rolls turn a whole revolution over the sheet, so this is
            -- the actual shaft speed and not a stand-in for one.
            animation_speed = 0.3,
            scale = sheet.scale,
            shift = sheet.shift,
            draw_as_shadow = kind == "shadow" or nil,
        }
    end
    return out
end

-- Lubricant is not fuel and it is not a coolant here: it goes in through the
-- recipe, because an assembling machine has exactly one energy_source and
-- there is no way to draw mains power and a fluid at the same time. The
-- industrial machine is therefore an ordinary electric one with a fluid
-- input, and it is its recipes that ask for the oil.
--
-- North, because that is the edge the model draws the stub on, and a fluid
-- box whose connection is on the far edge from its nozzle gives a machine
-- you plug into thin air.
--
-- Note the sign flip, which is the easy thing to get wrong here and was got
-- wrong once already. Blender's +Y renders at the top of the sprite and the
-- top of a sprite is north, but Factorio counts Y southwards, so north is
-- position {0,-1}. A stub modelled at y = +1.46 is therefore {0,-1}, not
-- {0,1}: the model coordinate and the prototype coordinate have opposite
-- signs. X does not flip - modelled +X is east is {1,0}.
local LUBRICANT_BOX = {
    {
        production_type = "input",
        filter = "lubricant",
        pipe_connections = {
            {
                direction = defines.direction.north,
                position = { 0, -1 },
                flow_direction = "input",
            }
        },
        volume = 400,
    }
}

local TIERS = {
    {
        name = "burner-roll-crusher",
        speed = 0.5,
        modules = 0,
        pollution = 8,
        -- No power line needed, which is the whole point of it: the island
        -- has to be expanded from the first minute and stone is what does
        -- the expanding.
        energy_usage = "150kW",
        energy_source = {
            type = "burner",
            fuel_categories = { "chemical" },
            effectivity = 1,
            fuel_inventory_size = 1,
            emissions_per_minute = { pollution = 8 },
            light_flicker = { color = { 0, 0, 0 } },
        },
        next_upgrade = "roll-crusher",
    },
    {
        name = "roll-crusher",
        speed = 1.0,
        modules = 2,
        pollution = 4,
        energy_usage = "300kW",
        next_upgrade = "industrial-roll-crusher",
    },
    {
        name = "industrial-roll-crusher",
        speed = 1.75,
        modules = 4,
        pollution = 6,
        energy_usage = "500kW",
        categories = { "rock-crushing", "rock-crushing-oiled" },
        fluid_boxes = LUBRICANT_BOX,
    },
}

local crushers = {}

for _, tier in ipairs(TIERS) do
    local c = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
    c.name = tier.name
    c.minable.result = tier.name
    c.crafting_categories = tier.categories or { "rock-crushing" }
    c.crafting_speed = tier.speed
    c.energy_usage = tier.energy_usage
    c.module_slots = tier.modules
    -- Grinding rock finer does not create rock, but Factorio's productivity
    -- is the mod's standard lever for "run it better, get more out", and
    -- every other extraction recipe here allows it. Everything is listed
    -- because a productivity module carries consumption, pollution and speed
    -- effects and cannot be inserted unless all of them are permitted.
    c.allowed_effects = {
        "consumption", "speed", "productivity", "pollution", "quality",
    }
    if tier.modules == 0 then
        c.allowed_effects = nil
    end

    if tier.energy_source then
        c.energy_source = tier.energy_source
    else
        c.energy_source.emissions_per_minute = { pollution = tier.pollution }
    end

    -- All three are the same size and the same machine, so a built one can
    -- be swapped for the next without tearing the belt out.
    c.fast_replaceable_group = "roll-crusher"
    c.next_upgrade = tier.next_upgrade

    -- Three renders of one model differ only in a chimney, a motor or an oil
    -- tank at the back of the drive bed, and at inventory size none of that
    -- survives. The corner badge is what actually tells them apart.
    c.icons = utils.badged_icon(tier.name)
    c.icon = nil
    c.icon_size = nil

    -- Custom model, built and rendered in Blender (see
    -- docs/blender-renders.md). Two toothed rolls turning towards each
    -- other, and nothing drawn over them: one drum turning could be a mixer
    -- or a kiln, but two turning into each other say "this machine makes
    -- rock smaller" in a single frame. Each roll is driven by an eccentric
    -- and a connecting rod running in a cylinder that leans out of the way.
    c.graphics_set = {
        animation = {
            north = { layers = layers(tier.name, "north") },
            east = { layers = layers(tier.name, "east") },
            south = { layers = layers(tier.name, "south") },
            west = { layers = layers(tier.name, "west") },
        },
    }

    -- Solids in, solids out: the lava is quenched into basalt in a chemical
    -- plant long before it reaches any of these. Only the industrial one has
    -- a port, and it is for the lubricant its own recipes want.
    c.fluid_boxes = tier.fluid_boxes
    -- assembling-machine-2 hides its fluid boxes until a fluid recipe is
    -- set. That is wrong here: the port is part of the model and always
    -- visible, so a pipe has to be able to reach it on an empty machine -
    -- otherwise the oil line cannot be laid before the recipe is chosen.
    c.fluid_boxes_off_when_no_fluid_recipe = nil
    utils.remove_pipe_covers(c)

    crushers[#crushers + 1] = c
end

return crushers
