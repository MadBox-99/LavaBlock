local air_compressor = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
local number_tint = { r = 1, g = 1, b = 1, a = 1 }
air_compressor.name = "air-compressor"
air_compressor.minable.result = "air-compressor"
air_compressor.crafting_categories = { "gas" }
air_compressor.crafting_speed = 2.0
air_compressor.graphics_set.animation = {
    filename = "__LavaBlock__/graphics/entity/air-filter/air-filter.png",
    width = 128,
    height = 128,
    frame_count = 1,
    tint = number_tint,
}
return air_compressor