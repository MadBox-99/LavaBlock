local air_compressor_item = {
    type = "item",
    name = "air-compressor",
    icon = "__LavaBlock__/graphics/icons/items/air-compressor.png",
    icon_size = 64,
    subgroup = "production-machine",
    order = "b[assembling-machine-3]",
    place_result = "air-compressor",
    stack_size = 50,

}
data:extend({ air_compressor_item })