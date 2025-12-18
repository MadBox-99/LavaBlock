local air_cooler_item = table.deepcopy(data.raw["item"]["pump"])

air_cooler_item.name = "air-cooler"
air_cooler_item.place_result = "air-cooler"
air_cooler_item.icon = "__LavaBlock__/graphics/icons/compressor_mini.png"
air_cooler_item.icon_size = 64

return air_cooler_item
