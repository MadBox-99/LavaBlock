local air_compressor = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
local number_tint = { r = 1, g = 1, b = 1, a = 1 }
air_compressor.name = "air-compressor"
air_compressor.minable.result = "air-compressor"
air_compressor.crafting_categories = { "gas" }
air_compressor.crafting_speed = 2.0
air_compressor.fluid_boxes_off_when_no_fluid_recipe = true
air_compressor.graphics_set.animation = {
    filename = "__LavaBlock__/graphics/entity/air-filter/air-filter.png",
    width = 128,
    height = 128,
    frame_count = 1,
    tint = number_tint,
}
air_compressor.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            { direction = 0, position = { 0, -1 }, flow_direction = "input", }
        },
        base_area = 10,
        base_level = -1,
        height = 2,
        --pipe_picture = assembler2pipepictures(),
        --pipe_covers = pipecoverspictures(),
        volume = 1000,
    },
    {
        production_type = "output",
        pipe_connections = {
            { direction = 8, position = { 0, 1 }, flow_direction = "output", }
        },
        base_area = 10,
        base_level = 1,
        height = 2,
        --pipe_picture = assembler2pipepictures(),
        --pipe_covers = pipecoverspictures(),
        volume = 1000,
    }
}

return air_compressor