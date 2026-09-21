local air_cooler_item = table.deepcopy(data.raw["item"]["pump"])

air_cooler_item.name = "air-cooler"
air_cooler_item.place_result = "air-cooler"
-- Rendered from the same Blender model as the entity, so the icon and the
-- machine on the ground are plainly the same object.
air_cooler_item.icon = "__LavaBlock__/graphics/icons/items/air-cooler.png"
air_cooler_item.icon_size = 64
air_cooler_item.icons = nil

return air_cooler_item
