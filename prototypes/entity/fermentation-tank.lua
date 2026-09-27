-- A closed vessel where biomass and water sit with enzymes and yeast until
-- the sugar in them has turned to alcohol. Straw, wood or green algae go in
-- by inserter, water by pipe, and what comes out is wash for the column.
--
-- Its own building rather than a chemical plant recipe, because a ferment is
-- slow and a chemical plant is fast: twenty seconds a batch at speed 1 is
-- the tank's whole character, and four of them feed one column.
local fermentation_tank = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
fermentation_tank.name = "fermentation-tank"
fermentation_tank.minable.result = "fermentation-tank"
fermentation_tank.crafting_categories = { "biomass-fermenting" }
fermentation_tank.crafting_speed = 1.0
-- An agitator and the chiller on the jacket. Fermenting gives off heat and
-- yeast dies above about 35 C, so most of the power is spent keeping the
-- brew cool, not stirring it.
fermentation_tank.energy_usage = "150kW"
fermentation_tank.next_upgrade = nil
fermentation_tank.fast_replaceable_group = nil

fermentation_tank.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = 1 },
}

fermentation_tank.module_slots = 2
-- A better-kept ferment really does yield more alcohol, so productivity is
-- allowed; a productivity module also carries the other effects and cannot
-- be inserted unless all of them are.
fermentation_tank.allowed_effects = {
    "consumption", "speed", "productivity", "pollution", "quality",
}

-- No pipe_picture or pipe_covers: the model carries its own ports. See
-- docs/blender-renders.md for why the two cannot be mixed.
--
-- Water in on the north face, wash out on the south, both filtered so a
-- misplumbed pipe shows its icon on the connection before it is built.
fermentation_tank.fluid_boxes = {
    {
        production_type = "input",
        filter = "water",
        volume = 1000,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north,
              position = { 0, -1 } },
        },
    },
    {
        production_type = "output",
        filter = "fermented-wash",
        volume = 1000,
        pipe_connections = {
            { flow_direction = "output", direction = defines.direction.south,
              position = { 0, 1 } },
        },
    },
}
fermentation_tank.fluid_boxes_off_when_no_fluid_recipe = false

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
fermentation_tank.icon = "__LavaBlock-graphics__/graphics/icons/items/fermentation-tank.png"
fermentation_tank.icon_size = 64
fermentation_tank.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
-- A squat stainless vessel with a conical roof, dimpled cooling jacket
-- bands and a sight glass on each quarter, with the agitator drive turning
-- on top and a CO2 vent pot beside it.
local GFX = "__LavaBlock-graphics__/graphics/entity/fermentation-tank/"

local function layer(kind, dir, extra)
    local name = "fermentation-tank-" .. kind .. "-" .. dir
    local sheet = require("__LavaBlock-graphics__/graphics/entity/fermentation-tank/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Slow. An agitator in a fermenter turns gently; a fast one would
        -- shear the yeast.
        animation_speed = 0.35,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function tank_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

-- The brew in the sight glass is a working visualisation, tinted by the
-- recipe: straw gold, wood brown, algae green. Drawn only while the tank
-- runs, so an idle tank shows a dark, empty window.
fermentation_tank.graphics_set = {
    animation = {
        north = { layers = tank_layers("north") },
        east = { layers = tank_layers("east") },
        south = { layers = tank_layers("south") },
        west = { layers = tank_layers("west") },
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

return fermentation_tank
