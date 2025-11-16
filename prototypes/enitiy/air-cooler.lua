local air_cooler = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])

air_cooler.name = "air-cooler"
air_cooler.minable.result = "air-cooler"
air_cooler.collision_box = { { -0.4, -1.4 }, { 0.4, 1.4 } }
air_cooler.selection_box = { { -0.5, -1.5 }, { 0.5, 1.5 } }
air_cooler.tile_width = 1
air_cooler.tile_height = 3

-- Using base game chemical plant icon
air_cooler.icon = "__base__/graphics/icons/chemical-plant.png"
air_cooler.icon_size = 64

-- Completely rebuild fluid boxes for 1x3 vertical layout
-- Direction: 0 = north, 4 = south
-- Positions must be within collision_box bounds: {{-0.4, -1.4}, {0.4, 1.4}}
air_cooler.fluid_boxes = {
    -- Input box (north/top)
    {
        production_type = "input",
        pipe_connections = {
            {flow_direction = "input", direction = 0, position = {0, -1}}
        },
        volume = 1000,
    },
    -- Output box (south/bottom)
    {
        production_type = "output",
        pipe_connections = {
            {flow_direction = "output", direction = 4, position = {0, 1}}
        },
        volume = 1000,
    },
}

return air_cooler
