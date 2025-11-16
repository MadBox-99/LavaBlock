-- Base: chemical plant (for assembling-machine functionality)
-- Graphics: pump animations and visuals
---@diagnostic disable-next-line: undefined-field, inject-field
local pump = data.raw["pump"]["pump"]
---@diagnostic disable-next-line: undefined-field, inject-field
local chem_plant = data.raw["assembling-machine"]["chemical-plant"]

-- Start with chemical plant for functionality
---@diagnostic disable: inject-field, undefined-field
local air_cooler = table.deepcopy(chem_plant)
air_cooler.name = "air-cooler"
air_cooler.minable.result = "air-cooler"

-- Use pump-style collision/selection boxes for 1x3 size
air_cooler.collision_box = {{-0.29, -1.4}, {0.29, 1.4}}
air_cooler.selection_box = {{-0.5, -1.5}, {0.5, 1.5}}
air_cooler.tile_width = 1
air_cooler.tile_height = 3

-- Copy pump visuals (icon and animations)
air_cooler.icon = pump.icon
air_cooler.icon_size = pump.icon_size
if pump.icons then
    air_cooler.icons = pump.icons
end

-- Copy pump graphics
air_cooler.graphics_set = nil -- Clear chemical plant graphics
air_cooler.animation = pump.animations
air_cooler.fluid_animation = pump.fluid_animation
air_cooler.glass_pictures = pump.glass_pictures
air_cooler.working_visualisations = pump.working_visualisations

-- Fluid boxes for 1x3 layout (must be within collision_box)
air_cooler.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            {flow_direction = "input-output", direction = 0, position = {0, -1.3}}
        },
        volume = 1000,
    },
    {
        production_type = "output",
        pipe_connections = {
            {flow_direction = "input-output", direction = 4, position = {0, 1.3}}
        },
        volume = 1000,
    },
}

return air_cooler
