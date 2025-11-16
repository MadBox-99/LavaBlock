local air_cooler_item = table.deepcopy(data.raw["item"]["chemical-plant"])

air_cooler_item.name = "air-cooler"
air_cooler_item.place_result = "air-cooler"
air_cooler_item.icon = "__base__/graphics/icons/chemical-plant.png"
air_cooler_item.icon_size = 64

data:extend({ air_cooler_item })
