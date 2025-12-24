local enchanter_item = table.deepcopy(data.raw["item"]["centrifuge"])

enchanter_item.name = "enchanter"
enchanter_item.place_result = "enchanter"
enchanter_item.icon = "__base__/graphics/icons/centrifuge.png"
enchanter_item.icon_size = 64

return enchanter_item
